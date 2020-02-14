%% initialization
clear;
close all;
clc;
addpath utility_motor/
addpath datas/
load datas/B.mat
load speedReadings.mat
%initDCS;
%% utility
sim_length = 500;

Ts = 20e-3;
Ki = 1;
K_poi = 0.09;
Kp = K_poi*Ki;

%% motor param
B = B_mean;
J = 3.6e-3;
%% quantities
wr = zeros(3,1);
we = zeros(3,1);
save_wr = zeros(1,sim_length);
save_we = save_wr;
%% constants
n1 = Kp*Ts;
n2 = Ki-Kp*Ts;
d0 = J*Ts^2;
d1 = B*Ts-2*J*Ts^2;
d2 = J*Ts^2-B*Ts;
%% core
t = zeros(1,sim_length);
i = 1;
tic
while(t(i) <= 60 && i < sim_length)
    %time delay
    wr(3) = wr(2);
    wr(2) = wr(1);
    
    we(3) = we(2);
    we(2) = we(1);
    
    wm = speedReadings(i);
    %wm = rpm2rad(abs(readSpeed(encoder)/40));
    we(1) = wm - wr(1); % measure it
    wr(1) = n1/d0*we(2) + n2/d0*we(3) - d1/d0*wr(2) - d2/d0*wr(3);
    save_wr(i) = wr(1);
    save_we(i) = we(1);
%     plot(t(1:i),save_wr(1:i));
%     pause(0.01)
    t(i) = toc;
    i = i+1;
end

plot(t,save_wr)
figure()
plot(t,save_we)