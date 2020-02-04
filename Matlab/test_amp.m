clear all
close all
clc
a = arduino;

configurePin(a,'A0','AnalogInput'); % input pin
in = [];

while(1)
    in = [in; readVoltage(a,'A0')];    
   plot(in);
   
end