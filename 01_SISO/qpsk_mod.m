function [symbols] = qpsk_mod(bits)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
bit2bpsk = 2*bits-1;
symbols =  bit2bpsk(1:2:end) +1i*bit2bpsk(2:2:end);
end

