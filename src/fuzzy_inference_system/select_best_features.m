clear; 
clc;
close all;

%% Load data
load('saves/BEFORE_TRAINING.mat');
INPUT = INPUT_ACTIVITY';
TARGET = TARGET_ACTIVITY_CLASSES_VECTOR';

%% Sequential feature selection

opts = statset('Display', 'iter','UseParallel',true);
fs = sequentialfs(@sequentialfs_criterion, ...
                  INPUT, TARGET, ...
                  'opt', opts, ...
                  'nfeatures', constants.features_to_select_for_FIS);
INPUT = INPUT(:, fs);

%% Save results
INPUT = INPUT';
TARGET = TARGET';
save('saves/FIS_INPUT', 'INPUT', 'TARGET');
