%{ 
    Energy detector of signals in noise
    Input: 
        Sig (num[]): received signal (either Sig=n xor Sig=n+s)
        Pf (0<=num<=1): chosen probability of false alarm
    Output:
        FoundFlag (bool): 0 <=> just noise, 1 <=> signal present
        FoundLoc (num[]): location(s) where signal was detected
    Course: Basic Signal Analysis, 
            Lecture #6, Detection
%}

function [FoundFlag, FoundLoc] = EnergyDetection(sig, Pf)
    WinLen = 2e2;
    Len = 2e3; % Before what we want to detect
    dNoise = zeros(1, length(sig)-WinLen);
    FoundFlag = 0;
    FoundLoc = [];
    NormValue = [];
    d_t = sqrt(2)*erfcinv(2*Pf); % Threshold
       
    for ind = WinLen+1 : Len
        dNoise(ind-WinLen) = sum(sig(ind-WinLen:ind).^2) / WinLen;
    end
    Varnoise = var(dNoise);
    Enoise = mean(dNoise);
    
    Current_d = zeros(1, length(sig));
    for ind = (Len+WinLen+1) : length(sig)
        CurrentWin = sum(sig(ind-WinLen:ind).^2) / WinLen;
        Current_d(ind) = (CurrentWin - Enoise) / sqrt(Varnoise);
        if Current_d(ind) > d_t % If found d >= threshold then just noise
            FoundFlag = 1;
            NormValue = [NormValue, Current_d(ind)];
            FoundLoc = [FoundLoc, ind]; % On time domain
        end
    end
end
