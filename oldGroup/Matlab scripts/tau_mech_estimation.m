% Connnecting the DC motor directly to 12 V, we can estimate the mechanical
% time constant using the fact that \tau_mec is 63% of the time needed to
% reache the final speed

clear
clc
close all

%User Defined Properties
a = arduino('COM5','Due','Libraries','rotaryEncoder')

encoder = rotaryEncoder(a,'D8','D10',11)

time = 0;
data = 0;
count = 0;
rpm = 0;
v_rpm = 0;

figure();
title("Speed response");
xlabel("Time [s]");
ylabel("Angular speed [RPM]")
grid on
hold on

tic
while(1>0)
    count = count + 1;
    time(count) = toc;
    
    rpm = readSpeed(encoder);
    v_rpm(count) = rpm;
    plot(time,v_rpm,'-r');
    
    %Update the graph
    pause(.0000001);
end
