%{ 
    Optimization of channel estimatation by Simulated  Annealing (SA) for 
    sparse approximation by l0 norm
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
    Ref: 
    Yangyang Li, Jianping Zhang, Guiling Sun, Dongxue Lu, "The Sparsity 
    Adaptive Reconstruction Algorithm Based on Simulated Annealing for 
    Compressed Sensing", Journal of Electrical and Computer Engineering, 
    vol. 2019. https://doi.org/10.1155/2019/6950819
%}

function [hHatSA] = ChannelOptimization(T_m, R, sigma2, T_Max, T_Min, ...
    L, MaxStay)

    % Get initial estimate, received and trasmitted signal by Least Square
    [hHat, A, b, H] = ChannelEstimateLS(T_m, R, sigma2, @TwoTapChannel);

    % Optimize estimate by Simulated Annealing and calculate MSE
    k = sprank(A);
    xHatSA = SimulatedAnnealing(randi(k,1,max(size(hHat))), T_Max, T_Min,...
        L, MaxStay, @(I) norm(A(:,I)*pinv(A(:,I))*b - b), 2); 
    hHatSA = pinv(A(:,xHatSA))*b;

    % If needed pad with zeros
    n = length(hHatSA);
    if n ~= length(H)
        filler = zeros(size(H));
        filler(1:n) = hHatSA;
        hHatSA = filler;
    end

    % Display MSE of channel estimate from SA
    MSE_SA = (1/n) * sum((sort(H) - sort(hHatSA)).^2);
    fprintf("MSE from SA optimized estimate: %f\n", MSE_SA);
end