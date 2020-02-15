clear
close all
clc
addpath './utility_motor/'
initDCS;
counterClockWise(a,main);
in = zeros(1,1000);
t = in;
unfiltered = in;
tic
I = zeros(2,1);
im = I;
tau = 100e-3;
Ts = 20e-3;
Av = 50;
A = [(tau-Ts)/tau,0;1,0];
B = [Av*Ts/tau,0;0,0];
for i=1:5
    go(a,5*(i-1)/4,main);
    disp(['pwm_voltage: ',num2str(5*(i-1)/4),'V']);
    for j = 1:200
        im(2) = im(1);
        im(1) = readVoltage(a,probe)-0.0771; % that number is the estimated offset voltage
        
        I = A*I + B*im;
        next = j + 200*(i-1);
        in(next) = I(1); % randn(1)*10 + 3;
        unfiltered(next) = im(1);
        t(next) = toc;
        plot(in(1:next));%plot(t(1:next),in(1:next));
        pause(Ts);
    end
end
stopMotor(a,main)
title('Current in the motor: to be adjusted');
xlabel('time [s]');
ylabel('current [A]');
grid on
