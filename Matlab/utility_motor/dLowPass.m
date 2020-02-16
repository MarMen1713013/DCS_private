function out = dLowPass(I,i,tau,Ts)
    A = [1-Ts/tau, 0; 1, 0];
    B = [0, Ts/tau;0,0];
    out = A*I + B*i;
end