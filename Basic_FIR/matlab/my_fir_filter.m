fs=10000 %% sampling frequency
f1=500;  %% first sinewave freq (in band)
f2=4500; %% second sinnewave freq (out band)

% Damiani, Hao, Sica x = 7, y = 3
x = 7;
y = 3;
p = 1;
N = (2^p)*((rem(x,2)) + 1) + 6*p % N = 10 filter order
nb = (rem(y,7)) + 8 % nb = 11 number of bits

fc = 2e03; % Cut-off frequency
fnyq = fs/2; % Nyquist frequency
f0 = fc/fnyq; % Normalized fc

T=1/500; %% maximum period
tt=0:1/fs:10*T; %% time samples

x1=sin(2*pi*f1*tt); %% first sinewave
x2=sin(2*pi*f2*tt); %% second sinewave

x=(x1+x2)/2; %% input signal

[bi, bq]=group13_fir(N, nb); %% filter design

y=filter(bq, 1, x); %% apply filter
%% plots
figure
plot(tt,x1,'--d');
hold on
plot(tt,x2,'r--s');
plot(tt,x, 'g--+');
plot(tt, y, 'c--o');

legend('x1', 'x2', 'x', 'y')

%% quantize input and output
xq=floor(x*2^(nb-1));
idx=find(xq==2^(nb-1));
xq(idx)=2^(nb-1)-1;

yq=floor(y*2^(nb-1));
idy=find(yq==2^(nb-1));
yq(idy)=2^(nb-1)-1;
R = thd(yq)

%% save input and output
fp=fopen('gr13_samples.txt','w');
fprintf(fp,'%d\n', xq);
fclose(fp);

fp=fopen('gr13_results.txt', 'w');
fprintf(fp, '%d\n', yq);
fclose(fp);
