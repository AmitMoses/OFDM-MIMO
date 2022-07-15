function [s_STC] = STC_transmission(s)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
t0 = s;
t1 = reshape(flip(reshape(s, 2,[])), 1, []);
t1 = conj(t1).*(-1).^(1:length(s));
s_STC = sqrt(1/2).*[t0, t1.'];
end

