# Download mitogenomes
# Alignment
## Mafft

# Gblocks
## Installation
## Run Gblocks
## Output file
### Concatenate .fasta files
Running in Terminal (Ubuntu 20.04.5 LTS for WSL)

```ruby
#Install seqkit (if you don't have it)
conda install -c bioconda seqkit
#concatenate in one file
seqkit concat *.fasta > output.fasta
#------------ format into a single line fasta 
#delete enter in all doc
tr -d "\n" < output.fasta > output.fasta
#changes ">"
sed -i -E "s/>/\n>/g" output.fasta > output.fasta
#delete first empty row
awk 'NR>1' output.fasta > output.fasta
#add enter to name
sed -e "s/>.\{8\}/&\n/g" < output.fasta > output.fasta
```
**Other options**
- Geneious Prime (only works with a subscription 😞) https://assets.geneious.com/manual/2022.1/static/GeneiousManualsu61.html#:~:text=To%20join%20several%20sequences%20end,document%20from%20the%20input%20sequences.
- SEDA v1.5 (could not install due to a malware problem 😵) https://www.sing-group.org/seda/manual/operations.html#concatenate-sequences

### Convert .fasta to .phy for Partition Finder 2
The alignment need to be in phylip format (.phy) to run Partition Finder 2. 

The only program that give the right format is Geneious Prime (the free version). 
0. Install Geneious Prime (Free version)
1. File > Import File(s)
2. Click on "Keep Alignment"
3. Select you alignment
4. File > Export > Documents and select "Phylip alignment (.phy)" in the "Files of Type" box

# Partition Finder 2 (PF2)
Manual: https://www.robertlanfear.com/partitionfinder/assets/Manual_v2.1.x.pdf
Tutorial: http://www.robertlanfear.com/partitionfinder/tutorial/

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

## Run Partition Finder
Input files: 
1. Phylip alignment file (see Gblocks - Output)
2. the *.cfg* file (see Tutorial)

Output: Partitions for your alignment
# Sources 
For installation: 
Rob Lanfear answer (2017) https://groups.google.com/g/partitionfinder/c/zQDYzrFf0Bw

PF2 Tutorial http://www.robertlanfear.com/partitionfinder/tutorial/

Apolo Docs - Partition Finder* https://apolo-docs.readthedocs.io/en/latest/software/applications/partitionFinder/2.1.1/

BioStars - How to concatenate multiple fasta files https://www.biostars.org/p/332853/

'* Be careful with Apolo Docs, doesn't establish python2 in the environment creation

# Extra useful codes
Save output to a .txt file -------------  <comand> | tee <output file>
