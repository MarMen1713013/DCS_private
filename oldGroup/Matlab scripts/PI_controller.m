clear
clc
close all

%User Defined Properties
a = arduino('COM5','Due','Libraries','rotaryEncoder')

configurePin(a,'D2', 'DigitalOutput')   % ENA
configurePin(a,'D3', 'DigitalOutput')   % IN1
configurePin(a,'D4', 'DigitalOutput')   % IN2
configurePin(a,'D7', 'DigitalOutput')   % ENB
writeDigitalPin(a,'D2', 0);  % choose sense of rotation motor A
writeDigitalPin(a,'D3', 0);  % choose sense of rotation motor A
writeDigitalPin(a,'D4', 1);  % choose sense of rotation motor B
writeDigitalPin(a,'D7', 0);  % choose sense of rotation motor B

encoder = rotaryEncoder(a,'D8','D10',11)

%Define Function Variables
e_speed = 0.0;  % error
e_speed_pre = 0.0;
e_speed_sum = 0.0;
pwm_pulse = 0.0;
kp = 0.23;        % with set_speed = 1000, these gains are chosen Kp=0.23 ki = 0.09
ki = 0.17;        % with range [-1500, 1500]
set_speed = 3000;   % max speed is 5500 rpm with pwm = 255
time = 0;
data = 0;
count = 0;
rpm = 0;
v_rpm = 0;

figure();
title("PI controller, set-point = 3000");
xlabel("Time [s]");
ylabel("Angular speed [RPM]")
grid on
hold on

tic
while(1>0)
    count = count + 1;
    time(count) = toc;
    
    rpm = readSpeed(encoder);% current angular velocity [rpm]
    v_rpm(count) = rpm;      % velocity vector [reduction ratio 40:1]
    plot(time,v_rpm,'-r');   % plot angular velocity
    
    %PI
    e_speed = set_speed - rpm;  % error computation
    pwm_pulse = (e_speed * kp  + e_speed_sum * ki );    % control law
    e_speed_pre = e_speed; % save last (previous) error
    e_speed_sum = e_speed_sum+e_speed; % sum of error
    pwm_pulse = map(pwm_pulse, -1500,1500,0,3.3); % control signal remap
    %update new speed
    if (pwm_pulse > 3.3) writePWMVoltage(a,'D2',3.3);
    else if (pwm_pulse < 0) writePWMVoltage(a,'D2',0);
        else writePWMVoltage(a,'D2',pwm_pulse);
        end
    end
    
    %Update the graph
    pause(.01);
end

% make the control signal compatible with arduino [0V to 3.3V]
function y = map(x,in_min, in_max, out_min, out_max)
y  = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
end


