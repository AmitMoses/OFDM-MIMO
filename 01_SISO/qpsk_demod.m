function [rec_bit, rec_sym] = qpsk_demod(symbols,N,Eb)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

rec_bit = zeros(1,N);
detect_sym = (real(symbols)>0) + 1i*(imag(symbols)>0);
rec_bit = zeros(1,N);
rec_bit(1:2:end) = Eb*real(detect_sym);
rec_bit(2:2:end) = Eb*imag(detect_sym);
rec_sym = Eb*(2*real(detect_sym)-1) +1i*Eb*(2*imag(detect_sym)-1);
end

