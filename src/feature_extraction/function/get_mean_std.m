% This function takes a timeseries column vector and calculate the mean and
% the standard deviation on the data, returning a row vector with the
% results
%
% INPUTS: 
%   timeseries: column vector containing the data
% OUTPUTS:
%   results: row vector containing the 1)mean and 2)std. dev 

function [results] = get_mean_std(timeseries)
    results = [
        mean(timeseries), ...
        std(timeseries)
    ];
end