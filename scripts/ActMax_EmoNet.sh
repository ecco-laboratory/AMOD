#!/bin/bash
#SBATCH --account=default
#SBATCH --partition=week-long
#SBATCH --nodelist=gpu1
#SBATCH --time=6-00:00:00
#SBATCH --mem=64GB  #ram
#SBATCH --gpus-per-node=2

eval "$(conda shell.bash hook)"
conda activate AMOD
cd /home/data/eccolab/Code/ActMax-Optimizer-Dev/

#iterate over subjects to optimize brain activity in NAc and CeA
#python3 ActMax.py --encoding_filename /home/gjang/beta_csv/fc7/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_amygdala_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amygdala_GJ
#python3 ActMax.py --encoding_filename /home/pkragel/fc7_sub${SLURM_ARRAY_TASK_ID}_betas_NAc.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_betas_NAc

#iterate over categorize to optimize perceived objects and emotional situations
python3 ActMax.py --act_layer .Conv2dConv_7 --unit ${SLURM_ARRAY_TASK_ID} --output_filename emonet_genfc6_actfc8_${SLURM_ARRAY_TASK_ID} 
#python3 ActMax.py --classifier alexnet --act_layer .classifier.Linear6 --unit ${SLURM_ARRAY_TASK_ID} --output_filename alexnet_genfc6_linear6_unit${SLURM_ARRAY_TASK_ID}


#python3 ActMax.py --encoding_filename /home/pkragel/mean_betas_amy_subregion1.csv --output_filename emonet_genfc6_actfc7_mean_betas_amy_subregion1
#python3 ActMax.py --encoding_filename /home/pkragel/mean_betas_Nac.csv --output_filename emonet_genfc6_actfc7_mean_betas_NAc

#iterate over subjects to optimize brain activity in ROIs: Amygdala, IT, VC (averaged across voxels = mean betas)
##python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/pkragel/beta_csv/fc7/amygdala/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_amygdala_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amygdala_randinit
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/amygdala/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_amygdala_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amygdala_randinit_run19 --output_folder output/amygdala/actfc7
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/itcortex/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_itcortex_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_itcortex_randinit_run19 --output_folder output/itcortex/actfc7
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/visualcortex/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_visualcortex_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_visualcortex_randinit_run19 --output_folder output/visualcortex/actfc7


#iterate over subjects to optimize brain activity in Amygdala subregions ROIs: AStr, CM, LB, SF (averaged across voxels = mean betas)
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/amygdala_subregions_GJ/AStr/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_Amygdala_AStr_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amyAStr_randinit_run19 --output_folder output/amygdala_subregions_GJ/AStr/actfc7
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/amygdala_subregions_GJ/CM/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_Amygdala_CM_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amyCM_randinit_run20 --output_folder output/amygdala_subregions_GJ/CM/actfc7
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/amygdala_subregions_GJ/LB/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_Amygdala_LB_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amyLB_randinit_run7 --output_folder output/amygdala_subregions_GJ/LB/actfc7
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/amygdala_subregions_GJ/SF/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_Amygdala_SF_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amySF_randinit_run22 --output_folder output/amygdala_subregions_GJ/SF/actfc7


#iterate over subjects to optimize brain activity in patterns/signatures of fear in the Amygdala: Fearful, PINES, VIFS (averaged across voxels = mean betas)
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/amygdala_pattern_expression/Fearful/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_amygdala_Fearful_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amyFearful_randinit_run5 --output_folder output/amygdala_pattern_expression/Fearful/actfc7
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/amygdala_pattern_expression/PINES/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_amygdala_PINES_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amyPINES_randinit_run5 --output_folder output/amygdala_pattern_expression/PINES/actfc7
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/amygdala_pattern_expression/VIFS/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_amygdala_VIFS_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_amyVIFS_randinit_run5 --output_folder output/amygdala_pattern_expression/VIFS/actfc7

#iterate over subjects to optimize brain activity in patterns/signatures of fear in the Whole Brain: Fearful, VIFS (averaged across voxels = mean betas)
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/wholebrain_pattern_expression/Fearful/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_wholebrain_Fearful_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_wbFearful_randinit_run10 --output_folder /home/data/eccolab/AMax/artificial_stim/output/wholebrain_pattern_expression/Fearful/actfc7
#python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/wholebrain_pattern_expression/VIFS/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_wholebrain_VIFS_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_wbVIFS_randinit_run6 --output_folder /home/data/eccolab/AMax/artificial_stim/output/wholebrain_pattern_expression/VIFS/actfc7

#TEST: iterate over subjects to optimize brain activity in patterns/signatures of fear in the Whole Brain: Fearful, VIFS (averaged across voxels = mean betas)
#NUMS=(
#    "7"
#    "8"
#    "9"
#)
#for RUN_NUM in "${NUMS[@]}"; do
#    python3 ActMax.py --act_layer .Conv2dConv_6 --encoding_filename /home/data/eccolab/Code/ActMax-Optimizer-Dev/encoding_models/betas/fc7/wholebrain_pattern_expression/Fearful/mean_b/meanbeta_sub-${SLURM_ARRAY_TASK_ID}_wholebrain_Fearful_fc7_invert_imageFeatures.csv --output_filename emonet_genfc6_actfc7_sub${SLURM_ARRAY_TASK_ID}_meanbetas_wbFearful_randinit_${RUN_NUM} --output_folder /home/data/eccolab/AMax/artificial_stim/output/wholebrain_pattern_expression/Fearful/actfc7
#    wait
#done