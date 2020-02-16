function out = dIntegrate(I,i,Ts)
    % tustin integrator, 'i' has to be already updated
    A = [1,0;1,0];
    B = Ts/2*[1,1;0,0];
    out = A*I + B*i;
end