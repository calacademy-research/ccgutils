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

**UCE_KIT run_pipeline Help**

    uce_kit.py pipeline_doc

    Given the three files, (1) UCE file in fasta format, (2) genome fasta file, and (3) genome's gene annotations in gff format,
    this shows how to create a file that shows summaries, and optionally detail, of the UCE gene types. That is, whether a
    UCE is one or more of Exon, Intron or Intergenic type in the subject genome.
    
    Assume the three files above are named: tetrapod_uces.fasta, galGal4.fna, and galGal4.gff
    Here's an abbreviated pipeline, with $ referring to the command line prompt of the terminal:
    
    $ uce_kit.py blat tetrapod_uces.fasta galGal4.fna >tetrapod_uces.galGal4_matches.m8
    
    $ uce_kit.py filt tetrapod_uces.galGal4_matches.m8 NT_ >galGal4_uce_locations.tsv
    
    $ add_introns_to_gff.py galGal4.gff >galGal4.with_introns.gff
    
    $ uce_gff_lines.py galGal4_uce_locations.tsv galGal4_with_introns.gff >galGal4_uce_type_summary.txt
    
    You can also have the 4 steps run for you using:
    
    $ uce_kit.py run_pipeline tetrapod_uces.fasta galGal4.fna galGal4.gff -filt NT_
    
    The above gets the summary of the types with additional info such as gene ID.
    Here's the command line info for that last program, you can run it with no arguments for a description:

        uce_gff_lines.py <uce_name_pos_file> <gff_file> [-lines [-nosummary]] [<gff_line_type_to_exclude> ...]
        
    Also note that last argument to the uce_kit.py filt tool. It is NT_ and means to exclude all scaffolds with
    UCE matches to the genome that occur in scaffolds that have an NT_ prefix.
    
    Example summary output. Gff lines not included in this. Distance is from previous UCE on scaffold.
    Columns: UCE    Scaf            UCE pos         Type    Distance GFF type list:
    uce-6357        NC_006088       16361333        I       238419   gene(ID=gene299) mRNA intron mRNA intron mRNA intron 
    uce-6734        NC_006088       17315669        EI      954336   gene(ID=gene301) mRNA intron mRNA intron mRNA exon mRNA exon mRNA exon 
    uce-6265        NC_006088       17632542        E       316873   gene(ID=gene301) mRNA exon mRNA exon mRNA exon 
    uce-7988        NC_006088       17765381        N       132839   intergenic
    uce-4637        NC_006088       18152376        N       386995   intergenic
    uce-4779        NC_006088       18364070        N       211694   intergenic
