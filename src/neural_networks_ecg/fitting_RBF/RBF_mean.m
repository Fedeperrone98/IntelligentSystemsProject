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

%% Radial Basis Function (newrb)

% Set network parameters
error_goal = 0;
max_neurons = 30;

% Choose a spread larger than the distance between adjacent input (0.000955),
% but smaller then the distance across the whole input space (1.796102)
spread = 0.45;


% Create Radial Basis Function network
net = newrb(INPUT, TARGET, error_goal, spread, max_neurons, 10);

% Print performance and Rsquared
Y = net(INPUT);
perf = perform(net, TARGET, Y);
fprintf('Error after newrb: %f (%e)\n', ...
        perf, perf);
regression_model = fitlm(TARGET, Y);
fprintf('Rsquared after newrb: %f\n', ...
        regression_model.Rsquared.Ordinary);
figure; plotregression(TARGET, Y)
   
%% Bayesian regularization (trainbr)

% Retrain RBF by performing Levenberg-Marquardt training with Bayesian
% regularization, to improve performance
net.trainFcn = 'trainbr';
net.trainParam.epochs = 100;

net.trainParam.show = 20;
net.trainParam.showCommandLine = 1;
net.trainParam.showWindow = 0;

[net, tr_after_reg] = train(net, INPUT, TARGET, ...
                            'useParallel','yes');

% Print performance and Rsquared
fprintf('Error after training with TRAINBR: %f (%e)\n', ...
        tr_after_reg.best_perf, tr_after_reg.best_perf);
Y = net(INPUT);
regression_model = fitlm(TARGET, Y);
fprintf('Rsquared after training with TRAINBR: %f\n', ...
        regression_model.Rsquared.Ordinary);
 
% Plot performance and regression 
figure; plotperform(tr_after_reg);
figure; plotregression(TARGET, Y);
