#!/bin/bash

#dataset=CHD
dataset=dHCP
dwidir=/data2/New_${dataset}/ShardRecon03
T2dir=/data2/New_${dataset}/derivatives
diffFolder=/data2/New_${dataset}


subject_list=/home/sma22/Desktop/NormMod/${dataset}/surf_list_bash.txt
for mod in fa md curvature sulc corr_thickness pial ICVF ISOVF OD; do 
for hemi in left right ; do
echo ${mod} ${hemi}
mkdir -p ${diffFolder}/AverageMetrics
output=${diffFolder}/AverageMetrics/${dataset}_average-${hemi}-${mod}.shape.gii

echo "MERGING THE IMAGES" 
MergeSurfaceSTRING=""

for subj in $(cat <${subject_list}) ; do
subjid=$(echo ${subj} | cut -d "/" -f 1)
sesid=$(echo ${subj} | cut -d "/" -f 2)
pma=$(echo ${subj} | cut -d "/" -f 3)

#add the directory name to a string called MergeSurfaceSTRING


MergeSurfaceSTRING+="-metric ${diffFolder}/surface_processing/surface_transforms/sub-${subjid}/ses-${sesid}/dhcpSym_32k/sub-${subjid}_ses-${sesid}_hemi-${hemi}_space-dhcpSym40_${mod}.shape.gii "
done
MergeSurfaceSTRING=${MergeSurfaceSTRING%?}

wb_command -metric-merge ${output} ${MergeSurfaceSTRING} 

#wb_command -metric-math "abs(x)" ${output} -var x ${output}

echo "AVERAGING THE IMAGES"
wb_command -metric-reduce ${output} MEAN ${output}
wb_command -metric-mask ${output} /data2/New_CHD/surface_processing/week-40_hemi-${hemi}_space-dhcpSym_dens-32k_desc-medialwallsymm_mask.shape.gii ${output}
done
done
#done
