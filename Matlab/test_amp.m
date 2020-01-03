clear all
close all
clc
a = arduino;

configurePin(a,'A0','AnalogInput'); % input pin
configurePin(a,'A5','AnalogInput'); % output pin

in = [];
out = [];

while(1)
    in = [in; readVoltage(a,'A0')];
    out = [out; readVoltage(a,'A5')];
    
   figure(1);
   plot(in);
   figure(2);
   plot(out);
   
end