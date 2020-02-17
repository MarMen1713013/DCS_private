clear
clc
close all

% Arduino connections
% a = arduino('COM5','Uno','Libraries','rotaryEncoder')
% 
% encoder = rotaryEncoder(a,'D2','D3',180)

% %User Defined Properties
addpath './utility_motor'
initDCS

%Define Function Variables
time = 0;
data = 0;
i= 0;
rpm = 0;
f_rpm = 0;
Kt = 0.729;%N.m/A
Ke = 0.729; %V.s/rad
Ra= 1.12; %ohms
tr1=0;
tr2=0;
tr=0;
maxx=0;
minn=0;
J=0;


figure();
title("Speed response");
xlabel("Time [s]");
ylabel("Angular speed [RPM]")
grid on

tic
for i= 1:50
    if(i==2)
        go(a,5,main); %start motor after the count is 2
    end
    time(i) = toc;
    rpm=abs(readSpeed(encoder));
    f_rpm(i)= rpm;
    plot(time, f_rpm, '-') 
   
end
stopMotor(a,main);

%calculating upper and lower limit for every iteration
   maxx=0.9*f_rpm(i); 
   minn=0.1*f_rpm(i);
   
%calculating the least and maximum value from the whole observation
   tr1=find(abs(f_rpm-maxx)== min(abs(f_rpm-maxx)));
   tr2=find(abs(f_rpm-minn)== min(abs(f_rpm-minn)));
   
%calculating the rise time for the whole experiment
   tr=time(tr1(1))-time(tr2(end));
   disp(['Rise Time: ',num2str(tr)]);
   
 %deriving the time constant of motor
   tau_mmech= 0.63*tr;   %seconds
   disp(['Time Constant: ',num2str(tau_mmech)]);
   
 %calculating the value of inertia of the motor
   J=(Kt*Ke*tau_mmech)/Ra ;    %kg.m^2
   disp(['Inertia: ',num2str(J)]);

