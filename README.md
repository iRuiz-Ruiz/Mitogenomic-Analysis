# Download mitogenomes
# Alignment
## Mafft

# Gblocks
# Partition Finder 2 (PF2)
Manual: https://www.robertlanfear.com/partitionfinder/assets/Manual_v2.1.x.pdf

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
1. Phylip alignment file
2. the *.cfg* file


Output: Partitions for your alignment
# Sources 
For installation: 
Rob Lanfear answer (2017) https://groups.google.com/g/partitionfinder/c/zQDYzrFf0Bw

Apolo Docs - Partition Finder* https://apolo-docs.readthedocs.io/en/latest/software/applications/partitionFinder/2.1.1/

'* Be careful with Apolo Docs, doesn't establish python2 in the environment creation

# Extra useful codes
Save output to a .txt file -------------  <comand> | tee <output file>
