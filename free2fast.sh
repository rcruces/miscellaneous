#!/bin/bash
#
# MIGRATION FROM FREESURFER-6 TO FASTSURFER
#
# 1. Run fastsurfer segmentation only
# 2. Creates a UNION mask between the QCed freesurfer6 mask and fastsurfer mask
# 3. Calculates the new surface with fastsurfer's laplacian eigen mapping
# 4. Calculate the cortical morphology metrics on fsaverage5
#
# COMMAND:
# free2fast.sh sub-HC001 ses-01 10

# Positional variables
sub=${1}
ses=${2}
threads=${3}
here=$(pwd)
echo -e "\n-----------------------------------------"
echo "MIGRATION FROM FREESURFER-6 TO FASTSURFER"
echo "-----------------------------------------"
echo "sub   : ${sub}"
echo "ses   : ${ses}"
echo -e "cores : ${threads}\n"

# Positional variables
idBIDS=${sub}_${ses}
SUBJECTS_DIR=/data_/mica3/BIDS_MICs/derivatives/fastsurfer
fs_licence=/data_/mica1/01_programs/freesurfer-7.3.2/license.txt
fastsurfer_img=/data_/mica1/01_programs/fastsurfer/fastsurfer-cpu-v2.0.0.sif
T1nativepro=/data_/mica3/BIDS_MICs/derivatives/micapipe_v0.2.0/${sub}/${ses}/anat/${idBIDS}_space-nativepro_T1w_nlm.nii.gz
freesurfer_dir=/data_/mica3/BIDS_MICs/derivatives/freesurfer

# ------------------------------------------------------------------------------
# Only run if T1nativepro exist
if [ ! -f "${T1nativepro}" ]; then echo "[ERROR]... $T1nativepro does not exist, run micapipe v0.2.0 "; exit; fi
# Only run if QC file exist
if [ ! -f "${freesurfer_dir}/${idBIDS}/qc_done.txt" ]; then echo "[ERROR]... $idBIDS does not have freesurfer6 qc_done.txt"; exit; fi

unset TMPDIR
function make_surface(){
	# tmp directory
	tmp="/tmp/free2fast_${RANDOM}"
	# note I changed the tmp dir bc --surf_only is failing to mktmp a directory on the localhost/yeatman ??? I DON'T KNOW WHY
	# /data/mica2/temporaryNetworkProcessing also fails here
	export TMPDIR="${tmp}"
	mkdir -p ${tmp} && chmod 777 ${tmp}
  ls -dlas ${TMPDIR}

	# Run fastsurfer segmentation only
	if [ ! -f ${SUBJECTS_DIR}/${idBIDS}/mri/mask.mgz ]; then
		mkdir -p ${SUBJECTS_DIR}
		echo -e "\n[INFO]... fastsurfer seg_only"
		singularity exec --nv -B "${SUBJECTS_DIR}":/output -B "${T1nativepro}/":/anat/T1w.nii.gz -B "${fs_licence}:/license.txt" \
				"${fastsurfer_img}" /fastsurfer/run_fastsurfer.sh --fs_license /license.txt --t1 /anat/T1w.nii.gz --sid "${idBIDS}" --sd /output --no_fs_T1 --seg_only --parallel --threads "${threads}"

		# Replace the mask and norm from the QCed freesurfer6 on fastsurfer
		cd ${SUBJECTS_DIR}/${idBIDS}/mri
		orig_free=${tmp}/orig_freesurfer.nii.gz
		orig_fast=${tmp}/orig.nii.gz
		orig_str="${tmp}/from-freesurfer_to-fastsurfer_"
		orig_mat="${orig_str}0GenericAffine.mat"
		mask_free=${tmp}/brain_masked.nii.gz
		mask_fast=${tmp}/mask.nii.gz
		mask_U=${tmp}/union_mask.nii.gz

		mrconvert orig.mgz ${orig_fast}
		mrconvert mask.mgz ${mask_fast}
		mrconvert ${freesurfer_dir}/${idBIDS}/mri/brainmask.mgz ${tmp}/brainmask.nii.gz
		mrconvert ${freesurfer_dir}/${idBIDS}/mri/orig.mgz ${orig_free}

		# Remove freesurfer off-set
		antsRegistrationSyN.sh -d 3 -m "${orig_free}" -f "${orig_fast}"  -o "${orig_str}" -t a -n "$threads" -p d
		antsApplyTransforms -d 3 -i "${tmp}/brainmask.nii.gz" -r "${orig_fast}" -t "$orig_mat" -o "$mask_free" -v -u int

		# Get the union mask
		fslmaths ${mask_free} -bin -mul ${mask_fast} ${mask_U}

		# Replace the fastsurfer mask with the union_mask
		rm mask.mgz
		mrconvert ${mask_U} mask.mgz
		cd $here
	fi

	# Run the laplaician eigen mapping to generate the new surfaces
	echo -e "\n[INFO]... fastsurfer laplacian eigen mapping"
	singularity exec --nv -B "${SUBJECTS_DIR}":/output -B "${T1nativepro}/":/anat/T1w.nii.gz -B "${fs_licence}:/license.txt" \
			"${fastsurfer_img}" /fastsurfer/run_fastsurfer.sh --fs_license /license.txt --t1 /anat/T1w.nii.gz --sid "${idBIDS}" --sd /output --no_fs_T1 --surf_only --parallel --threads "${threads}"

	# Remove tmp dir
	rm -rfv ${tmp}
}

