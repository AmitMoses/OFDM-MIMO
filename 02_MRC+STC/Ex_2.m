close all
clear
clc

%% Transmmit QPSK 
N = 1e6; % number of bits
Es = 1;
M = 4;
x = randi([0 M-1],N,1);
symbols = qammod(x,M,'UnitAveragePower', true);

% dict = Es*qammod(0:M-1,M); % QAM dictionary 
% symbols = dict(randi(numel(dict),[1 N])).'; % return vec length of L symboles from dict

%% Cahnnel
h = 1;
% Multipath channels
h_1x1 = (1/sqrt(2))*(randn(1,N) + 1i*randn(1,N)).';
h_1x2 = (1/sqrt(2))*(randn(2,N) + 1i*randn(2,N)).';
h_1x4 = (1/sqrt(2))*(randn(4,N) + 1i*randn(4,N)).';

% AWGN
snr_vec = 0:1:40;
noise = sqrt(1/2)*(randn(N,1) + 1i*randn(N,1));
noise_2d = sqrt(1/2)*(randn(N,2) + 1i*randn(N,2));
noise_4d = sqrt(1/2)*(randn(N,4) + 1i*randn(N,4));

% snr_vec = 25;
SER_reyleigh = zeros(1,length(snr_vec));
a = sqrt(h^2./10.^(snr_vec/10));
for i=1:length(snr_vec)
    
    snr = snr_vec(i);
    snr_lin = 10^(snr/10);
    p = sqrt(h^2/snr_lin);
    
    
    %% Received Signal
    s_awgn = h.*symbols + p*noise;
    s_reyleigh = h_1x1.*symbols + p*noise;
    s_mrc = h_1x2.*repmat(symbols, [1,2]) + p*noise_2d;
    s_mrc4 = h_1x4.*repmat(symbols, [1,4]) + p*noise_4d;
    
    % AWGN receiver
    rec_awgn = qamdemod(s_awgn./h,M,'UnitAveragePower', true);
    
    % MP receiver
    s_reyleigh_ = s_reyleigh./h_1x1;
    rec_reyleigh = qamdemod(s_reyleigh_,M,'UnitAveragePower', true);
    
    % MRC 1x2
    s_hat = MRC_estimation(s_mrc, h_1x2);
    rec_mrc = qamdemod(s_hat,M,'UnitAveragePower', true);
    
    % MRC 1x4
    s_hat4 = MRC_estimation(s_mrc4, h_1x4);
    rec_mrc4 = qamdemod(s_hat4,M,'UnitAveragePower', true);
    
    
    % SER
    SER_reyleigh(i) = 1-sum(eq(x,rec_reyleigh))/N;
    SER_awgn(i) = 1-sum(eq(x,rec_awgn))/N;
    SER_mrc(i) = 1-sum(eq(x,rec_mrc))/N;
    SER_mrc4(i) = 1-sum(eq(x,rec_mrc4))/N;
end

figure()
semilogy(snr_vec, SER_awgn)
hold on
semilogy(snr_vec, SER_reyleigh)
hold on
semilogy(snr_vec, SER_mrc)
hold on
semilogy(snr_vec, SER_mrc4)
grid on
grid minor
legend('AWGN','SISO','MRC 1x2','MEC 1x4')
title('SER for AWGN and Reyleigh Channels')
xlabel('SNR')
ylabel('SER')




