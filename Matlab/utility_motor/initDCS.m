disp('Initialization...')
if(ispc)
    a = arduino('COM5','Uno','Libraries','rotaryEncoder'); % define the Arduino Communication port
elseif(isunix)
    a = arduino('/dev/ttyACM0','Uno','Libraries','rotaryEncoder');     % for Linux
else
    disp("Operating system not supported");
    return;
end
disp(' Arduino set up: done');
%% Motor one
% This is used to set up the main motor

configurePin(a,'D11', 'DigitalOutput');   % ENA PWM Set motor speed
configurePin(a,'D12', 'DigitalOutput');   % IN1  1------0
configurePin(a,'D13', 'DigitalOutput');   % IN2  0------1
clockWise(a,'main');
encoder = rotaryEncoder(a,'D2','D3',11);    % create encoder object 4x
T_sample = 20e-3;
disp(' Main motor pins: done')
%% Motor two
% This is used to set up the load motor

configurePin(a,'D5', 'DigitalOutput');   % ENA PWM Set motor speed
configurePin(a,'D6', 'DigitalOutput');   % IN1  1------0
configurePin(a,'D7', 'DigitalOutput');   % IN2  0------1
counterClockWise(a,'load');
main = 'main';
load = 'load';
disp(' Load motor pins: done')
%% readings
probe = 'A0';
potentiometer = 'A5';
configurePin(a,probe,'AnalogInput'); % current probe
configurePin(a,potentiometer,'AnalogInput'); % potentiometer

disp(' Current probe pins: done')
disp(' Potentiometer pins: done')
disp('End of initialization')