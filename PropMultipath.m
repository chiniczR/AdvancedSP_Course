%{ 
    Propagate signal through multipath sound channel
    Input: 
        y (num[]): received signal
        fs (num): sampling frequency of signal
        t (num[]): timespan array of singal transmission (opt. for plot)
    Output: 
        propsig (num[]): real part of coherent sum of the propagated signals
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #4, Detection – Class I
    Source: Matlab documentation for Multipath Channel step, Example 1
    https://www.mathworks.com/help/phased/ref/phased.multipathchannel.step.html#bvojyht-6
%}

function [propsig] = PropMultipath(y, fs, t)

    % Create the channel and specify the source and receiver locations and velocities
    numpaths = 5;
    channel = phased.IsoSpeedUnderwaterPaths('ChannelDepth',200,'BottomLoss',10, ...
        'NumPathsSource','Property','NumPaths',numpaths);
    tstep = 1;
    srcpos = [0;0;-160];
    rcvpos = [100;0;-50];
    speed = -20*1000/3600;
    srcvel = [0;0;0];
    rcvvel = [speed;0;0];
    
    % Compute the path matrix, Doppler factor, and losses
    [pathmat,dop,absloss] = channel(srcpos,rcvpos,srcvel,rcvvel,tstep);
    
    % Propagate the signals to the receiver
    propagator = phased.MultipathChannel('OperatingFrequency',10e3,'SampleRate',fs);
    sig0 = y;
    sig = repmat(sig0,1,numpaths);
    propsig = propagator(sig,pathmat,dop,absloss);

    % Return real part of the coherent sum of the propagated signals
    propsig = real(sum(propsig,2));

end