function counterClockWise(a,motor)
    error = 0;
    if(motor == 'main')
        A = 'D13';
        B = 'D12';
    elseif(motor == 'load')
        A = 'D7';
        B = 'D6';
    else
        disp('Error: unrecognized motor');
        error = 1;
    end
    if(~error)
        writeDigitalPin(a,A,1);
        writeDigitalPin(a,B,0);
    end
end