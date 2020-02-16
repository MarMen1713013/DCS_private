clear;
close all;
clc

addpath utility_motor/
Ts = 20e-3;
im = ones(2,1);
e = zeros(2,1);
I = zeros(2,1);
save_I = zeros(1,100);
save_e = save_I;
for i = 1:100
    e = delay(2)*e;
    e(1) = im(1) - I(1);
    I = dPI(I,e,.1,.1,Ts);
    save_I(i) = I(1);
    save_e(i) = e(1);
end
plot(save_I);
figure(2);
plot(save_e);