function [ClassifyVec, mu, sigma, beta] = EstParm(Vec, IterateNum, RatioTh)
%function [ClassifyVec, mu, sigma, beta] = EstParm(Vec, IterateNum, RatioTh)
%
%Description:
% This function estimate the ditribution parameters of a given vector.
% Solution follows the EM algorithm to cluster measurmenet into 2 classes.
% Then ,the parameters of the larger class are picked
%
%Input:
% Vec - vector of measurmeents. 1XN (N any size)
% IterateNum - number of iteration to run clustering. A scalar
% RatioTh - a threshold for the posterior to decide on the main class. A scalar
%
%Output:
% ClassifyVec - classification solution
% mu - mean of largest class
% sigma - std of largest class
% beta - power of largest class (in case of General Gaussian distribution

%Example
if 0
  sig = [randn(1,1000), randn(1,1000) + ones(1,1000)*10, randn(1,1000)];
  Classify = EstParm(sig, 100, 1);
end

%%%%Just to test
% Vec = zeros(1, 20e3);
% Vec1 = randn(1,  round(length(Vec)*0.8))*2 + 1;
% Vec2 = randn(1,  round(length(Vec)*0.2))*0.5 + 10;
% Ind = randperm(length(Vec));
% Vec(Ind(1: length(Vec1))) = Vec1;
% Vec(Ind(length(Vec1)+1:end)) = Vec2;
%%%%%%

%classify according to EM
%mixture model with normal distribution. Mixture is to avoid outliers
[InitMu1, InitSigma1, InitBeta1, InitMu2, InitSigma2, InitBeta2, InitAlfa1, InitAlfa2] = GuessClassify(Vec, RatioTh, 0);
[EstMu1, EstMu2, EstSigma1, EstSigma2, EstAlfa1, EstAlfa2, EstP1, EstP2] = ...
    ClassifyMeasurmentsEM3(Vec, InitMu1, InitMu2, InitSigma1, InitSigma2, InitAlfa1, InitAlfa2, IterateNum);

ClassifyVec = EstP1 > EstP2;

% alfa is the prior. Choose the largest
if EstAlfa1 > EstAlfa2
    mu = EstMu1;
    sigma = sqrt(EstSigma1);
    beta = InitBeta1;
else
    mu = EstMu2;
    sigma = sqrt(EstSigma2);
    beta = InitBeta2;
end


