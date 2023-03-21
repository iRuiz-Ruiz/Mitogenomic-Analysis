Hello

# Download mitogenomes
# Alignment
## Mafft

# Gblocks
# Partition Finder 2
Manual: https://www.robertlanfear.com/partitionfinder/assets/Manual_v2.1.x.pdf

Installation in Terminal (Ubuntu 20.04.5 LTS, also WSL)

Possible errors (and solutions)

No.  |                   Error                    |        Reason        |                                     Solution                        |
:---:|                   :---:                    |         :---:        |                                       :---:                         |
1    | _ImportError: No module named 'log tools'_ | Wrong Python version | Create a new python environment with only 2.7.x version             |
2    |Could not find the dependency numpy         | Wrong Python version or forgot to install dependency | Use Sol. 1 and install dependencies |
3    |Command 'python' not found, did you mean:

Input files: (1) Phylip alignment file & (2) the *.cfg* file


Output: Partitions for your alignment
# Sources 
For installation: 

# Extra useful codes
Save output to a .txt file -------------  <comand> | tee <output file>
