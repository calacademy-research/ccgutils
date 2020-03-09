This folder holds scripts that have been used in Genome Assembly, Annotation and other CCG research products.
They have been developed for Linux although most have also been run on MacOS.

A note on awk and bawk:
Scripts using `awk` occasionally use multidimension arrays. On MacOS the version of awk does not support this particular feature, but you can download `gawk` and change the script to use that instrad of awk in those few instances.

We use a a one-line bash script named `bawk` as a stand-in for `bioawk -c fastx "$@"` since most uses of bioawk are with fasta or fastq files.
You can get bioawk at https://github.com/lh3/bioawk/releases or a version with DNA to AA translate at https://github.com/ctSkennerton/bioawk
