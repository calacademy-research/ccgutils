This modifies the Assemblaton2 statistics program assemblaton_stats.pl in a few ways.
One it changes the default break size for a contig to 10 from 25 Ns and it adds a few more lines of output including the L50 with the various N50 outputs.
It also adds a -m <len> argument to exluce scaffold records less than <len> from the analysis.

asmstats.pl requires FAlite.pm to be found by PERL