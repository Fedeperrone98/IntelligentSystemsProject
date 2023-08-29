%%
clear
close all 
clc

%% REMOVE CORRELATED FEATURES
load('saves/BEFORE_SEQUENTIALFS.mat');

FEATURES_MEAN = remove_correlated_features(FEATURES_MEAN);
FEATURES_STD = remove_correlated_features(FEATURES_STD);

%% SEQUENTIALFS INVOKE
sequentialfs_invoke(FEATURES_MEAN, MEAN_ECG, "mean_ecg"); 
sequentialfs_invoke(FEATURES_STD, STD_ECG, "std_ecg");