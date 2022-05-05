%{ 
    Channel estimation with the Least Square method
    Input: 
        T_m (num): maximum time
        R (num): range of propagation
        sigma2 (num): std of gaussian impulse components
        ChannelModel (function): channel generating function
    Output:
        hHat (num[]): LS estimate of channel
        Pilot (num[]): transmitted signal
        Y (num[]): received signal
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #3, Channel Estimation
%}

function [hHat, X, Y, H] = ChannelEstimateLS(T_m, R, sigma2, ChannelModel)
    % Basic definitions
    t = 0:1/(T_m*2):T_m;
%     t = 0:1:T_m;
    n = length(t); 
    Pilot = square(2*pi*t*10);
    X = zeros(n); % Input matrix with n pilots
    for ind=1:n
        X(ind,ind) = Pilot(ind);
    end
    H = ChannelModel(T_m, R, sigma2)'; % Channel
    Z = randn(n,1); % Zero-mean gaussian noise
    Y = X*H + Z; % Received signal
    
    % Channel Estimation with LS
    hHat = inv(X) * Y;

    % Calculate and display Mean Squared Error (MSE)
    MSE_LS = (1/n) * sum((H - hHat).^2);
    fprintf("MSE from LS estimation: %f\n", MSE_LS);
end