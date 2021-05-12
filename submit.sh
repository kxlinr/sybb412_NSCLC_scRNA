#!/bin/bash
#SBATCH -N 1
#SBATCH -c 5
#SBATCH --mem-per-cpu=25G
#SBATCH --time=0-36:00:00
#SBATCH --mail-user=kxl32@case.edu
#SBATCH --job-name="412_alignment"

cd /home/kxl732/sybb412/kxl732


cp -r align.sh $PFSDIR
cp -r srr.txt $PFSDIR


cd $PFSDIR

echo $PFSDIR

#module loads are in the script already
bash align.sh srr.txt
