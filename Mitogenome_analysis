# Download mitogenomes
# Alignment
## Mafft

# Gblocks
## Installation
## Run Gblocks
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
#delete enter in all the file
tr -d "\n" < output.fasta > output.fasta
#includes an "enter" per specie
sed -i -E "s/>/\n>/g" output.fasta > output.fasta
#delete first empty row
awk 'NR>1' output.fasta > output.fasta
#add enter to ID
sed -e "s/>.\{8\}/&\n/g" < output.fasta > output.fasta
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
2. the *.cfg* file (to write one see .cfg file example)
3. PartitionFinder.py (included in the zippe file - see [Installation of PF2](https://github.com/iRuiz-Ruiz/Notebook/edit/main/README.md#installation-of-pf2))

To run PF2, the .phy and .cfg files need to be in the same folder (wherever you like, as long you know the path). **Don't move the PartitionFinder.py from its folder.**

```ruby
python /usr/yourpath/partitionfinder-2.1.1/PartitionFinder.py /usr/yourpath/output.phy
```

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
#Solution 1: create the .cfg file (see [.cfg file]() section) and save it in a separate folder with the .phy file.

*#Problem 2: Does not find the .phy file*
```ruby
INFO     | 2023-03-21 09:06:04,778 | ------------------------ BEGINNING NEW RUN -------------------------------
INFO     | 2023-03-21 09:06:04,778 | Looking for alignment file './infile.phy'...
ERROR    | 2023-03-21 09:06:04,778 | Failed to find file: './infile.phy'. Please check and try again.
ERROR    | 2023-03-21 09:06:04,778 | Failed to run. See previous errors.
(py2) w@PC-i9:~/partitionfinder-2.1.1$ python PartitionFinder.py argo/output.phy
```
#Solution 2: correct the .phy filename in your .cfg file, as you see I forgot to change infile.phy for output.phy

##### How to write a .cfg file?
The author has a comprehensive [Rob Lanfear](http://www.robertlanfear.com/partitionfinder/tutorial/) tutorial how to write one and the meaning of each parameter. Just a quick revision go to this blog. also the PF2 unzipped folder contains various examples. 

Output: Partitions for your alignment

# Sources 
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
