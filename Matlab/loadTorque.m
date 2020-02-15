%% initialization
clear;
close all;
clc;
addpath utility_motor/
addpath datas/
load datas/B.mat
load speedReadings.mat
initDCS;

sim_length = 500;
%% utility for low pass
tau = 0.1;
Av = 50;
%% parameters
Ts = 20e-3;
Ki = 1;
K_poi = 0.09;
Kp = K_poi*Ki;

Bf = B_mean; % B friction
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
whr = zeros(2,1);
whe = zeros(3,1);

T = zeros(2,1);
wr = zeros(2,1);
we = zeros(3,1);

%% vectors for Torque estimate
im = zeros(2,1);
I = zeros(2,1);

%% savings

save_wh = zeros(1,sim_length);
save_we = zeros(1,sim_length);
save_T = zeros(1,sim_length);
save_I = zeros(1,sim_length);
save_Tl = zeros(1,sim_length);
%% core
t = zeros(1,sim_length);
i = 1;
pwm_V = 3.3;
go(a,pwm_V,main);
tic
wh = 0;
Tl = 0;
while(t(i) <= 60 && i < sim_length)
    % apply delay
    im = delay(2)*im;
    im(1) = readVoltage(a,probe);
    
    I = delay(2)*I;
    I(1) = (1-Ts/tau)*I(1) + Av*im(1);
    save_I(i) = I(1);
    
    T = delay(2)*T;
    %T(1) = torque(i);
    T(1) = Ke*I(1);
    save_T(i) = T(1);
    
    wr = delay(2)*T;
    %wr(1) = speed(i)*15.7;
    wr(1) = rpm2rad(abs((readSpeed(encoder)/40)));
    
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
    
    subplot(2,2,1);
    plot(t(1:i),save_wh(1:i));
    title('wh');
    
    subplot(2,2,3);
    plot(t(1:i),save_we(1:i));
    title('we');
    
    subplot(2,2,2);
    plot(t(1:i),save_T(1:i));
    title('T');
    
    subplot(2,2,4);
    plot(t(1:i),save_I(1:i));
    title('Tl');
    
    t(i) = toc;
    i = i+1;
    
    pause(0.01)
end
stopMotor(a,main);

function D = delay(n)
    D = [zeros(1,n);eye(n-1),zeros(n-1,1)];
end