# Exit if fastsurfer already ran
dir_logs=${SUBJECTS_DIR}/${idBIDS}/scripts
if [[ -f "${dir_logs}/recon-surf.log" ]] && grep -q "finished without error" "${dir_logs}/recon-surf.log"; then
	echo "[INFO]... fastsurfer already processed"
else
	make_surface
fi

# Check if fastsurfer ran correctly
if [[ -f "${dir_logs}/recon-surf.log" ]] && grep -q "finished without error" "${dir_logs}/recon-surf.log"; then
	echo -e "[INFO]... fastsurfer finished without errors\n"
else
	echo -e "[ERROR]... fastsurfer failed\n"; rm ${SUBJECTS_DIR}/${idBIDS}/mri/aparc.DKTatlas+aseg.orig.mgz ; exit 0
fi
#------------------------------------------------------------------------------#
### Register morphology to fsLR-32k ###
function reg_surface(){
  morph_data=${1}
	recon=${2}

	# Data location
	export SUBJECTS_DIR="/data_/mica3/BIDS_MICs/derivatives/${recon}"
	dataDir="${SUBJECTS_DIR}/${idBIDS}/surf"
	outDir="/data_/mica3/BIDS_MICs/derivatives/free2fast/"

	# Register to fsa5 and apply
  if [[ ! -f "${outDir}/${idBIDS}_hemi-R_surf-fsaverage5_label-${morph_data}_${recon}.func.gii" ]]; then
	echo -e "[INFO]... Mapping ${morph_data} ${recon}\n"
  for hemi in lh rh; do
        [[ "$hemi" == lh ]] && hemisphere=l || hemisphere=r
        HEMICAP=$(echo $hemisphere | tr [:lower:] [:upper:])
        surf_id=${idBIDS}_hemi-${HEMICAP}_surf
        # Convert native file to mgh and save in output directory
        mri_convert "${dataDir}/${hemi}.${morph_data}" "${tmp_morph}/${surf_id}-fsnative_label-${morph_data}_${recon}.mgh"

        mri_surf2surf --hemi "$hemi" \
              --srcsubject "$idBIDS" \
              --srcsurfval "${tmp_morph}/${surf_id}-fsnative_label-${morph_data}_${recon}.mgh" \
              --trgsubject fsaverage5 \
              --trgsurfval "${tmp_morph}/${surf_id}-fsaverage5_label-${morph_data}_${recon}.mgh"
        mri_convert "${tmp_morph}/${surf_id}-fsaverage5_label-${morph_data}_${recon}.mgh" "${outDir}/${surf_id}-fsaverage5_label-${morph_data}_${recon}.func.gii"
			done
  else
      echo -e "[INFO]... Subject ${id} cortical ${morph_data} is registered to fsa5"
  fi
}

# Map the morphological features to fsLR-32k for comparisons
tmp_morph="/data/mica2/temporaryNetworkProcessing/free2fast_${RANDOM}"
mkdir -p ${tmp_morph} && chmod 777 ${tmp_morph}
reg_surface "thickness" "freesurfer"
reg_surface "curv" "freesurfer"
reg_surface "sulc" "freesurfer"

reg_surface "thickness" "fastsurfer"
reg_surface "curv" "fastsurfer"
reg_surface "sulc" "fastsurfer"
rm -rf ${tmp_morph}

echo -e "[DONE]... fastsurfer with freesurfe QC finished"

micapipe -bids /data_/mica3/BIDS_MICs/rawdata -out /data_/mica3/BIDS_MICs/derivatives -sub ${sub} -ses ${ses} -proc_surf -fastsurfer -surf_dir ${SUBJECTS_DIR} -mica
