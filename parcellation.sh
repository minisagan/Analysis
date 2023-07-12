#!/bin/zsh 

#dataset=CHD
dataset=dHCP
dwidir=/data2/New_${dataset}/ShardRecon03
T2dir=/data2/New_${dataset}/derivatives
diffFolder=/data2/New_${dataset}

#echo "convert labels to cifti file"
wb_command -cifti-create-label /home/sma22/Desktop/NormMod/labels/v_parcel_150_regions.dlabel.nii -left-label /home/sma22/Desktop/NormMod/labels/v_parcel_left_150_regions.label.gii -right-label /home/sma22/Desktop/NormMod/labels/v_parcel_right_150_regions.label.gii

subject_list=/home/sma22/Desktop/NormMod/${dataset}/surf_list.txt
for subjid sesid pma in $(cat <${subject_list}) ; do 

echo "sub-${subjid} ses-${sesid}"
for mod in fa md curvature sulc corr_thickness pial midthickness ICVF ISOVF OD ; do #ADD MORE METRICS SULC CURV ETC FOR DHCP
for hemi in left right ; do 


#echo "convert map to dense scalar cifti"
wb_command -cifti-create-dense-scalar ${diffFolder}/surface_processing/surface_transforms/sub-${subjid}/ses-${sesid}/dhcpSym_32k/sub-${subjid}_ses-${sesid}-dhcpSym40_${mod}.dscalar.nii -left-metric ${diffFolder}/surface_processing/surface_transforms/sub-${subjid}/ses-${sesid}/dhcpSym_32k/sub-${subjid}_ses-${sesid}_hemi-left_space-dhcpSym40_${mod}.shape.gii -right-metric ${diffFolder}/surface_processing/surface_transforms/sub-${subjid}/ses-${sesid}/dhcpSym_32k/sub-${subjid}_ses-${sesid}_hemi-right_space-dhcpSym40_${mod}.shape.gii

mkdir -p ${diffFolder}/surface_processing/parcellated_metrics/sub-${subjid}/ses-${sesid}/dhcpSym_32k
#echo "parcellation"
if [[ ${mod} = pial ]]
then
	wb_command -cifti-parcellate ${diffFolder}/surface_processing/surface_transforms/sub-${subjid}/ses-${sesid}/dhcpSym_32k/sub-${subjid}_ses-${sesid}-dhcpSym40_${mod}.dscalar.nii /home/sma22/Desktop/NormMod/labels/v_parcel_150_regions.dlabel.nii COLUMN ${diffFolder}/surface_processing/parcellated_metrics/sub-${subjid}/ses-${sesid}/dhcpSym_32k/sub-${subjid}_ses-${sesid}-dhcpSym40_${mod}.pscalar.nii -method SUM
	
else

	wb_command -cifti-parcellate ${diffFolder}/surface_processing/surface_transforms/sub-${subjid}/ses-${sesid}/dhcpSym_32k/sub-${subjid}_ses-${sesid}-dhcpSym40_${mod}.dscalar.nii /home/sma22/Desktop/NormMod/labels/v_parcel_150_regions.dlabel.nii COLUMN ${diffFolder}/surface_processing/parcellated_metrics/sub-${subjid}/ses-${sesid}/dhcpSym_32k/sub-${subjid}_ses-${sesid}-dhcpSym40_${mod}.pscalar.nii 
	
fi

done
done
done
