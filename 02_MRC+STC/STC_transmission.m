function [s_STC] = STC_transmission(s)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% t0 = s;
% t1 = reshape(flip(reshape(s, 2,[])), 1, []);
% t1 = conj(t1).*(-1).^(1:length(s));
% s_STC = sqrt(1/2).*[t0, t1.'];

 s_STC = zeros(length(s),2);
 s_STC(1:2:end,1) = s(1:2:end);
 s_STC(2:2:end,1) = -conj(s(2:2:end));
 s_STC(1:2:end,2) = s(2:2:end);
 s_STC(2:2:end,2) = conj(s(1:2:end));
 s_STC = sqrt(1/2)*s_STC;
end

