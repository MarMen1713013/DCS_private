clear;
close all;
clc;
addpath '/home/marco/Scrivania/DCS/Matlab/utility_motor'
initDCS; % initialize the arduino and the motors

E = 3.3;
go(a,E,main); % set speed for the main motor

Ke = 0.729; % constant to compute rated speed
speed_hat = E/Ke;
speed_error = 0;
speed_error_sum = 0;
T = w2T(speed_hat); %from motor equation
J = 2e-3; %from previous examples
t = [];
s = [];
%%
while(1) %for i = 1:50
read_speed = readSpeed(encoder);
speed_error = read_speed - speed_hat;
speed_error_sum = speed_error_sum + speed_error;

Tl_minus = 0.0008*(speed_error + speed_error_sum);
t = [t;-Tl_minus];

speed_hat = speed_hat + (Tl_minus-T)/J;

s = [s; speed_hat];

figure(1)
plot(t);
pause(0.01)
figure(2)
plot(s)
pause(0.01)
end

% figure(1)
% plot(t);
% figure(2)
% plot(s)

figure(1);
title("Load Torque");
xlabel("sampling interval");
ylabel("Torque [N*m]");

figure(2);
title("Observed Speed");
xlabel("sampling interval");
ylabel("Speed [rad/s]");
pause;
go(a,0,main)

