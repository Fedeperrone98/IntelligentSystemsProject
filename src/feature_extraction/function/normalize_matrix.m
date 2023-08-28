% MIN-MAX NORMALIZATION
% This function normalises the values contained within the features matrix
% by making its values in the range [0,1].
%
%   INPUTS:
%       features: features matrix extracted from datasets
%   OUTPUTS:
%       normalized_features: features matrix normalized

function [normalized_features] = normalize_matrix(features)
    min_val = min(features);
    max_val = max(features);
    normalized_features = (features - min_val) ./ (max_val - min_val);
end

