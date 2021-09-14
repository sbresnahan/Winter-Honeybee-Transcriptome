DIR_TRIMMED="data/trimmed"
DIR_no_rRNA="data/no_rRNA"

bowtie2-build Amel_Mt_rRNA.fasta Amel_Mt_rRNA
bowtie2 -p 8 -x Amel_Mt_rRNA \
   -1 ${DIR_TRIMMED}/SRR10901306_1_val_1.fq \
   -2 ${DIR_TRIMMED}/SRR10901306_2_val_2.fq > ${DIR_no_rRNA}/SRR10901306_rRNA.sam

bowtie2 -p 8 -x Amel_Mt_rRNA \
   -1 ${DIR_TRIMMED}/SRR10901286_1_val_1.fq \
   -2 ${DIR_TRIMMED}/SRR10901286_2_val_2.fq > ${DIR_no_rRNA}/SRR10901286_rRNA.sam

samtools view -f 4 -O BAM ${DIR_no_rRNA}/SRR10901306_rRNA.sam | \
   samtools sort -n - > ${DIR_no_rRNA}/SRR10901306_no_rRNA.bam
samtools view -f 4 -O BAM ${DIR_no_rRNA}/SRR10901286_rRNA.sam | \
   samtools sort -n - > ${DIR_no_rRNA}/SRR10901286_no_rRNA.bam

bedtools bamtofastq -bam ${DIR_no_rRNA}/SRR10901306_no_rRNA.bam \
   -fq ${DIR_no_rRNA}/SRR10901306_1_no_rRNA.fq \
   -fq2 ${DIR_no_rRNA}/SRR10901306_2_no_rRNA.fq

bedtools bamtofastq -bam ${DIR_no_rRNA}/SRR10901286_no_rRNA.bam \
   -fq ${DIR_no_rRNA}/SRR10901286_1_no_rRNA.fq \
   -fq2 ${DIR_no_rRNA}/SRR10901286_2_no_rRNA.fq

kallisto quant -i kallisto_Amel_HAv3.1 -o ${DIR_no_rRNA}/SRR10901306 \
   -t 8 ${DIR_no_rRNA}/SRR10901306_1_no_rRNA.fq ${DIR_no_rRNA}/SRR10901306_2_no_rRNA.fq

kallisto quant -i kallisto_Amel_HAv3.1 -o ${DIR_no_rRNA}/SRR10901286 \
   -t 8 ${DIR_no_rRNA}/SRR10901286_1_no_rRNA.fq ${DIR_no_rRNA}/SRR10901286_2_no_rRNA.fq
