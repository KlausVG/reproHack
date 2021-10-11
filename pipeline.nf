myFile = file('test.txt') // TODO, changer ca en 'RSAid.txt'
// on prend les noms des id rss a dl
allLines  = myFile.readLines()
for( line : allLines ) {
    println line
}

process downloadRSA{
	container  'pegi3s/sratoolkit'
	input:
	val sraid from allLines
	"""
	fasterq-dump ${sraid} // on dl les fastq associe
	"""
}

chromo = ["1", "2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","Mt"]

process downloadChr{ // on va dowload now les donnes du genome humains
	container  'pegi3s/sratoolkit'
	input:
	val chromosome from chromo
	"""
	wget -o ${chromosome}.fa.gz ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.${chromosome}.fa.gz
	"""
}

// puis faut trouver un moyen que ca compresse tout les .fa.gz du process dans un dossier fa avec la commande bash
// par contre comment en faire un process...
// gunzip -c *.fa.gz > ref.fa
