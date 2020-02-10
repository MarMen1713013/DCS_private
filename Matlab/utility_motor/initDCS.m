disp('Initialization...')
if(ispc)
    a = arduino('COM5','Uno','Libraries','rotaryEncoder'); % define the Arduino Communication port
elseif(isunix)
    a = arduino('/dev/ttyACM0','Uno','Libraries','rotaryEncoder');     % for Linux
else
    disp("Operating system not supported");
    return;
end

%% Motor one
% This is used to set up the main motor

configurePin(a,'D11', 'DigitalOutput');   % ENA PWM Set motor speed
configurePin(a,'D12', 'DigitalOutput');   % IN1  1------0
configurePin(a,'D13', 'DigitalOutput');   % IN2  0------1
clockWise(a,'main');
encoder = rotaryEncoder(a,'D2','D3',11);    % create encoder object 4x

%% Motor two
% This is used to set up the load motor

configurePin(a,'D5', 'DigitalOutput');   % ENA PWM Set motor speed
configurePin(a,'D6', 'DigitalOutput');   % IN1  1------0
configurePin(a,'D7', 'DigitalOutput');   % IN2  0------1
clockWise(a,'load');
main = 'main';
load = 'load';
disp('End of initialization')