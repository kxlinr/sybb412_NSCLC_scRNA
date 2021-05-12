#!/bin/bash
echo "Run start: "
date

#Open modules
echo "----------Loading modules.----------"
module load samtools
module load skewer
module load STAR
echo "----------Modules loaded.----------"
date
echo .


#Open and read the file of the patient IDs
srr=`cat ${1}`


## FASTQC
echo "----------FastQC is starting.----------"
date
/home/kxl732/FastQC/fastqc /mnt/rstor/OOHPC/caseStudies/PRJNA591860/* -o /home/kxl732/sybb412/kxl732/fastqc_out/
echo "----------FastQC has completed.----------"
date
echo .
echo .
echo .


echo "----------The loop is opening.----------"
date
echo .

#open a for loop to go through each patient ID
for i in $srr
do

#use prof's stuff
PATH=$PATH:/home/gxb43/.local/bin


## TRIMMING
echo "----------Trimming is starting for sample " $i ".----------"
date

trim_galore /mnt/rstor/OOHPC/caseStudies/PRJNA591860/${i}_1.fastq.gz /mnt/rstor/OOHPC/caseStudies/PRJNA591860/${i}_2.fastq.gz --paired -o /home/kxl732/sybb412/kxl732/readsTrimmed

#skewer --mode pe --threads 1 --mean-quality 30 --min 36 -q 30 --output /home/kxl732/sybb412/kxl732/readsTrimmed/${i}_trimmed.fastq.gz --compress -y AGATCGGAAGAGC -x AGATCGGAAGAGC /mnt/rstor/OOHPC/caseStudies/PRJNA591860/${i}_1.fastq.gz /mnt/rstor/OOHPC/caseStudies/PRJNA591860/${i}_2.fastq.gz

echo "----------Trimming has completed for sample " $i ".----------"
date
echo .

##MULTIQC 1
multiqc /home/kxl732/sybb412/kxl732/trimmed_multiqc


## ALIGNMENT
echo "----------Alignment is starting for sample " $i ".----------"
date

STAR --readFilesCommand zcat  --runThreadN 20 --genomeDir /mnt/pan/courses/sybb412/genomes/Homo_sapiens/NCBI/GRCh38/Sequence/STARIndex --outSAMtype BAM Unsorted --readFilesIn /home/kxl732/sybb412/kxl732/readsTrimmed/${i}_1_val_1.fq.gz /home/kxl732/sybb412/kxl732/readsTrimmed/${i}_2_val_2.fq.gz  --outFileNamePrefix /home/kxl732/sybb412/kxl732/aligned/${i}_

#STAR --runThreadN 1  --genomeDir /mnt/pan/courses/sybb412/genomes/Homo_sapiens/NCBI/GRCh38/Sequence/STARIndex  --readFilesCommand /home/kxl732/sybb412/kxl732/readsTrimmed/${i}_trimmed.fastq.gz-trimmed-pair1.fastq.gz/ /home/kxl732/sybb412/kxl732/readsTrimmed/${i}_trimmed.fastq.gz-trimmed-pair2.fastq.gz

echo "----------Alignment is complete for sample " $i ".----------"
date
echo .



#sam to bam
#echo "Converting sam to bam for sample " $i
#samtools view -S -b $i.sam > $i.bam
#rm $i.sam
#echo "Sam has been converted to bam for sample" $i
#date
echo .
echo .
echo .

##Feature Counts
PATH=$PATH:/home/gxb43/caseStudies/bin
featureCounts -T 8 -s 0 -p -a /mnt/rstor/OOHPC/genomes/Homo_sapiens/NCBI/GRCh38/Annotation/Archives/archive-2015-08-11-09-31-31/Genes/genes.gtf -o /home/kxl732/sybb412/kxl732/counts/${i}.counts /home/kxl732/sybb412/kxl732/aligned/${i}_Aligned.out.bam

echo "----------------------------------------"
echo "---------------NEXT SAMPLE--------------"
echo "----------------------------------------"
echo .
echo .
echo .


#Close the loop
done
echo .
echo .
echo .
echo "----------The loop has completed.----------"
echo .
echo .
echo .


##Mult##MultiQC
multiqc /home/kxl732/sybb412/kxl732
echo "----------MultiQC Complete----------"



echo "End time: "
date
