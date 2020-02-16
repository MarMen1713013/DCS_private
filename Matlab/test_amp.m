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
for i=5:5
    go(a,5*(i-1)/4,main);
    disp(['pwm_voltage: ',num2str(5*(i-1)/4),'V']);
    for j = 1:200
        im(2) = im(1);
        im(1) = readVoltage(a,probe)-0.0771; % that number is the estimated offset voltage
        
        I = dLowPass(I,Av*im,tau,Ts);
        next = j + 200*(i-1);
        in(next) = I(1); % randn(1)*10 + 3;
        unfiltered(next) = im(1)*50;
        t(next) = toc;
        subplot(1,2,1);
        plot(in(1:next));%plot(t(1:next),in(1:next));
        subplot(1,2,2);
        plot(unfiltered(1:next));
        pause(Ts);
    end
end
stopMotor(a,main)
subplot(1,2,1);
title('Current in the motor: filtered');
xlabel('time [s]');
ylabel('current [A]');
grid on
subplot(1,2,2);
title('Current in the motor: unfiltered');
xlabel('time [s]');
ylabel('current [A]');
grid on
