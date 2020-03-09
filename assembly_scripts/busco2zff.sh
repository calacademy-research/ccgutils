#/bin/bash
# use the complete single copy genes found in a BUSCO Phase 1 run (these are used to train augustus for Phase 2)
#  and make a genome.ann and genome.dna file for training the SNAP HMM gene finder.
# We use the files in the augustus_output/gb directory to create the files. Each gb file has the
# CDS description and the excerpt of the gene sequence with 1000 bases of surrounding sequence from the genome.
# The genome.dna file we make (and the ann file that corresponds to it) is just these excerpts.

# to use:
# busco2zff.sh run_busco_dir >genome.dna 2>genome.ann 

# this handles one file raw.gb that is named as the first and only argument of the function
function one_gb_to_SNAP_zff {
    file=$1
    name=$(basename $file .raw.gb)

    # note to escape dots in awk regexp, must use 2 backslashes: "\\.
    awk -v recname=$name 'BEGIN{}
          /CDS/{cdsstr=$0; sub("CDS","",cdsstr);  if(index($0,"(") && !index($0,")"))cds=1;next}
          cds{cdsstr = cdsstr $0}
          /)$/{cds=0}

          /\/\//{dna=0}
          dna{for(i=2;i<=NF;i++){printf "%s", $i} print ""}

          /ORIGIN/{dna=1;cds=0; print ">"recname}
          END{cds2zff(recname,cdsstr)}

          function cds2zff(nm, cdsstr) {
             print ">"nm > "/dev/stderr"
             p1=1; p2=2
             gsub(" ","",cdsstr); sub(")+$","",cdsstr)
             cmpstr="complement("; joinstr="join("
             complement = (index(cdsstr,cmpstr)==1)
             if(complement) {
                p1=2; p2=1
                cdsstr = substr(cdsstr, length(cmpstr)+1)
             }
             exon_count=gsub("\\.\\.","..",cdsstr)
             if(exon_count==1) {  # singleton
                split(cdsstr,pos,"\\.\\.")
                print "Esngl\t" pos[p1] "\t" pos[p2] "\t" nm > "/dev/stderr"
             }
             else if(index(cdsstr,joinstr)==1) { # join(...)
                cdsstr = substr(cdsstr,length(joinstr)+1)
                exons = split(cdsstr, ar, ",")
                kind = (complement) ? "Eterm" : "Einit"
                for(e=1; e<=exons; e++) {
                  if(e==exons){ kind = (complement) ? "Einit" : "Eterm" }
                  split(ar[e],pos,"\\.\\.")
                  print kind "\t" pos[p1] "\t" pos[p2]  "\t" nm > "/dev/stderr"
                  kind="Exon"
                }
             }

             # print cdsstr > "/dev/stderr"
          }
  ' $file | bawk '{print ">"$name; print toupper($seq)}' | fold -w 100
}


# we can enter any of the directories starting with the BUSCO output dir or a gb file
function check4gbs {
    gbs_exist=$(ls -1 $1/*.raw.gb 2>/dev/null | head -n 1 | wc -l)
}

inp=$1
if [[ -d $inp ]]; then # see if any raw.gb files are found in this dir or underneath in special BUSCO dirs
    check4gbs $inp
    if [ $gbs_exist == 0 ]; then
       if [ -d "$inp/augustus_output/gb" ]; then
          inp=$inp/augustus_output/gb
       elif [ -d "$inp/gb" ]; then
          inp=$inp/gb
       fi
       check4gbs $inp
    fi
elif [[ -f $inp ]]; then
    one_gb_to_SNAP_zff $inp >genome.dna 2>genome.ann
    exit 0
else
    gbs_exist=0
fi

if [ $gbs_exist == 0 ]; then
    echo "\"$inp\" is not a gb file and it is not a BUSCO directory containing any raw.gb files"
    exit 1
else
    echo "Converting *.raw.gb files in $inp to ZFF format genome.ann and genome.dna files"
fi

# we have a directory with raw.gb files. convert all of them and append to genome.dna and genome.ann files
# zero length files can cause trouble so we will check for those

>genome.dna; >genome.ann; >genome.err

for gb in $inp/*.raw.gb; do
   if [ -s $gb ]; then
       one_gb_to_SNAP_zff $gb >>genome.dna 2>>genome.ann
   else
       echo "\"$gb\" is empty" >>genome.err
   fi
done
