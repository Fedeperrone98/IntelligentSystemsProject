%% 
clear
close all 
clc

%% Allocate variables
c = constants();

data = cell(c.number_of_measurement / 2, 1);
target = cell(c.number_of_measurement / 2, 1);

% useful indices
next_data = 1;
next_target = 1;

%% SCAN FILES AND EXTRACT DATA

% scan each csv file 
csv_file = dir(fullfile(c.dataset_folder,'*.csv'));

% retrieve the directory of the csv files using the first csv
% all the csv files are in the same directory
directory_path = csv_file(1).folder;

for m = 1 : constants.number_of_measurement
    
    % retrieve the name of the file csv to analyze
    filename = fullfile(csv_file(m).name);
    % print to the console the name of the current file we are analyzing
    disp(filename); 
    
    % creation of the absolute path
    abs_path = fullfile(directory_path, filename);
    
    % import the signals from the csv 
    if (contains(filename, constants.csv_timeseries_identifier))
        csv_timeseries = table2array(readtable(abs_path, 'Range', 'B:L')); 
        data{next_data} = csv_timeseries';
        next_data = next_data + 1;
    else
        csv_timeseries = table2array(readtable(abs_path, 'Range', 'B:B')); 
        target{next_target} = csv_timeseries';
        next_target = next_target + 1;
    end
end

%% Save data
save('saves/CNN_data_target', "target", "data");

%% 
clear
close all 
clc

%% Load data
load("saves\CNN_data_target.mat");

WINDOWS_SIZE = 5000;

%% Compute how many signals (= windows) will be generated
num_files = length(data);
num_windows = 0;

for i = 1 : num_files
    % calcolo quanti samples ci sono per ogni segnale
    len = size(data{i}, 2);
    % calcolo il numero totale di window
    num_windows = num_windows + floor(len / WINDOWS_SIZE);
end

X = cell(num_windows, 1);
T = zeros(num_windows, 1);

%% CREATION OF THE X AND T MATRIX

% counter for the files
current_file = 1;
current_window = 1;

while current_file <= num_files
    
    disp("File number " + current_file +  " of " + num_files);
    
    % Extract data and target and normalize input
    X_temp = normalize_matrix(data{current_file, 1}')';
    T_temp = target{current_file, 1};
    
    % copy of the data of the current file inside X and T, splitted in windows
    start_idx = 1;
    end_idx = WINDOWS_SIZE;

    while end_idx < size(X_temp, 2)
        % Extract window
        X{current_window} = X_temp(:, start_idx : end_idx);
        % Compute standard deviation of current window ECG
        T(current_window) = std(T_temp(1, start_idx : end_idx));
    
        current_window = current_window + 1;
        start_idx = start_idx + WINDOWS_SIZE;
        end_idx = end_idx + WINDOWS_SIZE;
    end

    current_file = current_file + 1;
    
end

%% Remove outliers
[T, to_remove] = rmoutliers(T);
X = X(~to_remove);
fprintf("Remove %i outliers from data\n", sum(to_remove));

%% Save input and target
disp("Save data ...");
save ('saves/CNN_input', "T", "X");