%% initialization
clear;
close all;
clc;
addpath utility_motor/
addpath datas/
load datas/B.mat
load speedReadings.mat
initDCS;

sim_length = 500; %samples
sim_time = 60; %seconds

pwm_V = 3;
Va = pwm2V(pwm_V);
%% constants
Ts = 20e-3;
tau = 0.1; %low pass
Bf = B_mean;
J = 3.6e-3;
Ke = 0.729;
Ra = 1.12;
Kp = 0.7;
Ki = 0.2;
%% vectors
th_m = zeros(2,1);
th = zeros(2,1);
e = zeros(2,1);
Tl_minus = zeros(2,1);
T = zeros(2,1);
a_hat = zeros(2,1);
w_hat = zeros(2,1);
th_hat = zeros(2,1);
%% savings
save_e = zeros(1,sim_length);
save_T = zeros(1,sim_length);
save_w_hat = zeros(1,sim_length);
save_Tl = zeros(1,sim_length);
%% core
t = zeros(1,sim_length);
i = 1;
go(a,pwm_V,main);
tic;
while(t(i) <= sim_time && i < sim_length)
    i = i+1;
    % code here
    
    % speed measurement
    th_m = delay(2)*th_m;
    th_m(1) = abs(readCount(encoder));
    % speed low pass
    th = dLowPass(th,th_m,tau,Ts);
    % compute error
    e = delay(2)*e;
    e(1) = th(1) - th_hat(1);
    %compute -Tl
    Tl_minus = dPI(Tl_minus,e,Kp,Ki,Ts);
    %compute T
    T = delay(2)*T;
    T(1) = Ke*((Va - Ke*w_hat(1))/Ra);
    % compute a_hat
    a_hat = delay(2)*a_hat;
    a_hat(1) = (Tl_minus(1) + T(1) -Bf*w_hat(1))/J;
    % compute w_hat
    w_hat = dIntegrate(w_hat,a_hat,Ts);
    %compute th_hat
    th_hat = dIntegrate(th_hat,w_hat,Ts);
    % time update
    t(i) = toc;
    % savings
    save_e(i) = e(1);
    save_T(i) = T(1);
    save_w_hat(i) = w_hat(1);
    save_Tl(i) = -Tl_minus(1);
    % plots here
    subplot(2,2,1);
    plot(t(1:i),save_e(1:i));
    title('e');
    
    subplot(2,2,2);
    plot(t(1:i),save_T(1:i));
    title('T');
    
    subplot(2,2,3);
    plot(t(1:i),save_w_hat(1:i));
    title('w_hat');
    
    subplot(2,2,4);
    plot(t(1:i),save_Tl(1:i));
    title('Tl');
    
    pause(0.02);
end
stopMotor(a,main);