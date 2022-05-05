function [Mu, Sigma, Beta] = EvalStat(x, BetaFlag)
%function [Mu, Sigma, Beta] = EvalStat(x, BetaFlag)
%
%Description:
% This function evaluate distribution parameters according to statistical
% evaluation
%
%Input:
% x - vector of measurements
% BetaFlag - A flag. If set than estimate Beta. Otherwaise Beta=2
%
%Output:
% Mu - mean of data
% Sigma - scale of data
% Beta - factor of data
global testInpFid testOutFid;

%average
Mu = mean(x);
%variance
Var = var(x)+eps;

if BetaFlag
    %kurtosious
    Kurt = kurtosis(x);
    if isnan(Kurt)
        Kurt = 1;
    end
    %calc beta numerically
    BetaVec = 1:6;
    %general gaussian distribution
    PosKurtosisVec = gamma(5./BetaVec).*gamma(1./BetaVec)./(gamma(3./BetaVec).^2);
    [~, loc] = min(abs(PosKurtosisVec - Kurt));
    Beta = BetaVec(loc);
else
    %normal gaussian
    Beta = 2;
end

%calc sigma
Sigma = sqrt(Var * gamma(1/Beta) / gamma(3/Beta) /  2);

% Debug prints
% inp_str = sprintf('%f,', x);
% fprintf(testInpFid, "%s\n", inp_str(1:end-1)); % strip final comma
% fprintf(testOutFid, "%f,%f\n",Mu, Sigma);
end