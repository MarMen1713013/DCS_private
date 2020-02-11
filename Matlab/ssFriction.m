clear;
close all;
clc;
addpath '/home/marco/Scrivania/DCS/Matlab/utility_motor'
addpath '/home/marco/Scrivania/DCS/Matlab/datas'
initDCS; % initialize the arduino and the motors
sim_length = 1000; % number of samples of the simulation

r_ratio = 40; % reduction ratio of the motor

pwmV = 5; % pwm imposed voltage
Va = pwm2V(pwmV); % actual armature voltage
Ke = 0.0666; % from previous experiment
Ra = 13.7; % from measurement
B = 0;
go(a,pwmV,main);
pause(1);
%counterClockWise(a,main);
t = [];
for i = 1:sim_length
    w = readSpeed(encoder)/40;
    w = abs(rpm2rad(w));
    Ia = (Va - Ke*w)/Ra;
    B = Ke*Ia/w;
    t = [t;B];
    plot(t);
    pause(0.0001)
end
stopMotor(a,main)
B_mean = sum(t)/length(t)
hold on;
plot([0,sim_length],[B_mean, B_mean]);

save('datas/B.mat','B_mean');