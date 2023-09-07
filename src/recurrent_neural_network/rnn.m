clear; 
clc; 
close all;

%% Load data
load('saves/RNN_ecg');

%% Split dataset into training and test partition
lenTrain = round(size(X, 1) * 0.8);
XTrain = X(1 : lenTrain);
XTest = X(lenTrain + 1 : end);
TTrain = T(1 : lenTrain);
TTest = T(lenTrain + 1 : end);

%% Define LSTM Network Architecture

num_channels = 1; 
num_hidden_neurons = 45;

layers = [
    sequenceInputLayer(num_channels)
    lstmLayer(num_hidden_neurons, 'OutputMode', 'last')
    fullyConnectedLayer(num_channels)
    regressionLayer
];

%% Specify Training Options

options = trainingOptions('rmsprop', ...
    MaxEpochs = 30, ...
    MiniBatchSize = 3000, ...
    Shuffle = 'every-epoch', ...
    ...
    ValidationData = {XTest TTest}, ...
    ValidationFrequency = 50, ...
    OutputNetwork = 'best-validation-loss', ...
    ...
    LearnRateSchedule = 'piecewise', ...
    LearnRateDropFactor = 0.1, ...
    LearnRateDropPeriod = 10, ...
    ...
    SequencePaddingDirection = 'left', ...
    ...
    Plots = 'training-progress', ...
    Verbose = 1, ...
    VerboseFrequency = 5, ...
    ExecutionEnvironment = 'auto' ...             
);

%% Train network
net = trainNetwork(XTrain, TTrain, layers, options);

%% Test network 
net = resetState(net);
YTest = predict(net, XTest, ExecutionEnvironment = 'auto');

figure;
plot(YTest(1:100),'--');
hold on;
plot(TTest(1:100));
hold off;

%% Compute and analyze error
% To evaluate the accuracy, calculate the root mean squared error (RMSE) 
% between the predictions and the target.
rmse = sqrt(mse(YTest, TTest));

% Calculate the mean RMSE over all test observations.
fprintf("RMSE on validation set: %f\n", rmse);