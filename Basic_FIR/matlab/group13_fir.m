% 1.1: Design FIR filter in Matlab
function[bi, bq] = group13_fir(N,nb)
% bi are the taps of the filter, represented as integers
close all;

fs = 10e03 % sampling frequency
fc = 2e03; % Cut-off frequency
fnyq = fs/2; % Nyquist frequency
f0 = fc/fnyq; % Normalized fc

b = fir1(N, f0); % Obtain filter coefficients
[h1, w1] = freqz(b); % Transfer function of our filter
bi = floor(b*2^(nb-1)) % Coefficients converted in integers on nb bits
bq = bi/2^(nb-1); % Coefficients as nb-bit real values
[h2, w2] = freqz(bq); % Transfer function of the quantized filter

% Show transfer functions
plot(w1/pi, 20*log10(abs(h1)));
hold on;
plot(w2/pi, 20*log10(abs(h2)), 'r--');
grid on;
xlabel('Normalized frequency');
ylabel('dB');