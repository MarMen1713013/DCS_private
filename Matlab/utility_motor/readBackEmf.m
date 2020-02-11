function out = readBackEmf(bEmf,enc)
    Ke = 0.0666;
    out(1) = bEmf(2);
    out(2) = Ke*readSpeed(enc);
end