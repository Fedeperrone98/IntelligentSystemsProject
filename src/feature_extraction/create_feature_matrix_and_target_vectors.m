%% 
clear
close all 
clc

%% Allocate variables
c = constants();

% matrix creation 
FEATURES_OVER_WINDS = zeros(c.feature_matrix_row_number, c.feature_matrix_column_number *c.windows_number_overlapped);
MEAN_ECG = zeros(c.feature_matrix_row_number, 1);
STD_ECG = zeros(c.feature_matrix_row_number, 1);
ACTIVITY_CLASSES = zeros(c.feature_matrix_row_number, 1);
% useful indices
feature_matrix_current_index = 1;
targets_matrix_current_index = 1;

%% SCAN FILES AND EXTRACT FEATURES
% scan each csv file 
csv_file = dir(fullfile(c.dataset_folder,'*.csv'));
% retrieve the directory of the csv files using the first csv
% all the csv files are in the same directory
directory_path = csv_file(1).folder;

% scan of every csv file 
for m = 1 : c.number_of_measurement
    
    % retrieve the name of the file csv to analyze
    filename = fullfile(csv_file(m).name);
    disp(filename); % print to the console the name of the current file we are analyzing
    
    % creation of the absolute path
    abs_path = fullfile(directory_path, filename);        
    
    if (contains(filename, c.csv_timeseries_identifier))
        % import the signals from the csv 
        temp_csv_table_timeseries = readtable(abs_path, 'Range', 'B:L');   
        
        %% HANDLE MISSING VALUES
        % Calculate the mean of each column, excluding the first row
        column_means = mean(temp_csv_table_timeseries{2:end, :}, 'omitnan');
        % replace missing values with column-wise means
        csv_table_timeseries_without_miss = fillmissing(temp_csv_table_timeseries,"constant", column_means);
        
        % conversion of the table containing the signals value
        timeseries_matrix_with_outliers = table2array(csv_table_timeseries_without_miss);
        
        %% REMOVE OUTLIERS
        matrix_to_extract_features = rmoutliers(timeseries_matrix_with_outliers);
        
    else % TARGETS (output of NN)
        % import the EGC signal from the csv 
        temp_csv_table_targets = readtable(abs_path, 'Range', 'B:B');
        
        %% HANDLE MISSING VALUES
        % Calculate the mean of each column, excluding the first row
        column_means = mean(temp_csv_table_targets{2:end, :}, 'omitnan');
        % replace missing values with column-wise means
        csv_table_targets_without_miss = fillmissing(temp_csv_table_targets,"constant", column_means);

        % conversion of the table containing the ECGs values
        targets_matrix_with_outliers = table2array(csv_table_targets_without_miss);

        %% REMOVE OUTLIERS
        matrix_to_extract_mean_std = rmoutliers(targets_matrix_with_outliers);
    end
end
