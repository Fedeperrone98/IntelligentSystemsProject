% Given a matrix where each column is a different physiological signal
% represented as a timeserie, extract a set of features for each signal and
% return all of them as a row array. 
% The features are extracted from overlapping sliding windows.
% 
% INPUTS:
%   input_matrix: matrix containing the physiological signals
%   number_of_windows: number of windows into witch to split each signal 
% 
% OUTPUTS:
%   extracted_features: a row array with all the extracted features

function [extracted_features] = produce_feature_vector (input_matrix, number_of_windows)

% Retrieve configuration parameters
NUMBER_OF_FEATURES_PER_WINDOW = constants.number_of_features;
[signal_length, number_of_signals] = size(input_matrix);

% Compute window size and step
num_contiguos_windows = ceil(number_of_windows / 2);
number_of_windows = num_contiguos_windows * 2 - 1; % the number of windows must be odd!!
window_size = floor(signal_length / num_contiguos_windows);
window_step = floor(window_size / 2);


% Preallocate feature matrix
extracted_features = zeros(NUMBER_OF_FEATURES_PER_WINDOW, number_of_signals * number_of_windows);

% Compute features
for signal_index = 1 : number_of_signals
    for window_index = 1 : number_of_windows
        start_timeseries_index = ((window_index - 1) * window_step) + 1;
        end_timeseries_index = start_timeseries_index + window_size - 1;
        
        extracted_features(:, (signal_index - 1) * number_of_windows + window_index) = ...
            extract_features(...
                input_matrix(start_timeseries_index : end_timeseries_index,  signal_index)...
            );
    end
end

extracted_features = extracted_features(:)';

end