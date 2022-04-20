%{ 
    Perform energy detection with unfiltered signals and return the
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
        LenY (int): length of transmitted signal
    Output: 
        PdsWhite (num[], 0<=num(i)<=1): resulting probabilities of
            detection for signal within white noise
        PdsNW (num[], 0<=num(i)<=1): resulting probabilities of detection
            for signal within non-white noise
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Detection – Class I
%}

function [PdsWhite, PdsNW] = UnfilteredDetection(SigWhiteNoise, SigNW, ...
    PresentW, PresentNW, Pfas, LenY)
    
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
