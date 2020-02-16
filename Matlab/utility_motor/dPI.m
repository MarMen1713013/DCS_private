function out = dPI(I,i,Kp,Ki,Ts)
    A = [1,0;1,0];
    B = [Ts*Ki+2*Kp, Ts*Ki-2*Kp;0,0]/2;
    out = A*I + B*i;
end