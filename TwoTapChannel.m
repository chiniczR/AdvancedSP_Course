%{ 
    Two-tap Channel Model
    Input: 
        T_m (num): maximum time
        R (num): range of propagation
        sigma2 (num): std of gaussian impulse components
    Output:
        h (num[]): channel filter
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #2, Basics of Underwater Acoustics 
%}

function h = TwoTapChannel(T_m, R, sigma2)
    % Assumed model of A
    A = 20*log10(R);
    
    % Time-span
    t = 0:1/(T_m*2):T_m;
%     t = 0:1:T_m;
    
    % Impulse response
    h = zeros(1,length(t));
    tim = 1;
    while tim <= length(t)
        % Parameters
        theta_p = rand(1)*2*pi; % theta_p ~ U[0,2pi]
        x = normrnd(A,sigma2,1); % x ~ N(A, sigma^2)
        y = normrnd(A,sigma2,1); % x ~ N(A, sigma^2)
        
        % Components of the impulse response
        r_p = abs(x + y*1i); % r_p = |x + yi|
        c_p = r_p * exp(1j*theta_p);
        h(tim) = abs(c_p);
    
        % Next tap
        tim = tim + round(length(t)/2);
    end

    % Display channel taps
    stem(t, h)
    xlabel("Time (s)")
    ylabel("Amplitude")
    title("Impulse on Time")
end
