#/bin/bash

# input looks like:
# EOG09070A67       Complete        scaffold_1    14560218        14595313        314.2   179

# output looks like:
# EOG090708CI	scaffold_1	1	221	397009	423976	Complete

tsv=$1
gawk 'BEGIN{count=1; OFS="\t"}
  FNR==1{FNum++}
  /^#/{next}

  FNum==1 && $2=="Missing"{next}
  FNum==1{scaf_eogs[$3][$1]++; next}

  count {
       for(s in scaf_eogs) {
          n = 0
          for(e in scaf_eogs[s]) n += scaf_eogs[s][e]
          eog_count[s] = n; eog_pos[s] = 0
       }
       count = 0
  }

  $2=="Missing" {missing_ix++; missing[missing_ix] = $0; next}

  {
      eog_pos[$3]++
      print $1, $3, eog_pos[$3], eog_count[$3], $4, $5, $2
  }
  END {
      for (m=1; m <= missing_ix; m++)
         print missing[m]
  } ' $tsv <(sort -k3,3V -k4,4n $tsv)
