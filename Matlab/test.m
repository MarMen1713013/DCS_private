clear;
close all;
clc
Ts = 0.01;
i = ones(1,1000);
I = zeros(2,1);
saveI = zeros(1,1000);

for j = 1:1000
    e = i(j) - I(1); % unitary feedback on integrator
    I(2) = I(1);
    I(1) = Ts*e + I(1);
    saveI(j) = I(1);
end
plot(saveI);