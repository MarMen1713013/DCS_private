function out = delay(n)
    out = [zeros(1,n); eye(n-1), zeros(n-1,1)];
end