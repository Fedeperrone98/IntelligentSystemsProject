clear; 
clc; 
close all;

%% Load data
load('saves/FIS_INPUT.mat');
x = INPUT;
t = vec2ind(TARGET);

fis = readfis('fuzzy_inference_system/results/mamdani_fis.fis');

%% Test FIS
test_fis(fis, x, t);