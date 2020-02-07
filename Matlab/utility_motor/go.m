function go(a,V,motor)
    if(motor == 'main')
        writePWMVoltage(a,'D11',V);
    elseif(motor == 'load')
        writePWMVoltage(a,'D5',V);
    else
        disp('Error: unrecognized motor');
    end
end