function T = w2T(w)
    Ke = 0.729;
    Va = 12;
    Ra = 13.7;
    T = -(Ke^2/Ra)*w + Ke*Va/Ra;
end