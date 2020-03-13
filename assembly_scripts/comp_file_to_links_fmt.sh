#!/bin/bash 

# EOG09070BY5     PGA_scaffold_6  1       588     2653833 2670093 Duplicated      EOG09070BY5     HiC_scaffold_3  246     251     123710755       123714178       Complete
#   becomes
# Tse-6 2653833 2670093 Chel-3 123710755 123714178 color=chr6

# changing technique to handle these 3 formats:
#    PGA_scaffold_6 HiC_scaffold_3 scaffold_6_arrow_ctg1
# we'll replace /^.*scaffold_/ with the prefix

# where the number for the color comes from the number of the Tse 6 scaffold

# get the genome prefixes
sec=$2
[ -z "$sec" ] && sec="Chel"
fst=$3
[ -z "$fst" ] && fst="Tse"

# process each line
awk -v fst=$fst -v sec=$sec '
   BEGIN{OFS=" "}
   $9 == "Missing"{next}
   $2 == "Missing"{exit}
   {
     sub("^chr", "scaffold_", $2);
     nf=split($2, afst, "_"); nm_fst = afst[nf]; fst_scaf = fst"-"nm_fst
     ns=split($9, asec ,"_"); nm_sec = asec[ns]; sec_scaf = sec"-"nm_sec
   }
   {
     fst_scaf=$2; sub(/^.*scaffold_/, fst"-", fst_scaf)
     sec_scaf=$9; sub(/^.*scaffold_/, sec"-", sec_scaf)
     sub("_arrow_ctg1", "C", sec_scaf)
   }
   { print fst_scaf, $5,$6, sec_scaf, $12,$13, "color=chr"nm_fst, " #", $1, $3,$7, $10,$14}
  ' $1
