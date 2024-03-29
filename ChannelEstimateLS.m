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

function [hHat, X, Y, H, Z, t] = ChannelEstimateLS(T_m, R, sigma2, ChannelModel)
    % Basic definitions
    t = 0:1/(T_m*2):T_m;
    n = length(t); 
%     Pilot = fft(chirp(t,5e3,t(end),10e3));
    Pilot = fft(cos(2*pi*t*10));
    X = zeros(n); % Input matrix with n pilots
    for ind=1:n
        X(ind,ind) = Pilot(ind);
    end
    H = fft(ChannelModel(T_m, R, sigma2))'; % Channel
    Z = fft(randn(n,1)); % Zero-mean gaussian noise
    Y = X*H + Z; % Received signal
    
    % Channel Estimation with LS
    hHat = inv(X) * Y;

    % Get things back to time-domain
    y = ifft(Y);
    estimate = ifft(X*hHat + Z);

    % Display difference of channel on transmitted signal
    subplot(2, 1, 1)
    plot(t,y); hold on; plot(t,estimate);
    xlabel("Time (s)")
    title("Signal Through Original vs Estimated Channels - Least Square (LS)")
    legend({"Original","LS Estimate"})


    % Calculate normalized MSE on received signal
    MSE_R_LS = (1/(n*sum(y.^2))) * sum((y - estimate).^2);
    fprintf("MSE from transmission through LS estimated channel: %d\n", MSE_R_LS);
end