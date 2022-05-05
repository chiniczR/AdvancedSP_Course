function [InitMu1, InitSigma1, InitBeta1, InitMu2, InitSigma2, InitBeta2, InitAlfa1, InitAlfa2] = ...
    GuessClassify(x, RatioTh, BetaFlag)
%function [InitMu1, InitSigma1, InitBeta1, InitMu2, InitSigma2, InitBeta2, InitAlfa1, InitAlfa2] = GuessClassify(x, RatioTh, BetaFlag)
%
%Description:
% This function initializes parameters for the EM algorithm
%
%Input:
% x - measurement vector
% RatioTh - threshold to decide if this is  a single class case
% BetaFlag - A flag. If set than estimate Beta. Otherwaise Beta=2
%
%Output:
% InitMu1 - mean of DL
% InitSigma1 - variance of DL
% InitBeta1 - Beta coefficient of DL
% InitMu2 - mean of ML
% InitSigma2 - variance of ML
% InitBeta2 - Beta coefficient of ML
% InitAlfa1 - weight of the DL process
% InitAlfa2 - weight of the ML process
%-------------------------
%Kmean algorithm
Index = kmeans(x', 2);
%-------------------------

%%

x1 = x(find(Index == 1)); %#ok<FNDSB>
x2 = x(find(Index == 2)); %#ok<FNDSB>

%arrange according to mean
if mean(x1) > mean(x2)
    temp = x1;
    x1 = x2;
    x2 = temp;
end

%-------------------------
%get initial parameters according to general gaussian distribution

%calculate prior
InitAlfa1 = length(x1) / (length(x1) + length(x2));
InitAlfa2 = length(x2) / (length(x1) + length(x2));

%calculate ratio between classes
if InitAlfa1 > InitAlfa2
    TestRatio = InitAlfa2/InitAlfa1;
else
    TestRatio = InitAlfa1/InitAlfa2;
end
%determine of a single class or two classes
if TestRatio > RatioTh
    %single class
    InitAlfa1 = 1-eps;
    InitAlfa2 = eps;
    %evaluate the statistics of the larger class
    [InitMu1, InitSigma1, InitBeta1] = EvalStat(x, BetaFlag);
    InitMu2 = InitMu1;
    InitSigma2 = InitSigma1;
    InitBeta2 = InitBeta1;
else
    %evaluate the statistics of both classes
    [InitMu1, InitSigma1, InitBeta1] = EvalStat(x1, BetaFlag);
    [InitMu2, InitSigma2, InitBeta2] = EvalStat(x2, BetaFlag);
end

