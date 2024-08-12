# TYPHA-HOT-SPOT-16S

## We will keep records here of how we analyze the 16S rRNA gene sequencing for the DOE HOT SPOTS in HOT MOMENTS project

## OLIGOTYPING

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

# Copy important scripts into the directory 

    



    
