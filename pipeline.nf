// Stockage des ID SRA
myFile = file('SRAid.txt')
allLines = myFile.readLines()

// Télécharge les fichiers fastq
process downloadFastQ{
	publishDir 'results/fastq', mode: 'symlink'
	
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
	publishDir 'results/chrom', mode: 'symlink'

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
	publishDir 'results/genome_index', mode: 'symlink'

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
	publishDir 'results/gtf', mode: 'symlink'

	output:
	file "Homo_sapiens.GRCh38.101.chr.gtf.gz" into gtf

	"""
	wget ftp://ftp.ensembl.org/pub/release-101/gtf/homo_sapiens/Homo_sapiens.GRCh38.101.chr.gtf.gz
	"""
}

// Mapping des fichiers fastq
process mapFastQ {
	publishDir 'results/mapping', mode: 'symlink'

	input:
	path ref from indexgenome
    	tuple val(sraid), file("file1.fastq.gz"), file("file2.fastq.gz") from fastqgz

	output:
	file "${sraid}.bam" into bam_indexBamFiles, bam_countReads

	"""
	STAR --outSAMstrandField intronMotif \
		--outFilterMismatchNmax 4 \
		--outFilterMultimapNmax 10 \
		--genomeDir ref \
		--readFilesIn <(gunzip -c file1.fastq.gz) <(gunzip -c file2.fastq.gz) \
		--runThreadN ${task.cpus} \
		--outSAMunmapped None \
		--outSAMtype BAM SortedByCoordinate \
		--outStd BAM_SortedByCoordinate \
		--genomeLoad NoSharedMemory \
		--limitBAMsortRAM ${task.memory.toBytes()} \
		> ${sraid}.bam
	"""
}

// Indexation des .bam
process indexBamFiles {
	publishDir 'results/bam_index', mode: 'symlink'

	input:
	file bam from bam_indexBamFiles

	output:
	tuple file("${bam}.bai"), file("${bam}") into bamindex

	"""
	samtools index *.bam
	"""
}

// Compte les reads
process countReads {
	publishDir 'results/counts', mode: 'symlink'

	input:
	file bam from bam_countReads.collect()
	file "Homo_sapiens.GRCh38.101.chr.gtf.gz" from gtf

	output:
	file "output.counts" into counts
	file "output.counts.summary" into summary

	"""
	featureCounts -T 8 -t gene -g gene_id -s 0 -a Homo_sapiens.GRCh38.101.chr.gtf.gz -o output.counts $bam
	"""
}
/*
// Lance l'analyse statistique R
process statAnalysis {
	publishDir 'results/analyseR', mode: 'symlink'

	input:
	file "output.counts" from counts

	//output:
	

	"""
	#!/usr/bin/env.Rstat.R
	"""
}*/
