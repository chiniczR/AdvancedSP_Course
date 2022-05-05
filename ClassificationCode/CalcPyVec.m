function Prob = CalcPyVec(x, yi, mu1, sigma1, mu2, sigma2, alfa1, alfa2)
%function Prob = CalcPyVec(x, yi, mu1, sigma1, mu2, sigma2, alfa1, alfa2)
%
%Description:
% claculate the posterior probabilities
%
%Input:
% x - entery vector. 1XN (N any number)
% yi - which class to calculate for? a scalar.
% mu1 - mean of class 1. a scalar.
% mu2 - mean of class 2. a scalar.
% sigma1 - std of class 1. a scalar.
% sigma2 - std of class 2. a scalar.
% alfa1 - prior of class 1. a scalar.
% alfa2 - prior of class 2. a scalar.

%calculate the PDF
PVec1 = 1 / sqrt(2*pi*sigma1) * exp(-(x-mu1).^2 / (2*sigma1));
PVec2 = 1 / sqrt(2*pi*sigma2) * exp(-(x-mu2).^2 / (2*sigma2));

SummerVec = alfa1 * PVec1 + alfa2 * PVec2;

%calcualte posterior
if yi == 1
    Prob = alfa1 * PVec1 ./ SummerVec;
else
    Prob = alfa2 * PVec2 ./ SummerVec;
end
