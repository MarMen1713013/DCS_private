clear all;
close all;
s = tf('s');
load datas/B.mat
Kp = 0.09;
Ki = 1; 
J = 3.6e-3;
B = B_mean;
Ts = 20e-3;

WrWe = (s*Kp+Ki)/(s^2*J);
WrBWr = B/(s*J);
WrT = 1/s/J;