clear; 
clc; 
close all; 

%% Load input

load('saves/CNN_input.mat');

%% Split data+target into training and test partitions

% divido i dati randomicamente:
% - 80% di dati per il training
% - 20% di dati per il testing

rng('default');
c = cvpartition(numel(X), 'Holdout', 0.2);

idxTrain = training(c);
idxTest = test(c);

XTrain = X(idxTrain);
XTest = X(idxTest);
TTrain = T(idxTrain);
TTest = T(idxTest);

clear c X T idxTrain idxTest;

%% Define the layers for the net
% This gives the structure of the convolutional neural net
numFilters = 64;

layers = [
    sequenceInputLayer(11)
    
    convolution1dLayer(9, numFilters, 'Stride', 2, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    averagePooling1dLayer(4, 'Stride', 4, 'Padding', 'same')


    convolution1dLayer(7, 2 * numFilters, 'Stride', 2, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    averagePooling1dLayer(4, 'Stride', 4, 'Padding', 'same')

    convolution1dLayer(5, 3 * numFilters, 'Stride', 2, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    averagePooling1dLayer(4, 'Stride', 4, 'Padding', 'same')   

    convolution1dLayer(3, 3 * numFilters, 'Stride', 2, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    averagePooling1dLayer(4, 'Stride', 4, 'Padding', 'same')
    
    globalAveragePooling1dLayer

    fullyConnectedLayer(100)
    reluLayer 
    
    fullyConnectedLayer(1)
    regressionLayer
];


options = trainingOptions('sgdm', ...
    ...
    MaxEpochs = 30, ...
    MiniBatchSize = 64, ...
    Shuffle = 'every-epoch' , ...
    ...
    Momentum = 0.9, ...
    InitialLearnRate = 0.1, ...
    LearnRateSchedule = 'piecewise', ...
    LearnRateDropPeriod = 10, ...
    LearnRateDropFactor = 0.1, ...
    L2Regularization = 0.01, ...
    GradientThresholdMethod='global-l2norm', ...
    GradientThreshold=0.9, ...
    ...
    ValidationData =  {XTest TTest}, ...
    ValidationFrequency = 30, ...
    ...
    ExecutionEnvironment = 'gpu', ...
    Plots = 'training-progress', ...
    Verbose = 1, ...
    VerboseFrequency = 1 ...
);


%% View network
% deepNetworkDesigner(layers);
analyzeNetwork(layers);

%% Train network
disp('TRAINING');
net = trainNetwork(XTrain, TTrain, layers, options);

%% Test against validation set
% Print performance and Rsquared
disp('TESTING');
YTest = predict(net, XTest, ...
                ExecutionEnvironment='auto', MiniBatchSize = 100);

% Plot regression 
figure; 
plotregression(TTest, YTest);
%% Test against training set
figure;
YTrain = predict(net, XTrain, ...
                 ExecutionEnvironment='auto', MiniBatchSize = 100);
plotregression(TTrain, YTrain);

