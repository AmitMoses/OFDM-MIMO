function [s_hat] = MRC_estimation(y,h)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
h_norm = sum(abs(h).^2,2);
s_hat = sum(conj(h).*y,2) ./ h_norm;
end

