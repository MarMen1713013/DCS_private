clear;
close all;
clc;
addpath utility_motor/
load datas/B.mat
initDCS;
sim_length = 500;
sim_time = 60;
pwm_V = 5;
%% time constants
Ts = 20e-3;
tau = 0.1; % current low pass
tau1 = 1e-3; % for dirty derivative

%% other constants
Av = 50;
Bf = B_mean;
J = 3.6e-3;
am = J+Bf*tau1;
b = Bf;
c = tau1;

ap = b*Ts + 2*am;
bp = b*Ts - 2*am;
cp = Ts + 2*c;
dp = Ts - 2*c;

Ke = 0.729;
Ra = 1.12;
%% matrices
A = [-dp/cp,0;1,0];
Bwr = [-ap/cp,-bp/cp;0,0];
BI = [Ke,0;0,0];
%% vectors
Tl = zeros(2,1);
I = zeros(2,1);
im = zeros(2,1);
wr = zeros(2,1);

%% savings
save_Tl = zeros(1,sim_length);
save_I = zeros(1,sim_length);
save_im = zeros(1,sim_length);
save_wr = zeros(1,sim_length);
%% core
t = zeros(1,sim_length);
i = 1;
Va = pwm2V(pwm_V);
go(a,pwm_V,main);
tic;
while(t(i) <= sim_time && i < sim_length)
    i = i+1;
    
    % wr -> delay and update
    wr = delay(2)*wr;
    wr(1) = abs(rpm2rad(readSpeed(encoder)/40));
    
    % im -> delay and update
    im = delay(2)*im;
    %im(1) = Av*(readVoltage(a,probe) - 0.0771); % that number is the estimated offset voltage
    im(1) = (Va - Ke*wr(1))/Ra;
    
    % I -> low pass
    I = dLowPass(I,im,tau,Ts);
    
    % Tl -> delay and update
    Tl = A*Tl + Bwr*wr + BI*I;
    
    % save variables
    save_Tl(i) = Tl(1);
    save_I(i) = I(1);
    save_im(i) = im(1);
    save_wr(i) = wr(1);
    
    % update time vector
    t(i) = toc;
    % plots
    subplot(2,2,1);
    plot(t(1:i),save_Tl(1:i));
    title('Tl');
    
    subplot(2,2,2);
    plot(t(1:i),save_I(1:i));
    title('I');
    
    subplot(2,2,4);
    plot(t(1:i),save_im(1:i));
    title('im');
    
    subplot(2,2,3);
    plot(t(1:i),save_wr(1:i));
    title('wr');
    pause(0.02);
end

stopMotor(a,main);
%%
pause(5);
ytitles = {'Torque [N*m]','Filtered current [A]','measured speed [s]','Measured current [A]'};
for i = 1:4
    subplot(2,2,i);
    grid on;
    xlabel('time [s]');
    ylabel(ytitles{i});
end
