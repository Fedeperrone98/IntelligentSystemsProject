function [FEATURES_without_correlated_columns] = remove_correlated_features(FEATURES)
    correlation_coef = corrcoef(FEATURES); % extract correlation coefficent fot each column
    [correlated_features, ~] = find( tril( (abs(correlation_coef) > 0.9), -1 ) ); % find column with a correlation above 0.9
    correlated_features = unique(sort(correlated_features));
    
    FEATURES_without_correlated_columns = FEATURES;
    FEATURES_without_correlated_columns(:, correlated_features) = []; % remove correlated column