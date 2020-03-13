#/bin/bash
# this uses the scaflen file as first argument
# and the busco run on the RC (revcomp) of the assembly as the second arg

### we sort by the revcomp values in field7, not field 4 like we do for the forward BUSCO full_table ###

# full_table input looks like:
# EOG09070A67       Complete        scaffold_1    14560218        14595313        314.2   179

# output of enhance_rc looks like:
# EOG090708CI   scaffold_1	Complete    397009  423976  <length_scaffold> <RC_start> <RC_end>

# final output adds pos and number of hits per scaffold as fields 3 and 4, and will look like:
# EOG090708CI	scaffold_1	1	221	397009	423976	Complete	<length_scaffold>	<RC_start>	<RC_end>

function enhance_rc {
   awk 'BEGIN{FS="\t";OFS="\t"}/^#/{next}
      FNR==NR{len[$1]=$2; next}
      $2=="Missing"{print; next}
      { lngth=len[$3]; beg = lngth-$5+1; end = lngth-$4+1
        print $1,$2,$3,$4,$5, lngth, beg, end
   }' $scaflens $tsv
}

scaflens=$1
tsv=$2
enhance_rc >rc_tsv_temp

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
      print $1, $3, eog_pos[$3], eog_count[$3], $4, $5, $2, $6,$7,$8 # 6,7,8 are scaflen and revcomped beg end
  }
  END {
      for (m=1; m <= missing_ix; m++)
         print missing[m]
  } ' rc_tsv_temp <(sort -k3,3V -k7,7n rc_tsv_temp)
