clear
clc
close all
%% simulation
% %Arduino connections
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
Kt = 0.729;
Ke = 0.729;
Ra= 13.7;
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
        go(a,5,main);
    end
    time(i) = toc;
    rpm=abs(readSpeed(encoder));
    f_rpm(i)= rpm;
    plot(time, f_rpm, '-')
   
end
stopMotor(a,main);

   maxx=0.9*f_rpm(i);
   minn=0.1*f_rpm(i);
   
   tr1=find(abs(f_rpm-maxx)== min(abs(f_rpm-maxx)));
   tr2=find(abs(f_rpm-minn)== min(abs(f_rpm-minn)));
   tr=time(tr1)-time(tr2);
   disp (tr);
   
   tau_mmech= 0.63*tr;
   disp(tau_mmech);
   
   J=(Kt*Ke*tau_mmech)/Ra ;
   disp(J);

