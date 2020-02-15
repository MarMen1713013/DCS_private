%% init
clear;
close all;
clc;
load datas/B.mat
load speedReadings.mat
sim_length = 50;

%% parameters
Ts = 20e-3;
Ki = 1;
K_poi = 0.09;
Kp = K_poi*Ki;

%Bf = B_mean; % B friction
Bf = 0;
J = 3.6e-3;
Ke = 0.729;

%% matrices
D2 = [1,0;1,0]; % delay matrix
BT = [Ts/J,0;0,0];
Bwr = [Bf*Ts/J,0;0,0];
D3 = [2, -1, 0;
      1,  0, 0;
      0,  1, 0];
Bwe = [Kp*Ts/J, (Ki*Ts^2 - Kp*Ts)/J, 0; zeros(2,3)];
BweTl = [Kp, Ki*Ts-Kp, 0];
%% vectors
wht = zeros(2,1);
whr = wht;
whe = zeros(3,1);

T = zeros(2,1);
wr = zeros(2,1);
we = zeros(3,1);

%% savings

save_wh = zeros(1,sim_length);
save_we = zeros(1,sim_length);
save_Tl = zeros(1,sim_length);
%% simulation environment

torque = ones(1,sim_length);
speed = ones(1,sim_length);

%% core
wh = 0;
Tl = 0;
for i = 1:sim_length
    % apply delay
    T = delay(2)*T;
    T(1) = torque(i);
    
    wr = delay(2)*T;
    wr(1) = speedReadings(i);
    
    we = delay(3)*we;
    we(1) = wr(1) - wh;
    save_we(i) = we(1);
    
    Tl = Tl + BweTl*we;
    save_Tl(i) = Tl;
    % computation
    
    wht = D2*wht + BT*T;
    whr = D2*whr + Bwr*wr;
    whe = D3*whe + Bwe*we;
    
    wh = wht(1)+whr(2)+whe(1);
    save_wh(i) = wh;
end

subplot(2,2,1);
plot(save_wh);
title('estimate');

subplot(2,2,2);
plot(save_we);
title('error');

subplot(2,2,[3,4]);
plot(save_Tl);
title('load torque');

function A = delay(n)
    A = [zeros(1,n);eye(n-1),zeros(n-1,1)];
end