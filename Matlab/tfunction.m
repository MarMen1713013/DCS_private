clear all;
close all;
syms s z Kp Ki J B T
load datas/B.mat
Kp_n = 0.09;
Ki_n = 1; 
J_n = 3.6e-3;
B_n = B_mean;
T_n = 20e-3;
WrWe = (Ki/s/B)*((1+s*Kp/Ki)/(1+s*J/B));
WrT = 1/B*(1/(1+s*J/B));
WrWe_zoh = collect(expand(subs(WrWe,s,(z-1)*T)),z)
WrT_zoh = collect(expand(subs(WrT,s,(z-1)*T)),z)

WrWe_zoh_n = subs(WrWe_zoh,{Kp,Ki,J,B,T},{Kp_n,Ki_n,J_n,B_n,T_n})