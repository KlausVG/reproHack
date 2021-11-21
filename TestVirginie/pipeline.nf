// Stockage des noms des ID RSS à télécharger
myFile = file('test.txt') // TODO, changer ca en 'SRAid.txt'

allLines = myFile.readLines()
for(line : allLines) {
    println line
}
/*
// Télécharge ???
process downloadSRA{
	publishDir 'results', mode: 'link'

	container 'pegi3s/sratoolkit'

	input:
	val sraid from allLines

	output:
	tuple val(sraid), file("*_1.fastq.gz"), file("*_2.fastq.gz") into fastq.gz

	"""
	fasterq-dump ${sraid} --threads ${task.cpus} --split-files
	gzip ${sraid}_1.fastq ${sraid}_2.fastq
	"""
}*/

// Stockage des noms des chromosomes
chromo = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","MT"]

// Télécharge les données du génome humain
process downloadChr{
	publishDir 'results', mode: 'link'

	input:
	val chromosome from chromo
	
	output:
	file "Homo_sapiens.GRCh38.dna.chromosome.${chromosome}.fa.gz" into chromofagz

	"""
	wget -o ${chromosome}.fa.gz ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.${chromosome}.fa.gz
	"""
}

// Création de l'index du génome
process indexGenome {
	//publishDir 'results', mode: 'link'

	container 'evolbioinfo/star:v2.7.6a'

	input:
	file chr from chromofagz.collect()

	//output:
	
	"""
	mkdir ref
	gunzip -c *.fa.gz > ref.fa
	STAR --runThreadN 8 --runMode genomeGenerate --genomeDir ref/ --genomeFastaFiles ref.fa
	"""
}

// Télécharge les annotations des gènes humains
process downloadGff{
	publishDir 'results', mode: 'link'

	output:
	file "Homo_sapiens.GRCh38.101.chr.gtf.gz" into gff
	
	"""
	wget ftp://ftp.ensembl.org/pub/release-101/gtf/homo_sapiens/Homo_sapiens.GRCh38.101.chr.gtf.gz
	"""
}

/*
// Mapping des fichiers fastq (à séparer en deux)
process mapFastQ {
	publishDir 'results', mode: 'link'

	container 'evolbioinfo/star:v2.7.6a' // 2 conteneurs en même temps pas possible, faire 2 process
	container 'evolbioinfo/samtools:v1.11'

	//input:


	//output:
	 

	"""
	STAR --outSAMstrandField intronMotif \
		--outFilterMismatchNmax 4 \
		--outFilterMultimapNmax 10 \
		--genomeDir ref \
		--readFilesIn <(gunzip -c ${sraid}_1.fastq) <(gunzip -c ${sraid}_2.fastq) \
		--runThreadN 6 \
		--outSAMunmapped None \
		--outSAMtype BAM SortedByCoordinate \
		--outStd BAM_SortedByCoordinate \
		--genomeLoad NoSharedMemory \
		--limitBAMsortRAM <Memory in Bytes> \
		> <sample id>.bam
	samtools index *.bam
	"""
}*/
/*
// Compte des reads
process countReads {
	publishDir 'results', mode: 'link'
	
	container 'evolbioinfo/subread:v2.0.1'
	
	//input: file (bam) from bam.collect() (avec bam output de mapfastq)
	

	//output:
	

	"""
	featureCounts -T <CPUS> -t gene -g gene_id -s 0 -a input.gtf -o output.counts $bam // à mettre en input du process deseq
	"""
}*/
/*
//
process statAnalysis {
// en input mettre aussi association entre échantillon et son annotation --> expr diff entre muté et normal, ACP
}*/
