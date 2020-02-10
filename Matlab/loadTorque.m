clear;
close all;
clc;
addpath '/home/marco/Scrivania/DCS/Matlab/utility_motor'
addpath '/home/marco/Scrivania/DCS/Matlab/datas'
load 'datas/B.mat'
initDCS; % initialize the arduino and the motors
sim_length = 1000; % number of samples of the simulation

r_ratio = 40; % reduction ratio of the motor

speed_meas = 0; % measurement of the speed