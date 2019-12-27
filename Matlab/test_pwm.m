% This is a script made only to test the arduino to motor connection and to test
% the PWM. This should be from 0V to 5V.

clear all
clc
close all

%% Definitions
a = arduino;

configurePin(a,'D11', 'DigitalOutput')   % ENA PWM Set motor speed
configurePin(a,'D12', 'DigitalOutput')   % IN1  1------0
configurePin(a,'D13', 'DigitalOutput')   % IN2  0------1



writeDigitalPin(a,'D12',0);
writeDigitalPin(a,'D13',1);
%writePWMDutyCycle(a,'D11',0.5); %0.5 is the value of Duty Cylcle

%% Profile
% From here on we are assigning a sinusoidal profile to the velocity the motor 
% has to reproduce.
%
% Frequency, pulsation and all other numbers have been set on the go just for an easy visualization
% No "deep meaning" in them.

f = 0.1; % Hertz
w = 2*pi*f; %rad/s

i=0;
y = [];
while(1)
   i=i+1;
   writePWMVoltage(a,'D11',2.5*sin(w*i/50)+2.5); 
   y = [y;2.5*sin(w*i/50)+2.5];
   plot(y)
   hold on
   pause(0.000001)
end


