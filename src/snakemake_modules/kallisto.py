# a fucntion to work out the index name using the fasta file path

import os 

def get_indx_name(fasta_path):
    
    fasta = os.path.basename(fasta_path)
    base = os.path.splitext(fasta)[0]
    index = base + ".idx"
    
    return(index)




def read_length_average(fastqc_report_txt):
    
    file = open(fastqc_report_txt)
  
    # read the content of the file opened
    length_line =  file.readlines()[8]
    length = length_line.split()[2]
    
    return(int(length))



