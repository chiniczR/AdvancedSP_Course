%{ 
    Comparison of Least-Squares and Orthogonal Matching Pursuit Techniques
    for Channel Estimation, based on Mean Squared Error
    Input: 
        T_m (num): maximum time
        R (num): range of propagation
        sigma2 (num): std of gaussian impulse components
    Output:
        MSE_LS (num): mean squared error of LS estimator
        MSE_OMP (num): mean squared error of OMP estimator
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #3, Channel Estimation - Class II
%}

function [MSE_LS, MSE_OMP] = ChannelEstimation2(T_m, R, sigma2)
    % Basic definitions
    t = 0:1/100:T_m;
    n = length(t); 
    Pilot = square(2*pi*t*10);
    %[ones(ceil(n/2),1); -ones(floor(n/2),1)];
    X = zeros(n); % Input matrix with n pilots
    for ind=1:n
        X(ind,ind) = Pilot(ind);
    end
    H = TapDelayLineModel(T_m, R, sigma2)'; % Channel
    Z = randn(n,1); % Zero-mean gaussian noise
    Y = X*H + Z; % Received signal
    
    % Channel Estimation with LS
    hHat = inv(X) * Y; % Matrix inverse MATLAB docs

    % Channel Estimation with OMP
    hOMP = OMP(X, Y, n);

    % Comparison with MSE
    MSE_LS = (1/n) * sum((H - hHat).^2);
    MSE_OMP = (1/n) * sum((H - hOMP).^2);

    % Display result of comparison
    if MSE_LS > MSE_OMP
        disp('OMP better than LS');
    else
        disp('LS better than OMP');
    end
end