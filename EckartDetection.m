%{ 
    Perform energy detection with Eckart-filtered signals and return the
    detection performance stats, for a signal within white noise and one in
    non-white noise.
    Input: 
        SigWhiteNoise (num[]): received signal within white noise
        SigNW (num[]): received signal within non-white noise
        PresentW (bool[]): flags presence (1) or absence (0) of signal in
            white noise
        PresentNW (bool[]): flags presence (1) or absence (0) of signal in
            non-white noise
        Pfas (num[], 0<=num(i)<=1): sorted probabilities of false alarm
        Sig (num[]): transmitted signal
    Output: 
        PdsWhite (num[], 0<=num(i)<=1): resulting probabilities of
            detection for signal within white noise
        PdsNW (num[], 0<=num(i)<=1): resulting probabilities of detection
            for signal within non-white noise
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Detection – Class I
%}

function [PdsWhite, PdsNW] = EckartDetection(SigWhiteNoise, SigNW, ...
    PresentW, PresentNW, Pfas, Sig, WhiteN, NonWhiteN)

    % Define filter and apply to received signal
    % TO-DO: create colored noise with firpm (greater slope), take inverse, pad with zeros
    SigWhiteNoise = filter(1./WhiteN,1,SigWhiteNoise);
    SigNW = filter(1./NonWhiteN,1,SigNW);

    % Short-hand for length of transmitted signal
    LenY = length(Sig);

    % Do energy detection for given probabilities of false alarm
    PdsWhite = [];
    PdsNW = [];
    for Pf=Pfas
        [FoundFlagW, FoundLocW] = EnergyDetection(SigWhiteNoise, Pf);
        [FoundFlagNW, FoundLocNW] = EnergyDetection(SigNW, Pf);
        DetectedW = zeros(size(SigWhiteNoise));
        DetectedW(FoundLocW) = 1;
        DetectedNW = zeros(size(SigNW));
        DetectedNW(FoundLocNW) = 1;
        PdsWhite = [PdsWhite sum(DetectedW(PresentW == 1) == 1) / (LenY+1)];
        PdsNW = [PdsNW sum(DetectedNW(PresentNW == 1) == 1) / (LenY+1)];
    end

end