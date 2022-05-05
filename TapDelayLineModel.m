%{ 
    Tap-Dealy Line IR Channel Propagation
    Input: 
        T_m (num): maximum time
        R (num): range of propagation
        sigma2 (num): std of gaussian impulse components
    Output:
        h (num[]): channel filter
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #2, Basics of Underwater Acoustics 
%}

function h = TapDelayLineModel(T_m, R, sigma2)
    % For open interval
    eps = 10e-3;
    
    % Assumed model of A
    A = 20*log10(R);
    
    % Time-span
    t = 0:1/10:T_m;
    
    % Impulse response
    h = zeros(1,length(t));
    tim = round(rand(1)*(T_m-eps) + eps);
    while tim <= length(t)
        % Parameters
        theta_p = rand(1)*2*pi; % theta_p ~ U[0,2pi]
        tau_p = rand(1)*(T_m-eps) + eps; % tau_p ~ U(0,Tm)
        x = normrnd(A,sigma2,1); % x ~ N(A, sigma^2)
        y = normrnd(A,sigma2,1); % x ~ N(A, sigma^2)
        
        % Components of the impulse response
        r_p = abs(x + y*1i); % r_p = |x + yi|
        c_p = r_p * exp(1j*theta_p);
        h(tim) = abs(c_p);
    
        % Next tap
        tim = tim + round(tau_p);
    end
    
    % Linear chirp from 1 to 25
    x = chirp(t,0,1,25);
    
    subplot(2, 2, 1)
    stem(t, h)
    xlabel("Time (s)")
    ylabel("Amplitude")
    title("Impulse on Time")
    subplot(2, 2, 2)
    % From Basics of Signal Analysis lecture on frequency analysis
    % (tutorial - "FourierNyquistTutorial.m")
    hFreq = abs(fftshift(fft(h)));
    N = length(x);
    fs = 1/(t(2) - t(1));
    Faxis = linspace(-fs/2,fs/2,N);
    plot(Faxis,hFreq);
    xlabel("Frequency (Hz)")
    ylabel("Amplitude")
    title("Impulse on Frequency")
    
    % Convolve the two and show PSD
    y = filter(h,1,x);
    subplot(2, 2, [3 4])
    pwelch(y)
    title("Welch Graph of Convolotion between Chirp and IR")
end
