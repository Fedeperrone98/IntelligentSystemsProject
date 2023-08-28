%% 
clear
close all 
clc

load('saves/BEFORE_DATA_AUGMENTATION.mat');
samples_to_generate = constants.autoenc_samples_to_generate;

%% Launch data_augmentation
FEATURES = data_augmentation(FEATURES);
FEATURES = normalize_matrix(FEATURES);

FEATURES_MEAN = data_augmentation(FEATURES_MEAN);
FEATURES_MEAN = normalize_matrix(FEATURES_MEAN);

FEATURES_STD = data_augmentation(FEATURES_STD);
FEATURES_STD = normalize_matrix(FEATURES_STD);

%% Replicate targets
MEAN_ECG = repmat(MEAN_ECG, samples_to_generate+1, 1);
STD_ECG = repmat(STD_ECG, samples_to_generate+1, 1);
ACTIVITY_CLASSES_VECTOR = repmat(ACTIVITY_CLASSES_VECTOR, samples_to_generate+1, 1);

%% Save results
save('saves/BEFORE_SEQUENTIALFS',...
    'FEATURES',...
    'FEATURES_MEAN',...
    'FEATURES_STD',...
    'MEAN_ECG',...
    'STD_ECG',...
    'ACTIVITY_CLASSES_VECTOR');