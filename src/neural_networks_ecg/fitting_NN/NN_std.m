%%
clear
close all 
clc

%%
load('saves/BEFORE_TRAINING.mat');

x = INPUT_STD;
t = TARGET_STD;

%% Parameters definition
% Choosing a Training Function
trainFcn = 'trainbr'; % Bayesian regularization
% trainFcn = 'trainlm'; % Levenberg-Marquardt
% trainFcn = 'trainbfg'; % Quasi-Newton BFGS
% trainFcn = 'trainrp'; % Retropropagazione resiliente
% trainFcn = 'trainscg'; % Gradiente coniugato scalato

% Selecting a size for the hidden layer [20, 60]
% hiddenLayerSize = 20;
% hiddenLayerSize = 30;
% hiddenLayerSize = 40;
hiddenLayerSize = 50;
% hiddenLayerSize = 60;


%% Creation of the Neural Network                   
net = fitnet(hiddenLayerSize,trainFcn);

% Choosing Input and Output Pre-Processing Functions
% Removing the constant rows from input and target
net.input.processFcns = {'removeconstantrows','mapminmax'};
net.output.processFcns = {'removeconstantrows','mapminmax'};

%% Data splitting & Net parameters setting
% Setup Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample

% for training algorithms that do not need validation (trainbr)
net.divideParam.trainRatio = 85/100;
net.divideParam.valRatio = 0/100;       
net.divideParam.testRatio = 15/100;

% for training algorithm that need validation
% net.divideParam.trainRatio = 70/100;
% net.divideParam.valRatio = 15/100;       
% net.divideParam.testRatio = 15/100;

% Choose a Performance Function
net.performFcn = 'mse';  % Mean Squared Error

% Choose Plot Functions
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotregression', 'plotfit'};

%% Training & Testing the Network
[net,tr] = train(net,x,t);

y = net(x);

% View the Network
%view(net)

% Plotting
% figure, plotregression(t,y)