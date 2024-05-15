# AMOD
 
The purpose of this project is to understand and modulate amygdala activity through noninvasive visual input.

The first part of this project involves building encoding models from existing fMRI data using the ANN EmoNet as a feature extractor. These encoding models will predict how the amygdala activates or response to input visual stimuli.
Validation of these encoding models' performances will be done by comparing predicted activity in encoding models vs observed activity in BOLD data. Validation will also be done using naturalistic stimuli from the IAPS and OASIS datasets to see if the encoding model's predictions align with human brain data.

The second part of this project involves using the encoding models as targets for activation maximization in a deep generator network to generate artificial stimuli. Artificial stimuli will be optimized for activating a particular region of interest's encoding model. Categorization of artificial stimuli will be done to assess for differences in visual features and in the predicted activation from encoding models.
