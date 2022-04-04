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

    % Optimize estimate by Simulated Annealing
    hHatSA = SimulatedAnnealing(hHat, T_Max, T_Min, L, MaxStay, ...
        @(h) (1/length(h)) * sum((H - h).^2)); % Currently MSE (see PROB)
    % Negative MF for maximization through minimization
    %-(s*h*r) -- PROB: MF does not return scalar!!!

    % Calculate MSE of optimized estimate
    n = length(hHatSA);
    MSE_SA = (1/n) * sum((H - hHatSA).^2);
    fprintf("MSE from SA optimized estimate: %f\n", MSE_SA);
end