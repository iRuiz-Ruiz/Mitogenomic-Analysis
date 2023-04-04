#!Bin
for i in *.fasta; do Gblocks $i -t=d -b5=n -p=y; done

#-t: d (dna), p (protein), c(codons)
