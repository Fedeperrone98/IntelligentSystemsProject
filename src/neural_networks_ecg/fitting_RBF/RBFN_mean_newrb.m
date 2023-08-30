%%
clear
close all 
clc

%% Load input and target data
load("saves/BEFORE_TRAINING.mat");
INPUT = INPUT_MEAN;
TARGET = TARGET_MEAN;

%% distance between inputs
dist = pdist(INPUT');
fprintf('Min distance between adjacent input vectors: %f\n', min(dist));
fprintf('Max distance across whole input space: %f\n', max(dist));

%% Newrb

% Set network parameters

% [20, 60] con step 10
max_neurons = 20; 
%max_neurons = 30;
%max_neurons = 40;
%max_neurons = 50;
%max_neurons = 60;

% performance goal
goal = 0;
% number of neurons to add between displays
ki = 10;

% Choose a spread larger than the distance between adjacent input (0.000955),
% but smaller then the distance across the whole input space (1.796102)
% [0.2 , 1.6] con step 0.2
spread = 0.2;
% spread = 0.4;
% spread = 0.6;
% spread = 0.8;
% spread = 1;
% spread = 1.2;
% spread = 1.4;
% spread = 1.6;

% Create Radial Basis Function network
net = newrb(INPUT, TARGET, goal, spread, max_neurons, ki);

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