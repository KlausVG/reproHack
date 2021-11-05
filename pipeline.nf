myFile = file('test.txt') // TODO, changer ca en 'SRAid.txt'
// on prend les noms des id rss a dl
allLines = myFile.readLines()
for(line : allLines) {
    println line
}

process downloadSRA{
	publishDir 'results', mode: 'link'

	container 'pegi3s/sratoolkit'

	input:
	val sraid from allLines

	output:
	//tuple val(sraid), file("*_1.fastq"), file("*_2.fastq") into fastq

	"""
	fasterq-dump ${sraid} --threads ${task.cpus} --split-files 
	"""
}

chromo = ["1", "2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","MT"]

process downloadChr{ // download les donnees du genome humain
	publishDir 'results', mode: 'link'

	input:
	val chromosome from chromo
	
	output:
	//file "Homo_sapiens.GRCh38.dna.chromosome.${chromosome}.fa.gz" into chromofagz

	"""
	wget -o ${chromosome}.fa.gz ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.${chromosome}.fa.gz
	"""
}

process downloadGff{
	publishDir 'results', mode: 'link'

	output:
	file "Homo_sapiens.GRCh38.101.chr.gtf.gz" into gff
	
	"""
	wget ftp://ftp.ensembl.org/pub/release-101/gtf/homo_sapiens/Homo_sapiens.GRCh38.101.chr.gtf.gz
	"""
}
/*
process indexGenome {
	publishDir 'results', mode: 'link'
	container 'evolbioinfo/star:v2.7.6a'
	input:
	file chr from chromofagz.collect()

	//output:
	

	"""
	gunzip *.fa.gz | gzip -c -> ref.fa
	STAR --runThreadN 6 --runMode genomeGenerate  --genomeFastaFiles ref.fa
	"""
}*/
/*
process mapFastQ {
	publishDir 'results', mode: 'link'

	container 'evolbioinfo/star:v2.7.6a'
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
process countReads {
	publishDir 'results', mode: 'link'
	
	container 'evolbioinfo/subread:v2.0.1'
	
	//input:
	

	//output:
	

	"""
	featureCounts -T <CPUS> -t gene -g gene_id -s 0 -a input.gtf -o output.counts input.bam
	"""
}*/
