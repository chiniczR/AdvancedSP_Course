function [EstMu1, EstMu2, EstSigma1, EstSigma2, EstAlfa1, EstAlfa2, EstP1, EstP2] = ...
    ClassifyMeasurmentsEM3(x, InitMu1, InitMu2, InitSigma1, InitSigma2, InitAlfa1, InitAlfa2, IterateNum)
%function [EstMu1, EstMu2, EstSigma1, EstSigma2, EstAlfa1, EstAlfa2] = ...
%   ClassifyMeasurmentsEM3(x, InitMu1, InitMu2, InitSigma1, InitSigma2, InitAlfa1, InitAlfa2, IterateNum)
%
%Desciption:
% This function cluster measurmeents by the EM algorithm
%
%Input:
% x - vector of mreeasutrments. 1XN (N any number)
% InitMu1 - initial average for class 1. A scalar
% InitMu2 - initial average for class 2. A scalar
% InitSigma1 - initial std for class 1. A scalar
% InitSigma2 - initial std for class 2. A scalar
% InitAlfa1 - initial prior for class 2. A scalar
% InitAlfa2 - initial prior for class 2. A scalar
% IterateNum - number of EM iterations
%
%Output:
% EstMu1 - estimated average for class 1. A scalar
% EstMu2 - estimated average for class 2. A scalar
% EstSigma1 - estimated std for class 1. A scalar
% EstSigma2 - estimated std for class 2. A scalar
% EstAlfa1 - estimated prior for class 2. A scalar
% EstAlfa2 - estimated prior for class 2. A scalar

Alfa1Vec = zeros(1, IterateNum);
Alfa2Vec = zeros(1, IterateNum);
Mu1Vec = zeros(1, IterateNum);
Mu2Vec = zeros(1, IterateNum);
Sigma1Vec = zeros(1, IterateNum);
Sigma2Vec = zeros(1, IterateNum);

%calc distribution according to estimated classification
Mu1Vec(1) = InitMu1;
Sigma1Vec(1) = InitSigma1;
Mu2Vec(1) = InitMu2;
Sigma2Vec(1) = InitSigma2;
Alfa1Vec(1) = InitAlfa1;
Alfa2Vec(1) = InitAlfa2;

%run EM iteration
for IterateInd = 2: IterateNum
    %classify current measure according to likelihood probability
    
    %calculate posterior probabilities for each class
    Py1 = CalcPyVec(x, 1, Mu1Vec(IterateInd-1), Sigma1Vec(IterateInd-1), Mu2Vec(IterateInd-1), Sigma2Vec(IterateInd-1), Alfa1Vec(IterateInd-1), Alfa2Vec(IterateInd-1));
    Py2 = CalcPyVec(x, 2, Mu1Vec(IterateInd-1), Sigma1Vec(IterateInd-1), Mu2Vec(IterateInd-1), Sigma2Vec(IterateInd-1), Alfa1Vec(IterateInd-1), Alfa2Vec(IterateInd-1));
    SummerForAlfa1 = sum(Py1);
    SummerForAlfa2 = sum(Py2);
    SummerForMu1 = sum(x .* Py1);
    SummerForMu2 = sum(x .* Py2);
        
    %calc distribution according to estimated classification
    Alfa1Vec(IterateInd) = SummerForAlfa1 / length(x);
    Alfa2Vec(IterateInd) = SummerForAlfa2 / length(x);
    
    %calculate average by distributions
    Mu1Vec(IterateInd) = SummerForMu1 / SummerForAlfa1;
    Mu2Vec(IterateInd) = SummerForMu2 / SummerForAlfa2;
    
    %calculate std by distributions
    SummerForSigma1 = sum((x - Mu1Vec(IterateInd)).^2 .* Py1);
    SummerForSigma2 = sum((x - Mu2Vec(IterateInd)).^2 .* Py2);
        
    Sigma1Vec(IterateInd) = SummerForSigma1 / SummerForAlfa1;
    Sigma2Vec(IterateInd) = SummerForSigma2 / SummerForAlfa2;
end

%go by the last iteration
EstMu1 = Mu1Vec(end);
EstMu2 = Mu2Vec(end);
EstSigma1 = Sigma1Vec(end);
EstSigma2 = Sigma2Vec(end);
EstAlfa1 = Alfa1Vec(end);
EstAlfa2 = Alfa2Vec(end);
EstP1 = Py1;
EstP2 = Py2;