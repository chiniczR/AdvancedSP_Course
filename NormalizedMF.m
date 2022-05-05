%{ 
    Normalized Matched Filter for signal detection
    Input: N/A
    Output: N/A
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Detection – Class I
    Source:
    - R. Diamant, "Closed Form Analysis of the Normalized Matched Filter 
    With a Test Case for Detection of Underwater Acoustic Signals," in IEEE 
    Access, vol. 4, pp. 8225-8235, 2016, doi: 10.1109/ACCESS.2016.2630498.
%}

% Definitions of signal and noise
clear;
fs = 10e3;                                  % Sampling freq assumed Nyquist
W = fs / 2;                                 % Assuming fMax = W = fs/2
t = 0:1/fs:5-(1/fs);                        % 5 secs @ 10kHz sample rate
s = chirp(t(2e4:3e4-1),1,t(3e4-1),fs/2);    % Start @ 1Hz, cross 5kHz at t=3sec
T = 1;                                      % Signal duration = 1sec
n = randn(size(t));                         % White noise vector
N = 2*W*T;                                  % Time-band product = no. samples

% System model
y = n;                                  % Just noise (H0)
y(1:1e4) = s + n(1:1e4);                % Received signal (H1)
y(2e4:3e4-1) = s + n(2e4:3e4-1);        
y(4e4:5e4-1) = s + n(4e4:5e4-1);        

% Simulated channel multipath(?) propagation
h = TapDelayLineModel(t(end),10,25);
y = filter(h,1,y);

% Detection parameters
Pf = 1e-3;                                      % Desired CFAR
x_t = sqrt(betaincinv((1 - Pf),1/2,(N-1)/2));   % Detection threshold
Detected = zeros(size(y));

% Calculations that don't need to be repeated
SqrdSigSum = sum(s.^2);
SqrdRecSum = sum(y.^2);
Denom = sqrt(SqrdSigSum * SqrdRecSum);

% Slide normalized matched filter through received signal on time
k = 1;
while k < length(t)-N
    NMF = sum(s.*y(k:k+N-1)) / Denom;  % Test stat
    if NMF > x_t
        Detected(k:k+N-1) = 1;
        k = k+N-1;  % If detected, then increment by length of signal
    else
        k = k + 1;  % Otherwise, take next sample
    end
end

% Display whether signal was detected or not (H0 or H1)
if any(Detected == 1)
    disp("Signal present (H1)");
    plot(t, y); 
    hold on;
    plot(t(Detected==1), y(Detected==1));
    xlabel("Time (s)");
    title("Signal Detected");
else
    disp("Only noise (H0)");
end

% ==================================
% TODO: y contains s, filter on freq
% ==================================



