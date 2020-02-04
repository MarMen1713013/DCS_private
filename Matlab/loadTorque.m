clear;
close all;
clc;

%initDCS;
speed_hat = 0;
speed_error = 0;
speed_error_sum = 0;
T = 5; %from voltage
J = 1; %from previous examples
e = [];
s = [];
i = 0;
%%
for i = 1:50
read_speed = 10;%readSpeed(encoder);
speed_error = read_speed - speed_hat;
speed_error_sum = speed_error_sum + speed_error;
Tl_minus = 0.5*speed_error + 0.5*speed_error_sum;
e = [e;Tl_minus];
speed_hat = speed_hat + (Tl_minus-T)/J;
s = [s; speed_hat];
figure(1)
plot(e);
pause(0.01)
figure(2)
plot(s)
pause(0.01)
end

