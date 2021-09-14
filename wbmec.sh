DIR_INDEX="data/index"
cd ${DIR_INDEX}

wget -O Amel_HAv3.1.fna.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/254/395/GCF_003254395.2_Amel_HAv3.1/GCF_003254395.2_Amel_HAv3.1_genomic.fna.gz
gunzip Amel_HAv3.1.fna.gz
wget -O Amel_HAv3.1.gff.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/254/395/GCF_003254395.2_Amel_HAv3.1/GCF_003254395.2_Amel_HAv3.1_genomic.gff.gz
gunzip Amel_HAv3.1.gff.gz

DIR_SRA="data/raw"

cd ${DIR_SRA}

SRA=("SRR10901308" "SRR10901307" "SRR10901296" "SRR10901291" "SRR10901290" \
     "SRR10901289" "SRR10901288" "SRR10901287" "SRR10901286" "SRR10901285" \
     "SRR10901306" "SRR10901305" "SRR10901304" "SRR10901303" "SRR10901302" \
     "SRR10901301" "SRR10901300" "SRR10901299" "SRR10901298" "SRR10901297" \
     "SRR10901295" "SRR10901294" "SRR10901293" "SRR10901292")

for i in "${SRA[@]}"
do
  prefetch -O ${DIR_SRA} ${i}
  fasterq-dump -O ${DIR_SRA} ${DIR_SRA}/${i}.sra
  rm sra/{i}.sra
done

DIR_TRIM="data/trimmed"

for i in "${SRA[@]}"
do
  trim_galore --fastqc -j 8 --paired -o ${DIR_TRIM} ${i}_1.fastq ${i}_2.fastq
done

cd ${DIR_INDEX}

gffread Amel_HAv3.1.gff -g Amel_HAv3.1.fna -w Amel_HAv3.1_transcripts.fasta -F

kallisto index --make-unique -i kallisto_Amel_HAv3.1 Amel_HAv3.1_transcripts.fasta

cd ${DIR_TRIM}

DIR_KALLISTO="data/kallisto"

for i in "${SRA[@]}"
do
  kallisto quant -i ${DIR_INDEX}/kallisto_Amel_HAv3.1 -o ${DIR_KALLISTO}/${i} \
   -t 2 ${i}_1_val_1.fq ${i}_2_val_2.fq
done
