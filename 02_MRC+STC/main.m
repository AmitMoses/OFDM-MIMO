close all
clear
clc

%% Transmmit Signal QAM4 
N = 1e6; % number of bits
Es = 1;
M = 4;
x = randi([0 M-1],N,1);
symbols = qammod(x,M,'UnitAveragePower', true);
symbols_STC = STC_transmission(symbols);


%% Cahnnel
h = 1;
% Multipath channels
h_1x1 = (1/sqrt(2))*(randn(1,N) + 1i*randn(1,N)).';
h_1x2 = (1/sqrt(2))*(randn(2,N) + 1i*randn(2,N)).';
h_1x4 = (1/sqrt(2))*(randn(4,N) + 1i*randn(4,N)).';

% AWGN
snr_vec = 0:1:40;
noise_1x1 = sqrt(1/2)*(randn(N,1) + 1i*randn(N,1));
noise_1x2 = sqrt(1/2)*(randn(N,2) + 1i*randn(N,2));
noise_1x4 = sqrt(1/2)*(randn(N,4) + 1i*randn(N,4));

% SER vector initialize
SER_reyleigh = zeros(1,length(snr_vec));
SER_awgn = zeros(1,length(snr_vec));
SER_mrc = zeros(1,length(snr_vec));
SER_mrc4 = zeros(1,length(snr_vec));
SER_stc = zeros(1,length(snr_vec));

%% Received Signal
for i=1:length(snr_vec)
    % noise energy
    snr = snr_vec(i);
    snr_lin = 10^(snr/10);
    p = sqrt(h^2/snr_lin);
     
    % Received Signal
    s_awgn = h.*symbols + p*noise_1x1;
    s_reyleigh = h_1x1.*symbols + p*noise_1x1;
    s_mrc = h_1x2.*repmat(symbols, [1,2]) + p*noise_1x2;
    s_mrc4 = h_1x4.*repmat(symbols, [1,4]) + p*noise_1x4;
    s_stc = sum(h_1x2.*symbols_STC,2) + p*noise_1x2;
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
    
    % STC receiver
    s_hat_stc = zeros(N,1);
    for ii=1:2:N
        h0 = h_1x2(ii,1);
        h1 = h_1x2(ii,2);
        H = [h0, h1 ; conj(h1), -conj(h0)];
        s_hat_stc(ii:ii+1,1) = inv(H)*s_stc(1,:).';
    end
    
    
    % SER
    SER_reyleigh(i) = 1-sum(eq(x,rec_reyleigh))/N;
    SER_awgn(i) = 1-sum(eq(x,rec_awgn))/N;
    SER_mrc(i) = 1-sum(eq(x,rec_mrc))/N;
    SER_mrc4(i) = 1-sum(eq(x,rec_mrc4))/N;
    SER_stc(i) = 1-sum(eq(x,s_hat_stc))/N;
end

%% Plot
figure()
semilogy(snr_vec, SER_awgn)
hold on
semilogy(snr_vec, SER_reyleigh)
hold on
semilogy(snr_vec, SER_mrc)
hold on
semilogy(snr_vec, SER_mrc4)
hold on
semilogy(snr_vec, SER_stc)
grid on
grid minor
legend('AWGN','SISO','MRC 1x2','MRC 1x4','STC')
title('SER for AWGN and Reyleigh Channels')
xlabel('SNR')
ylabel('SER')




