RSAid = Channel.create()


RSAid.fromPath('RSAid.txt')
RSAid.splitText(by : 10)
RSAid.view()


process downloadRSA{
	input: 
	file sraid from RSAid

	"""
	fastq-dump --gzip --split-files .!{sraid}.sra
	"""
}