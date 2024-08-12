# TYPHA-HOT-SPOT-16S

## We will keep records here of how we analyze the 16S rRNA gene sequencing for the DOE HOT SPOTS in HOT MOMENTS project

## OLIGOTYPING - https://merenlab.org/2013/11/04/oligotyping-best-practices/

# First log into the MBL servers
    
    ssh qdowling@minnie.jbpc-np.mbl.edu

# change to the directory where you will operate. 

    cd /workspace/cardonlab/DOE-THS-TRANSECT

# in a new terminal copy the text file from my computer downloaded from VAMPs(https://vamps2.mbl.edu/) that contains the taxa and abundance. This file is very specific and is called "Sequence Matrix File (TaxBySeq -- counts matrix)"

    cd /directory/containing/Sequence_Matrix_File

# Make sure its the file you expect by exploring using head

    head taxbyseq-1721839728606.tsv

# Now copy the file to the new directory you created on the MBL server.

    rsync -HalP Sequence Matrix File qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/

# Make oligotyping alive

    module load oligotyping/mamba-20240321

# Copy important scripts into the directory (oligotyping.shx and convert-vamps-to-oligotyping.py). Download them from this git and then use rsync to place them into the working directory. Here is an example of how I moved one of the files 

    rsync -HalP oligotyping.shx qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/

# All the steps for oligotyping are in the oligotyping.shx file. but we are going to go through them here
### The first step is to grab all the line in the Sequence_Matrix_File that have the genus of interest. 

    grep Methanosarcina taxbyseq-1721839728606.tsv > Methanosarcina-taxbyseq.tsv

### Convert the Methanosarcina-taxbyseq.tsv to a fasta file for oligotyping

    python convert-vamps-to-oligotyping.py Methanosarcina-taxbyseq.tsv Methanosarcina-for-oligotyping.fa

### Pad the fasta file with gaps "-" 

    o-pad-with-gaps Methanosarcina-for-oligotyping.fa -o Methanosarcina-for-oligotyping-padded.fa

### Conduct the entropy analysis

    entropy-analysis Methanosarcina-for-oligotyping-padded.fa

## Have a look at the pdf of the entropy to explore for oligotype candidate positions

    rsync -HalP qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/Methanosarcina-for-oligotyping-padded.fa-ENTROPY.png /directory/of/choice/

## Now we begin the real work - Oligotyping

    oligotype Methanosarcina-for-oligotyping-padded.fa Methanosarcina-for-oligotyping-padded.fa-ENTROPY -C 354,5,268 -M 50

### The above is an example that I used when oligotyping Mehanonsarcina. The pieces of the command are 1) the oligotype command 2) the padded fasta file that I used to calculate entropy 3) the Entropy file 4) The candidate positions to oligotype (they follow the "-C") and the 5) minimum substantitive abundance following the "-M" flag. 

### I made the decision to use those three positions (354, 5, and 268) because they had the highest entropy in the Methanosarcina-for-oligotyping-padded.fa-ENTROPY file. 

## Lets explore the results of our first oligotyping run to identify what other positions are informative and needed to reduce the entropy. All of the important information is in the output of the oligotyping directory HTML-OUTPUT/index.html



    




    





    
