for i in *.fasta
do
    perl translatorx_vLocal.pl -i $i -o ${i%.x} -p F -c 5 -t T
done