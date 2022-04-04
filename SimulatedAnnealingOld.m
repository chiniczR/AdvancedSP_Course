%{ 
    Simulated Annelaing (SA) optimization
    Input: 
        -- Parameters for the objective function (matched filter)
        hHat (num[]): Initial estimate of channel
        r (num[]): Received signal
        s (num[]): Transmitted signal
        -- Simulated Annealing parameters
        MaxIterSame (int>0): Maximum no. iterations w/o change
        MaxIterTotal (int>0): Maximum no. total iterations
        InitTemp (num): Initial temperature
        ObjFunc (function): Objective function to be optimized
    Output:
        hHatOpt (num[]): Optmized estimate
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Optimization – Class II
%}

function [hHatOpt] = SimulatedAnnealingOld(hHat, r, s, MaxIterSame, ...
    MaxIterTotal, InitTemp, ObjFunc)

    % Initialize counters and initial solutions
    IterCnt = 1;
    IterSameCnt = 1;
    hHatOpt = hHat;
    Prev = ObjFunc(r, s, hHat);

    % Begin annealing process
    while IterCnt < MaxIterTotal && IterSameCnt < MaxIterSame
        
        CurrSol = hHatOpt + rand(size(hHat)); % Current argument estimate
        Curr = ObjFunc(r, s, CurrSol);  % Current evaluation of argument
        Delta = sqrt(sum((Curr-Prev).^2)); % Current difference
        Temp = InitTemp / IterCnt;      % Current temperature
        Metropolis = exp(-Delta/Temp);  % Current metropolis

        % Accept new solution if step is descent or ascent within random
        % (uniform) chance, i.e. update the optimal argument and its value
        if Delta < 0 || rand(1) < Metropolis
            hHatOpt = CurrSol;
            Prev = Curr;
        else    % Otherwise increment same solution counter
            IterSameCnt = IterSameCnt + 1;
        end

        % Increment total iterations counter
        IterCnt = IterCnt + 1;
    end
end