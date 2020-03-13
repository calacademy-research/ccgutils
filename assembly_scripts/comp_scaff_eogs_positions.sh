#!/bin/bash
# enter 2 scaff ordered busco tsvs file as args.
# this will write out the lines from the first file and the corresponding EOG info for the second.
# handling duplicates is better than before, but still could be improved, especially when a file 1 scaffold's first EOG is a Duplicate EOG in file2

# example output comp_eog line:
# EOG090700S2     scaffold_1  4       227     4630379 4649259 Complete        EOG090700S2     scaffold_4_arrow_ctg1   221     225     142486716       142514136       Complete

awk 'FNR==NR{eogs++
             eog_pos[eogs]=$1
             eogs_inf_1[$1]=$0
             pos_inf_1[eogs]=$0
             next
     }

     FNR!=NR{if($1 in eogs_inf_2) {
                dup_count[$1]++; ix = dup_count[$1]
                if (ix==1) {
                   dup_inf[$1][ix] = eogs_inf_2[$1]; dup_scaf[$1][ix] = eogs_scaf_2[$1]
                   dup_count[$1] = 2; ix = 2
                }
                dup_inf[$1][ix] = $0; dup_scaf[$1][ix] = $2
                dup_ix[$1] = 1
             }
             else {
                eogs_inf_2[$1]=$0
                eogs_scaf_2[$1]=$2
             }
     }

     END{for (e=1; e <= eogs; e++) {
           sco = eog_pos[e]

           if (sco in dup_inf) {
              inf_2 = ""

              for (d=1; d <= length(dup_scaf[sco]); d++) {
                 if (dup_scaf[sco][d] == last_scaf_2) {
                    inf_2 = dup_inf[sco][d]
                    dup_scaf[sco][d] = ""
                 }
              }
              if (inf_2 == "") {
                 ix = dup_ix[sco]; dup_ix[sco]++
                 if (ix <= length(dup_inf[sco]))
                    inf_2 = dup_inf[sco][ix]
              }
           }
           else {
              inf_2 = eogs_inf_2[sco]
              last_scaf_2 = eogs_scaf_2[sco]
           }

           print pos_inf_1[e] "\t" inf_2
        }
      }' $1 $2
