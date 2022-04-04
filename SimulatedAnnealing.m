%{ 
    Simulated Annelaing (SA) optimization
    Input:
        x0 (num[]): initial solution
        T_Max (num): maximum temperature (initial temperature)
        T_Min (num): minimum temperature (end temperature)
        L (int>0): no. of iterations under every temperature
        MaxStay (int>0): cooldown time
        ObjFunc (function): Objective function to be optimized
    Output:
        x (num[]): optmized solution
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Optimization – Class II
    Based on: scikit-opt (python module for Heuristic Algorithms)
    https://github.com/guofei9987/scikit-opt/blob/master/sko/SA.py
%}

function [x] = SimulatedAnnealing(x0, T_Max, T_Min, L, MaxStay, ObjFunc)

    % Initialization
    BestX = x0;             % Best solution (argument)
    BestY = ObjFunc(x0);    % Best value (of objective function)
    T = T_Max;              % Current temperature
    Iter = 0;               % Total iterations counter
    CurrX = BestX;          % Current solution
    CurrY = BestY;          % Current function value
    StayCntr = 0;           % No-change iterations counter

    % Begin annealing process
    while T > T_Min && StayCntr < MaxStay
        for it=1:L
            % Find new x and evaluate value of function for it
            NewX = CurrX + rand(size(CurrX));
            NewY = ObjFunc(NewX);

            % Metropolis criteria check
            Delta = (NewY - CurrY); % PROB: MF does NOT return scalar!!!
            if Delta < 0 || rand(1) < exp(-Delta/T)
                CurrX = NewX; 
                CurrY = NewY;
                if (NewY) < (BestY) % PROB: same!!!
                    BestX = NewX;
                    BestY = NewY;
                    StayCntr = 0;
                else
                    StayCntr = StayCntr + 1;
                end
            end
        end

        % Increment counter and cool off
        Iter = Iter + 1;
        T = T * 0.7;
    end

    % Optimized argument
    x = BestX;
end