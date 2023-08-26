%% 
clear
close all 
clc

%% Allocate variables
c = constants();

% matrix creation 
FEATURES = zeros(c.feature_matrix_row_number, c.feature_matrix_column_number);
FEATURES_CONT_WINDS = zeros(c.feature_matrix_row_number, c.feature_matrix_column_number * c.windows_number_contiguos);
FEATURES_OVER_WINDS = zeros(c.feature_matrix_row_number, c.feature_matrix_column_number *c.windows_number_overlapped);
MEAN_ECG = zeros(c.feature_matrix_row_number, 1);
STD_ECG = zeros(c.feature_matrix_row_number, 1);
ACTIVITY_CLASSES = zeros(c.feature_matrix_row_number, 1);
% useful indices
feature_matrix_current_index = 1;
targets_matrix_current_index = 1;