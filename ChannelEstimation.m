%{ 
    Comparison of Least-Squares and Minimum Mean Squared Error Techniques
    for Channel Estimation, based on Mean Squared Error
    Input: 
        T_m (num): maximum time
        R (num): range of propagation
        sigma2 (num): std of gaussian impulse components
    Output:
        MSE_LS (num): mean squared error of LS estimator
        MSE_MMSE (num): mean squared error of MMSE estimator
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #3, Channel Estimation
%}

function [MSE_LS, MSE_MMSE] = ChannelEstimation(T_m, R, sigma2)
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
    
    % Channel Estimation with MMSE
    hTil = hHat; % The LS estimation of the channel
    W = corr(H,hTil) * inv(corr(hTil, hTil));
    hHat = W * hTil;
    
    % Comparison with MSE
    MSE_LS = (1/n) * sum((H - hTil).^2);
    MSE_MMSE = (1/n) * sum((H - hHat).^2);

    % Display result of comparison
    if MSE_LS > MSE_MMSE
        disp('MMSE better than LS');
    else
        disp('LS better than MMSE');
    end
end