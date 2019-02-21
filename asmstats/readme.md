This modifies the Assemblathon2 statistics program assemblaton_stats.pl (https://github.com/ucdavis-bioinformatics/assemblathon2-analysis) in a few ways.

One it changes the default break size for a contig to 10 from 25 Ns and it adds a few more lines of output including the L50 with the various N50 outputs.
It also adds a -m <len> argument to exlude scaffold records less than <len> from the analysis.

asmstats.pl requires FAlite.pm to be found by PERL

**Usage**

    Usage: asmstats.pl <assembly_scaffolds_file>
    options:
	    -limit <int> limit analysis to first <int> sequences (useful for testing)
	    -csv         produce a CSV output file of all results
	    -graph       produce a CSV output file of NG(X) values (NG1 through to NG99), suitable for graphing
	    -n <int>     specify how many consecutive N characters should be used to split scaffolds into contigs [default: 10]
        -m <int>     minimum scaffold length, sequences less than this are excluded from analysis [default: 0]
	    -genome_size <int> estimated or known genome size

        modification of: github.com/ucdavis-bioinformatics/assemblathon2-analysis/blob/master/assemblathon_stats.pl


**Example output**
           
           -------------- Information for assembly 'centropyge_vrolikii.fasta' -------------

                                         Number of scaffolds      35056
                                     Total size of scaffolds  696146811
                                            Longest scaffold   10487947
                                           Shortest scaffold        500
                                 Number of scaffolds > 1K nt      17601  50.2%
                                Number of scaffolds > 10K nt       2476   7.1%
                               Number of scaffolds > 100K nt        682   1.9%
                                 Number of scaffolds > 1M nt        151   0.4%
                                Number of scaffolds > 10M nt          3   0.0%
                                          Mean scaffold size      19858
                                        Median scaffold size       1005
                                         N50 scaffold length    1549028  L50 scaffold count        104
                                         N60 scaffold length     930077  L60 scaffold count        162
                                         N70 scaffold length     570579  L70 scaffold count        260
                                         N80 scaffold length     277087  L80 scaffold count        430
                                         N90 scaffold length      30867  L90 scaffold count       1192
                                                 scaffold %A      28.63
                                                 scaffold %C      20.54
                                                 scaffold %G      20.55
                                                 scaffold %T      28.67
                                                 scaffold %N       1.62
                                         scaffold %non-ACGTN       0.00
                             Number of scaffold non-ACGTN nt      20174

                Percentage of assembly in scaffolded contigs      90.4%
              Percentage of assembly in unscaffolded contigs       9.6%
                      Average number of contigs per scaffold        1.3
    Average length of break (>10N) between contigs in scaffold     1204

                                           Number of contigs      44381
                              Number of contigs in scaffolds      11307
                          Number of contigs not in scaffolds      33074
                                       Total size of contigs  684914400
                                              Longest contig    1806211
                                             Shortest contig          2
                                   Number of contigs > 1K nt      26797  60.4%
                                  Number of contigs > 10K nt       6783  15.3%
                                 Number of contigs > 100K nt       1725   3.9%
                                   Number of contigs > 1M nt         24   0.1%
                                  Number of contigs > 10M nt          0   0.0%
                                            Mean contig size      15433
                                          Median contig size       1305
                                           N50 contig length     190685  L50 contig count        909
                                           N60 contig length     136392  L60 contig count       1334
                                           N70 contig length      83188  L70 contig count       1977
                                           N80 contig length      36647  L80 contig count       3209
                                           N90 contig length       9670  L90 contig count       6911
                                                   contig %A      29.10
                                                   contig %C      20.88
                                                   contig %G      20.88
                                                   contig %T      29.14
                                                   contig %N       0.00
                                           contig %non-ACGTN       0.00
                               Number of contig non-ACGTN nt      20174

