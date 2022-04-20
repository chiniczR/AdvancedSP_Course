%{ 
    Eckart filter implementation
    Input: 
        x (num[]): time-domain received signal
        SigSpec (num[]): signal power spectrum
        NoiseSpec(num[]): noise power spectrum
    Output:
        y (num[]): time-domain filtered result
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Detection – Class I
%}

function [y] = EckartFilter(x, SigSpec, NoiseSpec)
    % Discrete fourier transform of x
    X = fft(x);

    % Definition of Eckart filter frequency response
    H = sqrt(SigSpec / NoiseSpec.^2);

    % Application of filter on frequency
    Y = H*X;

    % Return to time-domain with inverse FFT
    y = ifft(Y);
end