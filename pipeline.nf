// Stockage des ID SRA
myFile = file('test.txt') // TODO, changer en 'SRAid.txt'
allLines = myFile.readLines()

// Télécharge les fichiers fastq
process downloadFastQ{
	input:
	val sraid from allLines

	output:
	tuple val("${sraid}"), file("${sraid}_1.fastq.gz"), file("${sraid}_2.fastq.gz") into fastqgz

	"""
	fasterq-dump --threads ${task.cpus} --split-files ${sraid}
	gzip *.fastq
	"""
}

// Stockage des noms des chromosomes
chromo = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","MT"]

// Télécharge les données du génome humain
process downloadChr{
	input:
	val chromosome from chromo

	output:
	file "*.fa.gz" into chromofagz

	"""
	wget ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.${chromosome}.fa.gz
	"""
}

// Création de l'index du génome
process indexGenome {
	container 'evolbioinfo/star:v2.7.6a'

	input:
	file "*.fa.gz" from chromofagz.collect()

	output:
    	path ref into indexgenome

    	script:
    	"""
    	gunzip -c *.fa.gz > ref.fa
    	mkdir ref
    	STAR --runThreadN ${task.cpus} --runMode genomeGenerate --genomeDir ref/ --genomeFastaFiles ref.fa
    	"""
}


// Télécharge les annotations des gènes humains
process downloadGtf{
	output:
	file "Homo_sapiens.GRCh38.101.chr.gtf.gz" into gtf

	"""
	wget ftp://ftp.ensembl.org/pub/release-101/gtf/homo_sapiens/Homo_sapiens.GRCh38.101.chr.gtf.gz
	"""
}


// Mapping des fichiers fastq
process mapFastQ {
	container 'evolbioinfo/star:v2.7.6a'

	input:
	path ref from indexgenome
    	tuple val("${sraid}"), file("${sraid}_1.fastq.gz"), file("${sraid}_2.fastq.gz") from fastqgz

	output:
	file "${sraid}.bam" into bam

	"""
	STAR --outSAMstrandField intronMotif \
		--outFilterMismatchNmax 4 \
		--outFilterMultimapNmax 10 \
		--genomeDir ref \
		--readFilesIn <(gunzip -c ${sraid}_1.fastq) <(gunzip -c ${sraid}_2.fastq) \
		--runThreadN ${task.cpus} \
		--outSAMunmapped None \
		--outSAMtype BAM SortedByCoordinate \
		--outStd BAM_SortedByCoordinate \
		--genomeLoad NoSharedMemory \
		--limitBAMsortRAM 30000000000 \
		> ${sraid}.bam
	"""
}

// Indexation des .bam
process indexBamFiles {
	publishDir 'results', mode: 'link'

	container 'evolbioinfo/samtools:v1.11'

	input:
	file bam from bam

	output:
	tuple file("${bam}.bai"), file("${bam}") into bamindex

	"""
	samtools index *.bam
	"""
}

// Compte les reads
process countReads {
	container 'evolbioinfo/subread:v2.0.1'

	input:
	file "*.bam" from bamindex.collect()
	file "Homo_sapiens.GRCh38.101.chr.gtf.gz" from gtf

	//output:


	"""
	gunzip Homo_sapiens.GRCh38.101.chr.gtf.gz
	featureCounts -T 8 -t gene -g gene_id -s 0 -a Homo_sapiens.GRCh38.101.chr.gtf -o output.counts $bam // à mettre en input du process deseq
	"""
}
/*
//
process statAnalysis {
// en input mettre aussi association entre échantillon et son annotation --> expr diff entre muté et normal, ACP
}*/
