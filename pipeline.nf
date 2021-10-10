
RSAid= Channel.fromPath('text.txt')


process downloadRSA{
	container  'pegi3s/sratoolkit'
	input:
	val sraid from RSAid

	"""
	fasterq-dump ${sraid}
	"""
}
