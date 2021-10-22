myFile = file('test.txt') // TODO, changer ca en 'RSAid.txt'
// on prend les noms des id rss a dl
allLines  = myFile.readLines()
for( line : allLines ) {
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
	fasterq-dump ${sraid} --split-files 
	"""
}

chromo = ["1", "2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","MT"]

process downloadChr{ // download les donnees du genome humain
	publishDir 'results', mode: 'link'
	input:
	val chromosome from chromo
	
	output:
	///file "Homo_sapiens.GRCh38.dna.chromosome.${chromosome}.fa.gz" into chromofagz
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

process indexGenome {
	container 'evolbioinfo/star:v2.7.6a'
	input:
	file chr from chromofagz.collect()

	//output:
	

	"""
	gunzip *.fa.gz | gzip -c -> ref.fa
	STAR --runThreadN 6 --runMode genomeGenerate  --genomeFastaFiles ref.fa
	"""
}
