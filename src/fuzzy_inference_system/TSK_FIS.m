clear;
clc;
close all;

%% Load data
load('saves/FIS_INPUT.mat');
x = INPUT';
y = vec2ind(TARGET)';

%% GRID PARTITION
disp("Grid partition");
% Generate FIS 
genfis_options = genfisOptions('GridPartition', ...
                               NumMembershipFunctions = 4);

fis_in = genfis(x, y, genfis_options);

% Tune FIS
[in, out, ~] = getTunableSettings(fis_in);
tunefis_options = tunefisOptions('Method','anfis');
tunefis_options.MethodOptions.EpochNumber = 50;
fis_out = tunefis(fis_in, [in; out], x, y, tunefis_options);

% Test FIS
test_fis(fis_out, x', y');

writeFIS(fis_out, 'fuzzy_inference_system/results/grid_partitioning_fis.fis');

%% SUBTRACTIVE CLUSTERING
disp("Subtractive clustering");
% Generate FIS 
genfis_options = genfisOptions('SubtractiveClustering');

fis_in = genfis(x, y, genfis_options);

% Tune FIS
[in, out, ~] = getTunableSettings(fis_in);
tunefis_options = tunefisOptions("Method","anfis");
tunefis_options.MethodOptions.EpochNumber = 50;
fis_out = tunefis(fis_in, [in; out], x, y, tunefis_options);

% Test FIS
test_fis(fis_out, x', y');

writeFIS(fis_out, 'fuzzy_inference_system/results/subtractive_clustering_fis.fis');

%% FCM CLUSTERING
disp("FCM clustering");
% Generate FIS 
genfis_options = genfisOptions('FCMClustering');

fis_in = genfis(x, y, genfis_options);

% Tune FIS
[in, out, ~] = getTunableSettings(fis_in);
tunefis_options = tunefisOptions("Method","anfis");
tunefis_options.MethodOptions.EpochNumber = 50;
fis_out = tunefis(fis_in, [in; out], x, y, tunefis_options);

% Test FIS
test_fis(fis_out, x', y');

writeFIS(fis_out, 'fuzzy_inference_system/results/FCM_clustering_fis.fis');