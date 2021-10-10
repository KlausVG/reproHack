RSAid = Channel.create()


RSAid.fromPath('RSAid.txt')
RSAid.splitText(by : 10)
RSAid.view()


process downloadRSA{
	container  'evolbioinfo/sratoolkit:v2.5.7'
	input:
	file sraid from RSAid

	"""
	fastq-dump --gzip --split-files .!{sraid}.sra
	"""
}
