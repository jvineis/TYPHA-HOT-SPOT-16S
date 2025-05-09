# TYPHA-HOT-SPOT-16S

## Intro:

#### We will keep records here of how we analyze the 16S rRNA gene sequencing for the DOE HOT SPOTS in HOT MOMENTS project to analyze several genera of interest that were abundant along the Typha transect located at the Plum Island Ecosystem LTER.

#### We are using a combination of:
#### VAMPS - (https://vamps2.mbl.edu/) - initial visualizations, downloading data and taxonomy
#### OLIGOTYPING - (https://merenlab.org/2013/11/04/oligotyping-best-practices/) - identifying diversity within a single genus of interest
#### Anvio and anvi-interactive - (https://anvio.org/help/main/programs/anvi-interactive/) - visualizing oligotyping results into anviograms
#### The SILVA database for taxonomy - (silva/138.1)
#### and the Pyloseq package in R - visualizing oligotyping results in R plots

#### We will run oligotyping on the MBL servers - version: mamba-20240321


## Downloading data and getting started
#### 1. Download the Sequence Matrix File from VAMPs(https://vamps2.mbl.edu/) that contains the taxa and abundance. This .tsv file is very specific and is called "Sequence Matrix File (TaxBySeq -- counts matrix)". In a terminal window, copy the file from your computer to your desired directory on the given server 

    cd /directory/containing/taxbyseq-1721839728606.tsv
    scp taxbyseq-1721839728606.tsv qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-TYPHA/Your_directory

#### Sanity check: Make sure its the file you expect by exploring using 'head' to view the first 10 lines

    head taxbyseq-1721839728606.tsv

#### 2. Copy important scripts into the directory (oligotyping.shx and convert-vamps-to-oligotyping.py). Download them from this git and then use rsync to place them into the working directory. Here is an example of how I moved the files 

    scp oligotyping.shx qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix/
    scp convert-vamps-to-oligotyping.py qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix/
    scp sample_list.txt qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix/

## Formatting the files
#### All the steps for oligotyping are in the oligotyping.shx file. but we are going to go through them here
#### 1. Load the oligotyping codebase on the server. Then we need to grab all the lines (aka sequences) in the tax-by-seq .tsv file that have been assigned by vamps to the genus of interest. Right now I am doing Methanothrix, previously known as Methanosaeta (still called this in vamps). We use the 'grep' function in unix to create a tsv file specifically for the sequences classified to this genus.

    module load oligotyping/mamba-20240321
    grep Methanosaeta taxbyseq-1721839728606.tsv > Methanosaeta-taxbyseq.tsv

#### 2. Convert the Methanosarcina-taxbyseq.tsv to a fasta file for oligotyping. This step properly formats each sequence and what sample it came from into a format that oligotyping can read. The sample list must match exactly to your sample names in your sequence data and have no other columns. Then pad the file with gaps "-" so that all the sequences are the same length (oligotyping requires this).

    python convert-vamps-to-oligotyping.py Methanosaeta-taxbyseq.tsv Methanosaeta-for-oligotyping.fa sample_list.txt
    o-pad-with-gaps Methanosaeta-for-oligotyping.fa -o Methanosaeta-for-oligotyping-padded.fa
    
## Starting to Oligotype: Entropy Analysis
#### 1. Use the entropy-analysis command on your newly created fasta file. This kicks off the oligotyping process by conducting an initial analysis of all the base positions in your sequences that are considered high entropy. Read more about this at Meren's site (cited above). 

    entropy-analysis Methanosarcina-for-oligotyping-padded.fa

#### 2. Copy the entropy figure to your computer so you can open it and have a look. Have a look at the pdf of the entropy to explore for oligotype candidate positions. In personal computer terminal window, cd to directory where you want the output files to go, and then you can just put ' .' (space, period) at the end to move it to your current directory.

    scp qdowling@minnie.jbpc-np.mbl.edu:/workspace/cardonlab/DOE-THS-TRANSECT/Methanosaeta-for-oligotyping-padded.fa-ENTROPY.png .

