#!/bin/bash
# first argument is the scaflens file we need for the RC full_table
# second arg is forward full_table tsv
# third arg is RC full_table tsv (which we will enhance with scaflen and revcomp begin end)

# BUSCO in forward full_table tsv has this format after make_scaff_order_busco_tsv.sh
# EOG090709BB	scaffold1	19360836	19415414	Complete

# BUSCO in RC (revcomp) full_table will have this format after make_RC_scaff_order_busco_tsv.sh
# here field 6 is length of scaffold, 9 is RC begin and 10 is RC end (field 5 and 6 are the postions before revcomping)
# EOG090709BB	scaffold1	372235	426813	Complete	19787648	19360836	19415414

# output will be these lines sorted and having position of BUSCO in scaffold in field 3 and total number of BUSCOs in scaffold in field 4
# EOG090709BB   scaffold1   34   34       372235  426813  Complete        19787648        19360836        19415414


function enhance_rc {
   awk 'BEGIN{FS="\t";OFS="\t"}/^#/{next}
      FNR==NR{len[$1]=$2; next}
      $2=="Missing"{print; next}
      { lngth=len[$3]; beg = lngth-$5+1; end = lngth-$4+1
        print $1,$2,$3,$4,$5, lngth, beg, end
   }' $scaflens $rc_tsv
}

if [ $# -lt 3 ]; then
   echo "Usage: combine_full_table_and_revcomp_full_table.sh <scaflens_file> <fwd_full_table_tsv> <RC_full_table_tsv>"
   exit
fi

scaflens=$1
fwd_tsv=$2
rc_tsv=$3
enhanced_rc_tsv=rc_tsv_temp

enhance_rc >$enhanced_rc_tsv

awk -v FS="\t" -v OFS="\t" '/^#/{next}

   FNR==NR && $2 == "Missing" { missing[$1]++; next }
   FNR==NR && $2 == "Fragmented" { fragmented[$1]=$0; next }
   FNR==NR{print; next}

   $1 in missing {
      print $1,$2,$3, $9,$10, $6,$7, $8, $4,$5
      next
   }

   ! ($1 in fragmented) { next }

   $2=="Fragmented" || $2=="Missing" {print fragmented[$1]; next}
   { print $1,$2,$3, $9,$10, $6,$7, $8, $4,$5, "Improved" } # improves the first file Fragmented to a Complete or Duplicate
 '  $fwd_tsv $enhanced_rc_tsv | sort -k3,3V -k4,4n >combined_tsv_temp

make_scaff_order_busco_tsv.sh combined_tsv_temp
