# TYPHA-HOT-SPOT-16S

### We will keep records here of how we analyze the 16S rRNA gene sequencing for the DOE HOT SPOTS in HOT MOMENTS project

### We are using a combination of VAMPS - (https://vamps2.mbl.edu/) and OLIGOTYPING - (https://merenlab.org/2013/11/04/oligotyping-best-practices/) to analyze several genera of interest that were abundant along the Typha transect located at the Plum Island Ecosystem LTER.

# First log into the MBL servers
    
    ssh qdowling@minnie.jbpc-np.mbl.edu

# change to the directory where you will operate. 

    cd /workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix

# in a new terminal copy the text file from my computer downloaded from VAMPs(https://vamps2.mbl.edu/) that contains the taxa and abundance. This file is very specific and is called "Sequence Matrix File (TaxBySeq -- counts matrix)"

    cd /directory/containing/Sequence_Matrix_File
    
### Quincy:

    cd Users/quincydowling/Desktop/OneDriveMBL/etc

# Make sure its the file you expect by exploring using head using your computer

    head taxbyseq-1721839728606.tsv

# Now copy the file to the new directory you created on the MBL server. Do this on your computer

    scp Sequence_Matrix_File qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix

# Make oligotyping alive on minnie

    module load oligotyping/mamba-20240321

# Copy important scripts into the directory (oligotyping.shx and convert-vamps-to-oligotyping.py). Download them from this git and then use rsync to place them into the working directory. Here is an example of how I moved one of the files 

    scp oligotyping.shx qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix/
    scp convert-vamps-to-oligotyping.py qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix/
    scp sample_list.txt qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix/

# All the steps for oligotyping are in the oligotyping.shx file. but we are going to go through them here
### The first step is to grab all the line in the Sequence_Matrix_File that have the genus of interest. 
#### Right now I am doing Methanothrix, previously known as Methanosaeta

    grep Methanosaeta taxbyseq-1721839728606.tsv > Methanosaeta-taxbyseq.tsv

### Convert the Methanosarcina-taxbyseq.tsv to a fasta file for oligotyping

    python convert-vamps-to-oligotyping.py Methanosaeta-taxbyseq.tsv Methanosaeta-for-oligotyping.fa sample_list.txt

### Load the oligotyping codebase in minnie

    module load oligotyping/mamba-20240321

### Pad the fasta file with gaps "-" 

    o-pad-with-gaps Methanosaeta-for-oligotyping.fa -o Methanosaeta-for-oligotyping-padded.fa

### Conduct the entropy analysis

    entropy-analysis Methanosarcina-for-oligotyping-padded.fa

## Have a look at the pdf of the entropy to explore for oligotype candidate positions. in personal computer terminal window, cd to directory where you want the output files to go, and then you can just put ' .' (space, period) at the end to move it to your current directory.

    scp qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/Methanosaeta-for-oligotyping-padded.fa-ENTROPY.png .

## Once you look at the png or pdf (either works) on your computer, write down the top three entropy positions. You can also look at the ENTROPY file (not the pdf or png one, just ends in ENTROPY) in terminal and look at the top positions. Those are needed for the oligotyping command! No more than three.

    head Methanosaeta-for-oligotyping-padded.fa-ENTROPY

## Now we begin the real work: oligotype, fasta file, padded entropy file, -C, top 3 positions of entropy that you found above, -M 50 (minimum substantiative abundance of 50)

    oligotype Methanosaeta-for-oligotyping-padded.fa Methanosaeta-for-oligotyping-padded.fa-ENTROPY -C 354,5,268 -M 50

### The above is an example that I used when oligotyping Methanonsarcina. The pieces of the command are 1) the oligotype command 2) the padded fasta file that I used to calculate entropy 3) the Entropy file 4) The candidate positions to oligotype (they follow the "-C") and the 5) minimum substantitive abundance following the "-M" flag. 

### I made the decision to use those three positions (354, 5, and 268) because they had the highest entropy in the Methanosarcina-for-oligotyping-padded.fa-ENTROPY file.

## When Oligotyping is done, it will give you a message that tells you the path to the output files on the server, for example:
### View results in your browser: "/automounts/workspace/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix/Methanosaeta-for-oligotyping-padded-sc4-s1-a0.0-A0-M50/HTML-OUTPUT/index.html"
### Just copy the 'automounts...OUTPUT" part, not the index part


## HOW TO EXPORT the results of the oligotyping run - On your computers terminal, use scp, minnieaddress.edu:/automounts etc see below. make sure the end has 'OUTPUT/* .' for it to work.

    scp qdowling@minnie.jbpc-np.mbl.edu:/automounts/workspace/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanosaeta/Methanosaeta-for-oligotyping-padded-sc3-s1-a0.0-A0-M50/HTML-OUTPUT/* .
   
## Explore the oligotyping directory HTML-OUTPUT in the index.html link. This will show you the most abundant oligotypes and which ones have more entropy to further oligotype.

## When you find another oligotype to further explore, write down the position number you want to add and add it to your original string of numbers with the oligotyping command (e.g. adding 52)

    oligotype Methanosaeta-for-oligotyping-padded.fa Methanosaeta-for-oligotyping-padded.fa-ENTROPY -C 354,5,268,52 -M 50

### Best practice is to only add one position at a time. See if multiple oligotypes have high entropy at one spot.


## Once you have finished the oligotyping, you will go through a series of steps to analyze the community composition using the phyloseq package in R. 

#### 1 Edit the final output matrix file "MATRIX-COUNT.txt" produced by oligotyping. This file needs to be transposed so the header contais the sample names and each row begins with the oligotyping id. 

#### 2.  You will need the taxonomy for each of the representative sequences. VSEARCH is the software used to search each of the sequences against the SILVA taxonomy (or your database of choice). The command below begins with activating the vsearch environment (https://github.com/torognes/vsearch). The vsearch command sarting on the line below is followed by the --usearch_global flag indicating a global vs. local search. The fasta file containing the node hits is listed "OLIGO-REPRESENTATIVES.fasta". This file is contained in the output of the oligotyping, then the --dbflag is used to direct vsearch to the location of the silva database and the --blast6out defines the format of the hits. The final flag, --id, indicates the minimum percent identity. In the example below, 60% of the positions in the alignment between the reference and queried must match or nothing will be reported for this oligotype. Pay attention to the vsearch output to see if any of the sequences were below the threshold.

##### First cd to the directory in on the server where the final oligotyping output files are, then activate vsearch

    module load vsearch
    vsearch --usearch_global OLIGO-REPRESENTATIVES.fasta --db /databases/silva/138.1 --blast6out NODE-HITS.txt --id 0.6

#### 3.  Open the phyloseq-oligotype-analysis.R on your machine and if any of the libraries fail to load, you will need to install :) The version of R should be 4.3.3. 

    




    





    
