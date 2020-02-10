clear all
clc
close all

%% Definitions
a = arduino;
configurePin(a,'A5', 'AnalogInput') ;  % Read pin for potenziometer
configurePin(a,'D11', 'DigitalOutput')   % ENA PWM Set motor speed
configurePin(a,'D12', 'DigitalOutput')   % IN1  1------0
configurePin(a,'D13', 'DigitalOutput')   % IN2  0------1

writeDigitalPin(a,'D12',0);
writeDigitalPin(a,'D13',1);

Y=[]
while(1)
    
   pot = readVoltage(a,'A5');  % read analog voltage from potentiometer
   writePWMVoltage(a,'D11',pot); 
   Y=[Y;pot];
   plot(Y)
   
end




