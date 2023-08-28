%% 
clear
close all 
clc

%% Allocate variables
c = constants();

% matrix creation 
FEATURES = zeros(c.feature_matrix_row_number, c.feature_matrix_column_number *c.windows_number_overlapped);
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
        matrix_to_extract_features = table2array(csv_table_timeseries_without_miss);
       
        %% EXTRACT FEATURES
        % feature matrix with overlapped windows
        FEATURES = matrix_copy(FEATURES,...
                               produce_feature_vector(matrix_to_extract_features,...
                                                    c.windows_number_overlapped),...
                               feature_matrix_current_index,... 
                               1);
        feature_matrix_current_index = feature_matrix_current_index + 1;
        
    else % TARGETS (output of NN)
        % import the EGC signal from the csv 
        temp_csv_table_targets = readtable(abs_path, 'Range', 'B:B');
        
        %% HANDLE MISSING VALUES
        % Calculate the mean of each column, excluding the first row
        column_means = mean(temp_csv_table_targets{2:end, :}, 'omitnan');
        % replace missing values with column-wise means
        csv_table_targets_without_miss = fillmissing(temp_csv_table_targets,"constant", column_means);

        % conversion of the table containing the ECGs values
        matrix_to_extract_mean_std  = table2array(csv_table_targets_without_miss);

        %% EXTRACT FEATURES
        mean_std_row_vector = get_mean_std(matrix_to_extract_mean_std(:,1));
        MEAN_ECG = matrix_copy(MEAN_ECG,... 
                               mean_std_row_vector(:,1),... 
                               targets_matrix_current_index,... 
                               1);   
        STD_ECG = matrix_copy(STD_ECG,... 
                               mean_std_row_vector(:,2),... 
                               targets_matrix_current_index,... 
                               1); 
        % creation of the vector with the 3 diffent classes of activity 
        % activity sit defined by the 1
        if (contains(filename, c.csv_sit_identifier))
            ACTIVITY_CLASSES(targets_matrix_current_index, 1) = 1;
        % activity walk defined by the 2
        elseif (contains(filename, c.csv_walk_identifier))
            ACTIVITY_CLASSES(targets_matrix_current_index, 1) = 2;
        % activity run defined by the 3
        else
            ACTIVITY_CLASSES(targets_matrix_current_index, 1) = 3;
        end
        targets_matrix_current_index = targets_matrix_current_index + 1;
    end
end

%% REMOVE OUTLIERS
[MEAN_ECG, to_remove] = rmoutliers(MEAN_ECG);
FEATURES_MEAN = FEATURES(~to_remove, :);
fprintf("Remove %i outliers from data (mean)\n", sum(to_remove));

[STD_ECG, to_remove] = rmoutliers(STD_ECG);
FEATURES_STD = FEATURES(~to_remove, :);
fprintf("Remove %i outliers from data (std)\n", sum(to_remove));

% transform the activity class vector into one-hot encoding
ACTIVITY_CLASSES_VECTOR = full(ind2vec(ACTIVITY_CLASSES'))';

%% Save results
save('saves/BEFORE_NORMALIZATION',...
    'FEATURES',...
    'FEATURES_MEAN',...
    'FEATURES_STD',...
    'MEAN_ECG',...
    'STD_ECG',...
    'ACTIVITY_CLASSES');

%% Normalize and remove correlated columns
disp("Normalization of the feature matrixes");

% feature matrix used for classification
FEATURES = normalize_matrix(FEATURES);

% feature matrix used for mean
FEATURES_MEAN = normalize_matrix(FEATURES_MEAN);

% feature matrix used for std
FEATURES_STD = normalize_matrix(FEATURES_STD);

%% Save results
save('saves/BEFORE_DATA_AUGMENTATION',...
    'FEATURES',...
    'FEATURES_MEAN',...
    'FEATURES_STD',...
    'MEAN_ECG',...
    'STD_ECG',...
    'ACTIVITY_CLASSES_VECTOR');