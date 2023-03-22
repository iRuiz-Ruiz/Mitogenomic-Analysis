#------------ from fasta-gb to fasta 
for i in *.fasta-gb
do
#delete enter in all the file
tr -d "\r\n" < $i > dummy
tr -d " " < dummy > dummy2
#includes an "enter" per specie
sed -i -E "s/>/\n>/g" dummy2
#delete first empty row
awk 'NR>1' dummy2 > dummy
#add enter to ID, only accept eight characters 
sed -e "s/>.\{8\}/&\n/g" < dummy > ${i-gb}.fasta
rm dummy dummy2
done
