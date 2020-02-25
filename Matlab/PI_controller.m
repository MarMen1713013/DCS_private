clear
clc
close all
figure();
% %User Defined Properties
addpath './utility_motor'
initDCS
%% simulation parameters
set_speed = 3000;   % max speed is 5500 rpm with pwm = 255
sim_length = 1000;
sim_time = 60;

%Define Function Variables
e_speed = 0.0;  % error
e_speed_pre = 0.0;
e_speed_sum = 0.0;
pwm_pulse = 0.0;
kp = 0.23;        % with set_speed = 1000, these gains are chosen Kp=0.23 ki = 0.09
ki = 0.17;        % with range [-1500, 1500]
time = zeros(sim_length);
data = 0;
count = 1;
rpm = 0;
v_rpm = 0;

pwm_save = [];
tic
while(time(count) <= sim_time && count < sim_length)
    count = count + 1;
    time(count) = toc;
    
    %rpm = speedGenerator(pwm_pulse*729);
    rpm = abs(readSpeed(encoder));% current angular velocity [rpm]
    v_rpm(count) = rpm;      % velocity vector [reduction ratio 40:1]
    
    % plot angular velocity
    subplot(2,2,1)
    plot(time(1:count),v_rpm,'-r');   % plot angular velocity
    title('Motor Angular Velocity');
    hold on;
    plot([time(1),time(count)],[set_speed,set_speed],'g');
    hold off;
    
    %---------------PI CONTROLLER-------------
    e_speed = set_speed - rpm;  % error computation
    v_e_speed(count) = e_speed;
    
    
    %plot error speed
    subplot(2,2,[2,4])
    plot(time(1:count),v_e_speed,'-r')
    title('Error speed')
    
    
    pwm_pulse = (e_speed * kp  + e_speed_sum * ki );    % control law
    e_speed_pre = e_speed; % save last (previous) error
    e_speed_sum = e_speed_sum+e_speed; % sum of error
    
%     plot of the integral of the error
%     v_e_speed_sum(count) = e_speed_sum;
%     subplot(2,2,4)
%     plot(time,v_e_speed_sum,'-r')
%     
    % control signal remap
    pwm_pulse = map(pwm_pulse, -1500,1500,0,5); 
   

        
    %update new spedd
    Kaw=1; %costant for the antiwindup regulation  
   
        if (pwm_pulse > 5) 
    
    %antiwindup        
    error = pwm_pulse - 5;
    correction = Kaw*error;
    pwm_pulse = pwm_pulse - correction; %end of antiwindup
        
        writePWMVoltage(a,'D11', pwm_pulse); 
        %pwm_save = [pwm_save; pwm_pulse]
    else if (pwm_pulse < 0)  
            writePWMVoltage(a,'D11',0);
                %pwm_save = [pwm_save; pwm_pulse]
        else
            writePWMVoltage(a,'D11',pwm_pulse);
                %pwm_save = [pwm_save; pwm_pulse]
        end
        end
    
    %plot of the control effort
    v_pwm_pulse(count) = pwm_pulse;
    subplot(2,2,3)
    plot(time(1:count), v_pwm_pulse, '-r')
    title('Control effort');
        
    %Update the graph
    pause(.01);
end
writePWMVoltage(a,'D11',0);
figs = {1,3,[2,4]};
ylabels = {'Angular speed [rpm]','Control effort [pwm_V]','Speed error [rpm]'};
for i = 1:3
    subplot(2,2,figs{i});
    xlabel("Time [s]");
    ylabel(ylabels{i});
    grid on
end

% make the control signal compatible with arduino [0V to 3.3V]
function y = map(x,in_min, in_max, out_min, out_max)
y  = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
end


