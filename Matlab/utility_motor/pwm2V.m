function out = pwm2V(pwm)
    out = pwm*12/5; % 12 is max commanded, 5 is max according to pwm
end