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
y=chirp(t,100,1,200);        % Start @ 100Hz, cross 200Hz at t=1sec

% Generating white and colorized noise
max_A = 5; min_A = 15; N = 5e3;
Amp_chirp_res = (max_A-min_A)/200;
spike = min_A: Amp_chirp_res:max_A - Amp_chirp_res;
color = spike.*ones(1,200);
gNoise = randn(1,N);                % White noise
pNoise = filter(color,1,gNoise);    % Non-white noise

% Signal within noise and the signal presence boolean array for each of them
SigWhiteNoise = gNoise;
SigWhiteNoise(2e3:2e3+length(y)-1)=SigWhiteNoise(2e3:2e3+length(y)-1)+y;
PresentW = size(SigWhiteNoise);
PresentW(2e3:2e3+length(y)-1) = 1;
SigNW = pNoise;
SigNW(2e3:2e3+length(y)-1)=SigNW(2e3:2e3+length(y)-1)+5*y;
PresentNW = size(SigNW);
PresentNW(2e3:2e3+length(y)-1) = 1;

% Define increasing probabilities of false alarm
Pfas = linspace(1e-10,1e-1,100);

% Perform each type of detection
[NoFiltPdsWhite, NoFiltPdsNW] = UnfilteredDetection(SigWhiteNoise, SigNW, ...
    PresentW, PresentNW, Pfas, length(y));
[BandPdsWhite, BandPdsNW] = BandpassDetection(SigWhiteNoise, SigNW, ...
    PresentW, PresentNW, Pfas, length(y), [100 300], fs);
[EckPdsWhite, EckPdsNW] = EckartDetection(SigWhiteNoise, SigNW, ...
    PresentW, PresentNW, Pfas, y, gNoise, pNoise); %, gNoise(2e3:2e3+length(y)-1), ...
    % pNoise(2e3:2e3+length(y)-1));

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