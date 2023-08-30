%%
clear
close all 
clc

%% Load input and target data
load("saves/BEFORE_TRAINING.mat");
INPUT = INPUT_STD;
TARGET = TARGET_STD;

%% distance between inputs
dist = pdist(INPUT');
fprintf('Min distance between adjacent input vectors: %f\n', min(dist));
fprintf('Max distance across whole input space: %f\n', max(dist));

%% Newrbe 

% Choose a spread larger than the distance between adjacent input (0.001019),
% but smaller then the distance across the whole input space (1.860051)
spread = 0.5;

% Create Radial Basis Function network
net = newrbe(INPUT, TARGET, spread);

% View the Network
view(net)

% simulate a network over complete input range
Y = net(INPUT);

% plot network response
perf = perform(net, TARGET, Y);
fprintf('Error after newrbe: %f (%e)\n', ...
        perf, perf);

regression_model = fitlm(TARGET, Y);
fprintf('Rsquared after newrb: %f\n', ...
        regression_model.Rsquared.Ordinary);

figure; plotregression(TARGET, Y)
   