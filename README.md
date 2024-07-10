# TYPHA-HOT-SPOT-16S

## We will keep records here of how we analyze the 16S rRNA gene sequencing for the DOE HOT SPOTS in HOT MOMENTS project
##MED Analysis notes

##Download data from VAMPS - MBL's database for sequencing data

##Set up Terminal for doing MED analysis
#Change directory to place where data is - currently ~/Desktop/OneDriveMBL/CardonLab/DOETypha/
## pwd print working directory
## cd change directory to
## mv move object
## move object from current directory to

##use alias to connect to server or use ssh qdowling@minnie.jbpc-np.mbl.edu
## rsync move data from my folder into Bay Paul server
## decompression, padding, fixing the file which is outlines in the x_run_test or something file - MED prep is outlined there
## move it to workspace

##history shows you what commands you've run!

##activating oligotyping

## module load oligotyping/mamba-20243021


## now oligotyping is active, I already have necessary programs downloaded (conda, oligotyping (MED), Homebrew, other?)

##run command for MED analysis

# decompose fastafilename.fa

# takes a while to run but gives you awesome results

##Next we will run taxonomy and phyloseq

## rsync -HalP copies the file thats on the server (after MED analysis is done on the server, we want to move the results back to our computer)

##~/Desktop/OneDriveMBL/CardonLab/DOETypha/TRANSECT-2022-16S/VAMPS_Bv4v5/

##vsearch is for comparing sequences from silva to do taxonomy
## Joe's vsearch script is on github
# conda activate vsearch
