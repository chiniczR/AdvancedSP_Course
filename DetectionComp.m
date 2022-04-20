%{ 
    Comparison of energy detection for signals within white and non-white
    noise, where the received signal is: (1) unfiltered, (2) band-pass
    filtered or (3) Eckart filtered
    Input: N/A
    Output: N/A
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Detection – Class I
%}

% Definitions of signal and noise
clear;
t=0:0.001:2;                    % 2 secs @ 1kHz sample rate
fs = 1/(t(2) - t(1));
y=chirp(t,100,1,200);           % Start @ 100Hz, cross 200Hz at t=1sec
% spectrogram(y,kaiser(128,18),120,128,1E3,'yaxis');
% plot(linspace(-fs/2,fs/2,length(y)),abs(fftshift(fft(y))))
N = 5e3;
wn = dsp.ColoredNoise('white',N,1,'OutputDataType','single');
cn = dsp.ColoredNoise('brown',N,1,'OutputDataType','single');
gNoise = wn()';         % White noise
pNoise = cn()';         % Non-white noise

% Signal within noise and the signal presence boolean array for each of them
SigWhiteNoise = gNoise;
SigWhiteNoise(2e3:2e3+length(y)-1)=SigWhiteNoise(2e3:2e3+length(y)-1)+y;
PresentW = size(SigWhiteNoise);
PresentW(2e3:2e3+length(y)-1) = 1;
SigNW = pNoise;
SigNW(2e3:2e3+length(y)-1)=SigNW(2e3:2e3+length(y)-1)+y;
PresentNW = size(SigNW);
PresentNW(2e3:2e3+length(y)-1) = 1;

% Define different probabilities of false alarm
Pfas = linspace(1e-10,1e-1,100);

% Perform each type of detection
[NoFiltPdsWhite, NoFiltPdsNW] = UnfilteredDetection(SigWhiteNoise, SigNW, ...
    PresentW, PresentNW, Pfas, length(y));
[BandPdsWhite, BandPdsNW] = BandpassDetection(SigWhiteNoise, SigNW, ...
    PresentW, PresentNW, Pfas, length(y), [100 300], fs);
[EckPdsWhite, EckPdsNW] = EckartDetection(SigWhiteNoise, SigNW, ...
    PresentW, PresentNW, Pfas, y, gNoise(2e3:2e3+length(y)-1), ...
    pNoise(2e3:2e3+length(y)-1));

% Display comparison of detection performance through ROC
n = linspace(0,N,N);
f = figure;
f.Position(3:4) = [1000, 400];
tiledlayout(1,2);

% ROC of signal in white noise
nexttile
plot(Pfas, NoFiltPdsWhite);
hold on;
plot(Pfas, BandPdsWhite);
plot(Pfas, EckPdsWhite);
hold off;
xlabel("P_{fa}")
ylabel("P_d")
title("ROC for Signal in White Noise")
legend({"Unfiltered", "Bandpass filtered", "Eckart filtered"})

% ROC of signal in non-white noise
nexttile
plot(Pfas, NoFiltPdsNW);
hold on;
plot(Pfas, BandPdsNW);
plot(Pfas, EckPdsNW);
hold off;
xlabel("P_{fa}")
ylabel("P_d")
title("ROC for Signal in Non-White Noise")
legend({"Unfiltered", "Bandpass filtered", "Eckart filtered"})