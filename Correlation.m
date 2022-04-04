%{ 
    Pearson Correlation Coefficient for Sample
    Input: 
        x (num[]): variable 1
        y (num[]): variable 2
    Output:
        r (num): correlation coefficient
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #3, Channel Estimation - Class II
%}
function [r] = Correlation(x, y)
    X = x - mean(x);
    Y = y - mean(y);
    r = sum(X .* Y) / (sqrt(sum(X.^2)) * sqrt(sum(Y.^2)));
end