#### 3. In your directory on the server, look at the top lines of the ENTROPY file (not the pdf or png one, just ends in ENTROPY) to see the exact positions with the highest entropy. The top three are best to use as the first positions you use in the oligotyping analysis.

    head Methanosaeta-for-oligotyping-padded.fa-ENTROPY

## Oligotyping, for real
#### 1. Now we begin the real work with the oligotyping command: The pieces of the command are 1) the oligotype command 2) the padded fasta file that I used to calculate entropy 3) the Entropy file 4) The candidate positions to oligotype (they follow the "-C") and the 5) minimum substantitive abundance following the "-M" flag. 

    oligotype Methanosaeta-for-oligotyping-padded.fa Methanosaeta-for-oligotyping-padded.fa-ENTROPY -C 354,5,268 -M 50

#### 2. When Oligotyping is done, it will give you a message that tells you the path to the output files on the server, for example:
###### View results in your browser: "/automounts/workspace/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanothrix/Methanosaeta-for-oligotyping-padded-sc4-s1-a0.0-A0-M50/HTML-OUTPUT/index.html"
#### You can copy the important output from the oligotyping results to your computer so you can identify further positions to include. The * indicates a variable, meaning it will copy all files within the HTML-OUTPUT directory. You must copy all files and keep them together in the same directory or they will not be able to communicate with each other and display the output for you.

    scp qdowling@minnie.jbpc-np.mbl.edu:/automounts/workspace/workspace/cardonlab/DOE-THS-TRANSECT/OLIGOTYPING/Methanosaeta/Methanosaeta-for-oligotyping-padded-sc3-s1-a0.0-A0-M50/HTML-OUTPUT/* .
   
#### 3. In the oligotyping directory HTML-OUTPUT, explore the index.html link. This will show you key stats about your analysis, which positions you analyzed, and most importantly, it will show you the most abundant oligotypes and which ones have more entropy to further decompose. Read about the best practices of Oligotyping here on Meren's site: https://merenlab.org/2013/11/04/oligotyping-best-practices/
#### When you find another oligotype to further explore, write down the position number you want to add and add it to your original string of numbers with the oligotyping command (e.g. adding 52). Best practice is to only add one position at a time. See if multiple oligotypes have high entropy at one spot.

    oligotype Methanosaeta-for-oligotyping-padded.fa Methanosaeta-for-oligotyping-padded.fa-ENTROPY -C 354,5,268,52 -M 50

#### 4. Keep evaluating further positions and adding them in until most of the entropy has been resolved!


## Visualization with Anvi'o:

#### 1. First navigate to the output directory of your final oligotyping round; ends with -M50. Inside that directory should be the MATRIX-PERCENT.txt and MATRIX-COUNT.txt files. Use the sed command to replace the "-"s in the fasta file into "s.
#### 2. Then use the vsearch command to create NODE-HITS.txt file. More on vsearch:
###### VSEARCH is the software used to search each of the sequences against the SILVA taxonomy (or your database of choice). The command below begins with activating the vsearch environment (https://github.com/torognes/vsearch). The vsearch command sarting on the line below is followed by the --usearch_global flag indicating a global vs. local search. Then the --dbflag is used to direct vsearch to the location of the silva database and the --blast6out defines the format of the hits. The final flag, --id, indicates the minimum percent identity. In the example below, 60% of the positions in the alignment between the reference and queried must match or nothing will be reported for this oligotype. Pay attention to the vsearch output to see if any of the sequences were below the threshold.
#### Phyloseq will also use this NODE-HITS.txt file (save for later!).

    cd /workspace/whateverdirectory/Methanosaeta-for-oligotyping-padded-sc7-s1-a0.0-A0-M50
    module load vsearch
    sed 's/-//g' OLIGO-REPRESENTATIVES.fasta > OLIGO-REPRESENTATIVES.fixed.fasta
    sed 's/"//g' OLIGO-REPRESENTATIVES.fixed.fasta > OLIGO-REPRESENTATIVES.final.fasta
    vsearch --usearch_global OLIGO-REPRESENTATIVES.final.fasta --db /databases/silva/138.1/SILVA_138.1_SSURef_NR99_tax_silva.fasta.gz --blast6out NODE-HITS.txt --id 0.6
    python  ~/scripts/convert-NODE-HITS-to-TAX.py NODE-HITS.txt /databases/silva/138.1/SILVA_138.1_SSURef_NR99_tax_silva.tax NODE-HITS-WITH-TAX.txt

#### 3. scp these files to your computer (MATRIX-PERCENT.txt, MATRIX-COUNT.txt, and NODE-HITS-WITH-TAX.txt). Remember the period at the end of an scp line will copy the files to your current directory.
    ######(on your computer)
    cd /whateverdirectory/onyourcomputer/foranvio
    scp qdowling@jbpc-np.mbl.edu:/workspace/finaloutputdirectory/filename.txt .
    ###### have to scp each file one at a time.

#### 4. Save and open the txt files on your computer in excel. First copy the node hits info and transpose it in the sheet so that the oligotypes are in column 1. Then copy that into the sheet with the matrix percents. Save it as a new file (e.g. MATRIX-COUNTS-WITH-TAX.txt). See files "Original-matrix-count.txt" and "MATRIX-COUNTS-WITH-TAX.txt" as examples.

#### 5. Activate anvio on your computer (we did not use the server for this) and convert the original matrix percent txt file to a .tre file. Enter the interactive interface using the .tre file and the edited matrix percent for anvio file. The anvio interactive platform will open in a web browser.
        conda activate anvio-8
        anvi-matrix-to-newick MATRIX-PERCENT.txt -o MATRIX-PERCENT.tre --transpose
        anvi-interactive -d MATRIX-PERCENT-FOR-ANVIO.txt -p  MATRIX-PERCENT-FOR-ANVIO.db -t MATRIX-PERCENT.tre --manual-mode

##### This should enable you to explore the data visually with anvio. Have fun!



## Visualization with Phyloseq:

#### 1. Edit the final output matrix file "MATRIX-COUNT.txt" produced by oligotyping. This file needs to be transposed so the header contains the sample names and each row begins with the oligotyping id. See example file "MATRIX-COUNT-PHYLOSEQ.txt"

#### 2. As we did above with Anvi'o, you will need the NODE-HITS-WITH-TAX file for taxonomy for each of the representative sequences. This uses the vsearch command. Then convert the file using the python script. 

    cd /workspace/whateverdirectory/Methanosaeta-for-oligotyping-padded-sc7-s1-a0.0-A0-M50
    module load vsearch
    sed 's/-//g' OLIGO-REPRESENTATIVES.fasta > OLIGO-REPRESENTATIVES.fixed.fasta
    sed 's/"//g' OLIGO-REPRESENTATIVES.fixed.fasta > OLIGO-REPRESENTATIVES.final.fasta
    vsearch --usearch_global OLIGO-REPRESENTATIVES.final.fasta --db /databases/silva/138.1/SILVA_138.1_SSURef_NR99_tax_silva.fasta.gz --blast6out NODE-HITS.txt --id 0.6
    python  ~/scripts/convert-NODE-HITS-to-TAX.py NODE-HITS.txt /databases/silva/138.1/SILVA_138.1_SSURef_NR99_tax_silva.tax NODE-HITS-WITH-TAX.txt

#### 3.  You will need a metadata file with all of your samples that classifies each sample into whatever groups you may want to compare/graph individually. See example file (Seqtab-METADATA.txt).

#### Open RStudio on your machine and load in the phyloseq-oligotype-analysis.R script. If any of the libraries fail to load, you will need to install :) The version of R should be 4.3.3. 
###### Conduct a sanity check on the number of sequences using a summary of the sequence count that you can make using the command below - for your genus of course

    grep ">" Nitrosomonadaceae-for-oligotyping-padded.fa | cut -f 2 -d "_" | sort | uniq -c

#### Phyloseq enables you to create helpful plots of relative abundace such as bar plots and bubble plots. Phyloseq partners with the ggplot2 package to format plots.





    
