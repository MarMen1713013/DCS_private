%% Definitions
clc
clear all

a = arduino;
configurePin(a,'A0', 'AnalogInput') ;  % Read pin for potenziometer
configurePin(a,'A1', 'AnalogInput') ;  %current prob/transducer (sonda)
configurePin(a,'D11', 'DigitalOutput')   % ENA PWM Set motor speed
configurePin(a,'D12', 'DigitalOutput')   % IN1  1------0
configurePin(a,'D13', 'DigitalOutput')   % IN2  0------1

writeDigitalPin(a,'D12',0);
writeDigitalPin(a,'D13',1);

Y=[]
Z=[]
while(1)
    
   pot = readVoltage(a,'A0');  % read analog voltage from potentiometer
   writePWMVoltage(a,'D11',pot); 
   Y=[Y;pot];
   prob = readVoltage(a,'A1');
   Z=[Z;prob];
   figure(1)
   plot(Y)
   figure(2)
   plot(Z)
end