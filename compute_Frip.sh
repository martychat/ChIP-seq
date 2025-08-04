#!/bin/bash
echo -e "Sample\tTotalReads\tReadsInPeaks\tFRiP" > frip_results.tsv

for i in {1..4}; do
  bam="/workdir/Martik/ChIP/Msexta_babChIP/Oct24/Msexta_bab_rep${i}.filtered.sorted.nd.bam"
  peaks="/workdir/Martik/ChIP/Msexta_babChIP/Oct24/peakcalls_without_downsizing/PeakCalls_with_q_values/Replicate_${i}/q_point01/Msexta_bab_rep${i}_q01_peaks.narrowPeak"
  
  total_reads=$(samtools view -c "$bam")
  reads_in_peaks=$(bedtools intersect -a "$bam" -b "$peaks" -bed | wc -l)
  frip=$(echo "scale=4; $reads_in_peaks / $total_reads" | bc)
  
  echo -e "rep${i}\t$total_reads\t$reads_in_peaks\t$frip" >> frip_results.tsv
done
