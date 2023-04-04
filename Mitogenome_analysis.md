# Download mitogenomes
# Alignment
## Mafft

Loop to run mafft in computer (download here an place in the same folder the sequences to align), save it as .sh file
```ruby
for i in *.fasta
do
    mafft --quiet $i > ${i%.fasta}.aligned.fasta
done
```
## Alignment with TranslatorX
There is an online version of TranslatorX http://translatorx.co.uk/ where you could run your .fasta files. Also, there is a local version in pearl to run a lot of files at once. Just copy and save it in the folder where your fasta files are. Meaning of each parameter is included in the script (line 80). 

```ruby
#To run one file
perl translatorx_vLocal.pl -i name_file.fasta -o output_name -p F -c 5 -t T
```

Loop version: [translatorx-loop.sh](https://github.com/iRuiz-Ruiz/Notebook/blob/main/translatorx-loop.sh)
```ruby
dos2unix translatorx-loop.sh
sh translatorx-loop.sh
```

```ruby
mkdir xalign
mv *.nt_ali.fasta xalign/
cd xalign/
```

Then you should run and cut. 
# Gblocks
## Installation
Download Gblocks for MAC or Linux https://slackbuilds.org/repository/15.0/academic/Gblocks/

Downoad Gblocks for Windows https://github.com/dongzhang0725/PhyloSuite_plugins

Documentation https://home.cc.umanitoba.ca/~psgendb/doc/Castresana/Gblocks_documentation.html

If you work in a WSL, you could move the compressed file to your programmes folder (or home directory). Then run this
```ruby
uncompress Gblocks_OS_0.91b.tar.Z
tar xvf Gblocks_OS_0.91b.tar
```

## Run Gblocks
Input files are
1. Gblock executable program
2. Aligned fasta files

Both should be in the same folder, to do that you could use the following lines

```ruby
#Create a folder to include the aligned files and Gblock executable program 
mkdir gblock-tests
#Enter Gblocks folder
cd Gblocks_0.91b
#Copy executable file to the folder
cp Gblocks /yourdesirepath/gblock-tests/
#Go to the gblock-tests folder
cd /yourpath/gblock-tests
```
**RUN GBLOCKS**
```ruby
#Don't forget to copy the .fasta files to your folder before executing (you could include more parameters, see Gblocks Documentation)
Gblocks <filename.fasta> -t=d -b5=n -p=y 
```

For more than one file, you could this simple loop (see [gblocks.sh](https://github.com/iRuiz-Ruiz/Notebook/blob/main/gblock.sh))
```ruby
#sometimes there is a problem with .sh format, you could use 'dos2unix' function to solve it... install with sudo apt-get install dos2unix
dos2unix gblocks.sh
#run the file
sh gblocks.sh
```

The GBLOCKs output will be two extra files per .fasta files, (1) .fasta-gb and (2) .html. Then you could organize it in folders (Optional).
```ruby
mkdir fasta-gb hmtl
mv *fasta-gb fasta-gb/
mv *htm html/
```
The .htm file gives you information about the alignment size, the blocks and other details. This file will be useful to construct the .cfg file for PF2 (see [.cfg file](https://github.com/iRuiz-Ruiz/Notebook/edit/main/Mitogenome_analysis.md#how-to-write-a-cfg-file) section). 

On the other hand, the .fasta-gb files need to be converted to .fasta file to concatenate in the next step. You could use the [fastagb2fasta.sh](https://github.com/iRuiz-Ruiz/Notebook/blob/main/fasta-gb2fasta.sh) make sure to have it in the same folder as the .fasta-gb files). 
```ruby
cd fasta-gb #go to the folder with the fasta-gb files and the .sh file
dos2unix fastagb2fasta.sh
sh fasta.sh 
```

**Comment: **
Gblocks results differs in Linux or Terminal. 

## Format output file for PF2
### Concatenate .fasta files
Input:
1. .fasta files per each gene 

Running in Terminal (Ubuntu 20.04.5 LTS for WSL)

```ruby
#Install seqkit (if you don't have it)
conda install -c bioconda seqkit
#concatenate in one file
seqkit concat *.fasta > output.fasta
#------------ format into a single line fasta 
for i in *.fasta;
do;
#delete enter in all the file
tr -d "\n" < $i > dummy
#includes an "enter" per specie
sed -i -E "s/>/\n>/g" dummy
#delete first empty row
awk 'NR>1' dummy > dummy2
#add enter to ID, only accept eight characters 
sed -e "s/>.\{8\}/&\n/g" < dummy2 > ${i-cc}.fasta
rm dummy dummy2
done;
```
**Other options**
- Geneious Prime (only works with a subscription 😞) https://assets.geneious.com/manual/2022.1/static/GeneiousManualsu61.html#:~:text=To%20join%20several%20sequences%20end,document%20from%20the%20input%20sequences.
- SEDA v1.5 (could not install due to a malware problem 😵) https://www.sing-group.org/seda/manual/operations.html#concatenate-sequences
- ConcatFasta.py (need a list of your files) https://github.com/santiagosnchez/ConcatFasta/tree/5decfa76eefb2ff73a2ac8ca690503cb05f00c29
### Convert .fasta to .phy for Partition Finder 2
The alignment need to be in phylip format (.phy) to run Partition Finder 2. 

The only program that give the right format is Geneious Prime (the free version). 
0. Install Geneious Prime (Free version)
1. File > Import File(s)
2. Click on "Keep Alignment"
3. Select you alignment
4. File > Export > Documents and select "Phylip alignment (.phy)" in the "Files of Type" box

# Partition Finder 2 (PF2)
Rob Lanfear Manual: https://www.robertlanfear.com/partitionfinder/assets/Manual_v2.1.x.pdf
Rob Lanfear Tutorial: http://www.robertlanfear.com/partitionfinder/tutorial/

Environment setting in Terminal (Ubuntu 20.04.5 LTS for WSL)

## Create environment for PF2 installation

```ruby
conda create --name py2 python=2 
#Activate (or enter) to the environment
conda activate py2 
#you will notice that 'base' changed to 'py2'
#install dependencies
conda install numpy pandas pytables pyparsing scipy scikit-learn
```

## Installation of PF2

```ruby
wget https://github.com/brettc/partitionfinder/archive/v2.1.1.tar.gz
#Decompress file
tar xfz v2.1.1.tar.gz
```
**Possible errors (and solutions)**

No.  |                   Error                    |        Reason        |                                     Solution                        |
:---:|                   :---:                    |         :---:        |                                       :---:                         |
1    | _ImportError: No module named 'log tools'_ | Wrong Python version | Create a new python environment with only 2.7.x version             |
2    |Could not find the dependency numpy         | Wrong Python version or forgot to install dependency | Use Sol. 1 and install dependencies |
3    |Command 'python' not found, did you mean:  command 'python3' from deb python3 command 'python' from deb python-is-python3 | Wrong python version | Use Sol. 1 |

How to know which python version are you using?
python --version

If appears 3.10.x or 3.x, that's probably the default python version in your system. Any environment you create will set up to the systems' python version, unless you specify that you want python2 or other version. To work with PartitionFinder should appear as 2.7.18 or 2.7.x version (see **Environment Setting**)

## Run Partition Finder 2
Input files: 
1. Phylip alignment file (see Gblocks - Output)
2. the *.cfg* file (to write one see [.cfg file](https://github.com/iRuiz-Ruiz/Notebook/edit/main/Mitogenome_analysis.md#how-to-write-a-cfg-file) section
3. PartitionFinder.py (included in the zippe file - see [Installation of PF2](https://github.com/iRuiz-Ruiz/Notebook/edit/main/README.md#installation-of-pf2))

To run PF2, the .phy and .cfg files need to be in the same folder (wherever you like, as long you know the path). **Don't move the file _PartitionFinder.py_ from its folder.**

```ruby
python /usr/yourpath/partitionfinder-2.1.1/PartitionFinder.py /usr/yourpath/output.phy
```

The parameters of the analysis need to be defined in the .cfg file (what includes? see this [section](https://github.com/iRuiz-Ruiz/Notebook/edit/main/Mitogenome_analysis.md#how-to-write-a-cfg-file)) that the program would call during the analysis. 

Now, the interesting part comes... how to interpret the data according to the models (yes, there are more than one parameter you should set for your analysis)? Take a look to [Rob Lanfear](http://www.robertlanfear.com/partitionfinder/tutorial/) tutorial.


**Possible errors (and solutions)**

*#Problem 1: Does not find the .cfg file*

```ruby
INFO     | 2023-03-20 19:41:53,459 | Note: NumExpr detected 20 cores but "NUMEXPR_MAX_THREADS" not set, so enforcing safe limit of 8.
INFO     | 2023-03-20 19:41:53,459 | NumExpr defaulting to 8 threads.
INFO     | 2023-03-20 19:41:53,552 | ------------- PartitionFinder 2.1.1 -----------------
INFO     | 2023-03-20 19:41:53,552 | You have Python version 2.7
INFO     | 2023-03-20 19:41:53,552 | Command-line arguments used: PartitionFinder.py output.phy
INFO     | 2023-03-20 19:41:53,552 | ------------- Configuring Parameters -------------
INFO     | 2023-03-20 19:41:53,552 | Setting datatype to 'DNA'
INFO     | 2023-03-20 19:41:53,552 | Setting phylogeny program to 'phyml'
INFO     | 2023-03-20 19:41:53,553 | Program path is here /home/w/partitionfinder-2.1.1/programs
ERROR    | 2023-03-20 19:41:53,553 | No such folder: ''
ERROR    | 2023-03-20 19:41:53,553 | Failed to run. See previous errors.
```
#Solution 1: create the .cfg file (see [.cfg file](https://github.com/iRuiz-Ruiz/Notebook/edit/main/Mitogenome_analysis.md#how-to-write-a-cfg-file) section) and save it in a separate folder with the .phy file.

*#Problem 2: Does not find the .phy file*
```ruby
INFO     | 2023-03-21 09:06:04,778 | ------------------------ BEGINNING NEW RUN -------------------------------
INFO     | 2023-03-21 09:06:04,778 | Looking for alignment file './infile.phy'...
ERROR    | 2023-03-21 09:06:04,778 | Failed to find file: './infile.phy'. Please check and try again.
ERROR    | 2023-03-21 09:06:04,778 | Failed to run. See previous errors.
```
#Solution 2: correct the .phy filename in your .cfg file, as you see I forgot to change infile.phy for output.phy

##### How to write a .cfg file?
The author has a comprehensive [Rob Lanfear](http://www.robertlanfear.com/partitionfinder/tutorial/) tutorial how to write one and the meaning of each parameter. Just a quick revision in here. 

A .cfg looks like this
```ruby
## ALIGNMENT FILE ##
alignment = youralignment.phy;

## BRANCHLENGTHS: linked | unlinked ##
branchlengths = linked;

## MODELS OF EVOLUTION: all | allx | mrbayes | beast | gamma | gammai | <list> ##
models = all;

# MODEL SELECCTION: AIC | AICc | BIC #
model_selection = aicc;

## DATA BLOCKS: see manual for how to define ##
[data_blocks]
gene1=1-444;
gen2=445-980;
geb3=981-1540;

## SCHEMES, search: all | user | greedy | rcluster | rclusterf | kmeans ##
[schemes]
search = greedy;
```

The data block section may seem a problem if you work with more than 10 genes, as you will have to take a look to the size of each alignment  from gblocks. Also, make sure items appear in the same order as the sequences were concatenated (see [Concatenate .fasta files](https://github.com/iRuiz-Ruiz/Notebook/edit/main/Mitogenome_analysis.md#concatenate-fasta-files))

An alternative is to use the .htm reports from gblock. 
```ruby
grep -oE '(New number of positions: <b>)[^ ]*' *.htm > alg-size.csv
sed -i "s/.aligned.cut.fasta-gb.htm:New number of positions: <b>/,/g" alg-size.csv
tr -d "</b>" < alg-size.csv > alg-size-final.csv
```

Then you could open it with excel, and give the desired format with "sum" and "concatenate" functions. 

_(Version to run in the terminal - coming soon!!!)_

If you explore the examples (included in the partitionfinder folder), you may see that the DATA BLOCK section could be written as well like this, 
```ruby
Gene1_pos1 = 1-789\3;
Gene1_pos2 = 2-789\3;
Gene1_pos3 = 3-789\3;
```
In the example .cfg there i don't have the exact codon positions, as I pass it through GBLOCKs and selected the most conserved regions. 
Do you know any other reason why? Please leave it in the comments. 

Output: Partitions for your alignment
Depending of the analysis you will get 
- The best substitution model
- Subsets in Nexus, RAXMl and Bayes formats. 
- Chartpartitions.

## Close PF2 
```ruby
conda deactivate
```
Now you could return use any environment with python3 or superior. 

# Phylogenetic analysis
## Maximum Likelihood - RAXMl
There are two ways to run RAXMl analysis.
1. CIPRES website (you would need to create an account)
2. In the Ubuntu Terminal

I'm going to comment about the second option. The Exelis Lab is the group that developed this software and also provide interesting examples. 
Exelis Lab RAXMl: https://cme.h-its.org/exelixis/web/software/raxml/

Download the infomation from the GitHub repository (https://github.com/stamatak/standard-RAxML). Go to Code > Download ZIP file and follow the instruction follow the instructions from the [RAxML hands-on session](https://cme.h-its.org/exelixis/web/software/raxml/hands_on.html) in the step. (Yes! you will need to run all from the Terminal). If you consider neccesary, you could create a RAXMl environemnt, not to disturb python2 of "py2" environment or any other. 

**Possible errors (and solutions)**

_Problem #1.a_
```ruby
Command 'make' not found, but can be installed with:

sudo apt install make        # version 4.2.1-1.2, or
sudo apt install make-guile  # version 4.2.1-1.2
```
Solution #1.a
```ruby
sudo apt install make
```

_Problem #1.b: 'make' installation didn't work out_
```ruby
rm -f *.o raxmlHPC
gcc  -D_GNU_SOURCE -fomit-frame-pointer -funroll-loops -O2 -msse    -c -o axml.o axml.c
make: gcc: Command not found
make: *** [<builtin>: axml.o] Error 127
```
Solution #1.b: Install gcc dependency
```ruby
sudo apt-get install gcc
```
_Problem #1.c_
... but Sometimes "gcc" is not found by python, but could not be installed directly until some dependencies are updated. That's the reason for executing the first two lines. Then runs smoothly. Sometimes is neccesary to run a couple of times to update them, mirrors where they download sometimes had a problem. 
```ruby 
Ign:1 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 linux-libc-dev amd64 5.4.0-139.156
Err:1 http://security.ubuntu.com/ubuntu focal-updates/main amd64 linux-libc-dev amd64 5.4.0-139.156
  404  Not Found [IP: 91.189.91.39 80]
E: Failed to fetch http://security.ubuntu.com/ubuntu/pool/main/l/linux/linux-libc-dev_5.4.0-139.156_amd64.deb  404  Not Found [IP: 91.189.91.39 80]
E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
```
Solution #1.c:
```ruby
sudo apt-get update
sudo apt-get install build-essential
```

Now, you could solve problem 1.b and 1.a to run the command _make -f Makefile.gcc_. There are different version for Makefile command like SSE3 or SSE3.PTHREADS you could try.

_Problem #2: When copying the raxmlHPC* files appears_
```ruby
cp: target '/yourfolder/' is not a directory
```
Solution #2: The directory need to include "~/" before and close with "/"
```ruby
cp raxmlHPC* ~/argo/
```

_Problem #3: 
```ruby
Command 'raxmlHPC' not found, but can be installed with: sudo apt install raxml
```

Solution #3: Add "./" before running (not included in the RAXMl tutorial)
```ruby
./raxmlHPC -m BINGAMMA -p 12345 -s output.phy -n T1
```

Problem #4: When use _./raxmlHPC -m BINGAMMA -p 12345 -s output.phy -n T1_
```ruby
ERROR: Bad base (A) at site 1 of sequence 1
Printing error context:

30 7955
nc_015248 AGAATATATAAAAAATTATAT
```
Solution #4: BINGAMMA is designed for protein alignments, for DNA use GTRCATX. Also commented in the [RAxML hands-on session](https://cme.h-its.org/exelixis/web/software/raxml/hands_on.html), in the "Step 3: Getting started".

##### What is T1, T2, T3 ... Tn?
Is a suffix not to overwrite the RAXMl results if run different experiments. 

##### How to include the partitions?
1. Save the partitions obtained for RAXMl from the previous PF2 analysis in a simple text file (e.g. partitions.txt). You will include (1) the .phy file and (2) the .txt partition file in the command line. according to "Step 6: Partitioned Analysis" and continue with the analysis. 

### Visualize phylogeny
Change names for fig-tree visualization

## Bayesian Analysis - BEAST

# Sources 
For dos2unix:
- How to install https://howtoinstall.co/en/dos2unix

Basic bash use:
- Remove files https://www.hostinger.com/tutorials/how-to-remove-files-and-folders-using-linux-command-line/

For Conda environments:
- Conda - Managing environments https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
For PF2 installation: 
- Rob Lanfear answer (2017) https://groups.google.com/g/partitionfinder/c/zQDYzrFf0Bw
- PF2 Tutorial http://www.robertlanfear.com/partitionfinder/tutorial/
- Apolo Docs - Partition Finder* https://apolo-docs.readthedocs.io/en/latest/software/applications/partitionFinder/2.1.1/
'* Be careful with Apolo Docs, doesn't establish python2 in the environment creation

Text files / fasta files editing in Terminal:
- BioStars - How to concatenate multiple fasta files https://www.biostars.org/p/332853/
- Baeldung. Remove the First Line of a Text File in Linux - https://www.baeldung.com/linux/remove-line-endings-from-file
- phoenixNAP. How to Use Sed to Find and Replace a String in a File - https://phoenixnap.com/kb/sed-replace

For RAXMl:
- 
- Ask Ubuntu - gcc command not found https://askubuntu.com/questions/1095168/command-not-found-cc-make-error-127
- Pissis (2012) - Running RAxML: https://groups.google.com/g/raxml/c/sxHJrhC-yvA
- Kozlov answer (2018) - raxmlHPC ERROR: Bad base (A) at site 1 of sequence 1 https://groups.google.com/g/raxml/c/YW6Vt9F6mbU
