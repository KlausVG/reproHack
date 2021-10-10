
RSAid= Channel.fromPath('RSAid.txt')
RSAid.splitText(by : 1)
RSAid.view()


process downloadRSA{
	container  'evolbioinfo/sratoolkit:v2.5.7'
	input:
	val sraid from RSAid
	output:
	file "${sraid}.sra" into fastq-file

	"""
	fastq-dump --gzip --split-files .${sraid}.sra
	"""
}
