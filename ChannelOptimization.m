%{ 
    Optimization (maximization) of channel estimate in terms of matched 
    filter output with Simulated Annealing (SA) and Genetic Algorithm (GA)
    Input: 
        -- Channel parameters
        T_m (num): maximum time
        R (num): range of propagation
        sigma2 (num): std of gaussian impulse components
        -- Simulated Annealing parameters
        T_Max (num): maximum temperature (initial temperature)
        T_Min (num): minimum temperature (end temperature)
        L (int>0): no. of iterations under every temperature
        MaxStay (int>0): cooldown time
    Output:
        hHatSA (num[]): Optmized estimate by SA
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Optimization – Class II
%}

function [hHatSA] = ChannelOptimization(T_m, R, sigma2, T_Max, T_Min, ...
    L, MaxStay)

    % Get initial estimate, received and trasmitted signal by Least Square
    [hHat, s, r, H] = ChannelEstimateLS(T_m, R, sigma2, @TwoTapChannel);

    % Optimize estimate by Simulated Annealing and calculate MSE
    % TO-DO: matched filter with (two) known taps only -> scalar!!!
    hHatSA = SimulatedAnnealing(hHat, T_Max, T_Min, L, MaxStay, ...
        @(h) -(s*h*r)); % Negative MF for maximization through minimization
    %                       -- PROB: MF does not return scalar!!!
    n = length(hHatSA);
    MSE_SA = (1/n) * sum((H - hHatSA).^2);
    fprintf("MSE from SA optimized estimate: %f\n", MSE_SA);

    % Optimize estimate by Genetic Algorithm and calculate MSE
    FitFunc = @(h) -(s*h*r);        % PROB: same
    [hHatGA,~] = ga(FitFunc,1,[],[],[],[],[],[]);
    MSE_GA = (1/n) * sum((H - hHatGA).^2);
    fprintf("MSE from GA optimized estimate: %f\n", MSE_GA);
end