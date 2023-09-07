clear; 
clc; 
close all;

%% Scan files and extract timeseries

% CSV regex
csv_file = dir(fullfile(constants.dataset_folder,'*targets.csv'));

% Retrieve the directory of the csv files using the first csv
% (all the csv files are in the same directory)
directory_path = csv_file(1).folder;

ecg = cell(length(csv_file), 1);

% Scan every csv file to extract the ECG signals
for m = 1 : length(csv_file)
    % Retrieve the name of the file csv to analyze
    filename = fullfile(csv_file(m).name);
    disp(filename); 
    
    abs_path = fullfile(directory_path, filename);
    
    csv_targets = table2array(readtable(abs_path, 'Range', 'B:B')); 
    ecg{m} = csv_targets';
end

%% Normalization
for i=1 : numel(ecg)
    ecg{i} = normalize_matrix(ecg{i});
end
%% Generate windows with input-target couples
WINDOW_SIZE = 40;
ECG_ID = 1;
person_ecg = ecg{ECG_ID};
X = cell(length(person_ecg) - WINDOW_SIZE, 1);
T = zeros(length(person_ecg) - WINDOW_SIZE, 1);

start_idx = 1;
end_idx = WINDOW_SIZE;
while end_idx < length(person_ecg)
    X{start_idx} = person_ecg(start_idx : end_idx);
    T(start_idx) = person_ecg(end_idx + 1);

    start_idx = start_idx + 1;
    end_idx = end_idx + 1;
end

%% Save results
save('saves/RNN_ecg', "ecg", "person_ecg", "X", "T");