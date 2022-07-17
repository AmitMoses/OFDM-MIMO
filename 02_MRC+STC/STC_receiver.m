function [s_hat] = STC_receiver(y,h)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    N = size(h,1);
    y_vec = y;
    y_vec(2:2:end) = conj(y(2:2:end)); % take the conj of even slots
    y_vec = reshape(y_vec,[2  N/2]).';
    
    % calculate channel model for MRC detection 
    h_channel_0 = zeros(N/2,2); % pre alocate for channel model calculation (each row is a alamuti vector h0n or [h01;h02;..])
    h_channel_0(:,1) = h(1:2:end,1);         % h0
    h_channel_0(:,2) = conj(h(1:2:end,2));   % h1*
    
    h_channel_1 = zeros(N/2,2); % pre alocate for channel model calculation (each row is a alamuti vector h1n or [h11;h12;..])
    h_channel_1(:,1) = h(1:2:end,2);         % h1
    h_channel_1(:,2) = -conj(h(1:2:end,1));  % -h0*
    
    s_odd_1 = MRC_estimation(y_vec,h_channel_0).';
    s_even_1 = MRC_estimation(y_vec,h_channel_1).';
    
    s_hat = reshape( [s_odd_1;s_even_1],[N 1] );
end

