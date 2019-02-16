**UCE_KIT**

uce_kit.py 

    usage: uce_kit.py blat | blast | filter_tsv | summary_totals | merge | run_pipeline  [file1] <file2> <option1>... | pipeline_doc
    
    filt[er_tsv] <blast_or_blat_results> <prefix_to_exclude>... # filter the results to output the uce_info file needed by uce_gff_lines.py

    blat <uce_fasta_file> <genome_fasta_file>   # uses blat to find where uce's are in the genome file, outputs in tsv format (no indexing required)
    blast <uce_fasta_file> <genome_fasta_file>  # uses blastn to find where uce's are in the genome file, outputs in tsv format (db indexing done first)
    
    merge <uce_probe_fasta_file>                # merge individual uce probes into a single sequence and output as fasta records
    
    sum[mary_totals] <uce_gff_summary_file>     # one line total for the uce summary types from the output of uce_gff_lines.py
    
    pipe[line_doc]                              # short description of how to go from uce's and genomes to uce exon, intron, intergenic categorization
    
    run_pipeline <uces> <genome> <gff>          # given these three files, run the 4 step pipeline documented by uce_kit.py pipeline_doc. -filt excludes
     [-filt <ex1>...] [-excl <ex1>...] [-lines] #  items with prefix in filter Step 2, -excl exclude terms and -lines outputs gff lines in gff Step 4.
