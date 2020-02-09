clear
clc
close all

%Arduino connections
a = arduino('COM1','Uno','Libraries','rotaryEncoder')

encoder = rotaryEncoder(a,'D2','D3',180)

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
for count= 1:50
    time(count) = toc;
    rpm=readSpeed(encoder);
    f_rpm (count)= rpm;
    plot(time, f_rpm, '-')
    
   
end
tau_mmech(count)= 0.63* f_rpm;
   sr_tau= sumsqr(tau_mmech);
   disp(sr_tau);
   lsa= sqrt((sr_tau)/count) ;
   disp(lsa);



