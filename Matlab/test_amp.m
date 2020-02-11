clear
close all
clc
addpath './utility_motor/'
initDCS;
counterClockWise(a,main);
in = zeros(1,1500);
t = in;
tic

for i=1:5
    go(a,5*(i-1)/4,main);
    disp(['pwm_voltage: ',num2str(5*(i-1)/4),'V']);
    for j = 1:300
        next = j + 300*(i-1);
        in(next) = readVoltage(a,probe); % randn(1)*10 + 3;
        t(next) = toc;
        plot(t(1:next),in(1:next));
        pause(0.01);
    end
end
stopMotor(a,main)
title('Current in the motor: to be adjusted');
xlabel('time [s]');
ylabel('current [A]');
grid on
