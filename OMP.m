%{ 
    Orthogonal Matching Pursuit Algorithm for Channel Estimation
    Input: 
        A (num[,]): transmitted signal
        b (num[]): received signal (through channel)
    Output:
        x (num[]): channel estimate
    Course: Advanced Acoustic  Signal Processing Techniques, 
            Lecture #3, Channel Estimation - Class II
%}

function [x] = OMP(A, b)
    % Initialization of residue vec and index set
    r = b;
    Lambda = [];

    % Normalize columns and make A full rank
    normc(A);
    A = unique(A', 'rows')';

    % Initialize sparseness
    k = 1;

    % Main loop
    while k <= sprank(A)/2 % kMax (Davies and Elder, Donoho and Elad)
        % Find column of A with max abs correlation to r
        lmb = 0;
        MaxCorr = 0;
        for Col=1:size(A,2)
            AbsCorr = abs(max(xcorr(A(:,Col),r)));
            if AbsCorr > MaxCorr
                MaxCorr = AbsCorr;
                lmb = Col;
            end
        end

        % Augment index set
        Lambda = [Lambda lmb];

        % Helper definitions
        A_Lambda = A(:,Lambda);
        A_lmb = A(:,lmb);

        % Obtain k-th estimate - LS solution
        % PROB: A_Lambda is n-by-1, A_Lambda' 1-by-n -> invalid dims for *!!
        x = (A_Lambda \ (A_Lambda*A_Lambda')) * b;

        % Compute new b estimate and upated residue
        bkHat = A_lmb * x(k); 
        r = r - bkHat;

        % Increment sparseness counter
        k = k + 1;
    end

    % Fill with zeros out of sparsity
    padding = zeros(size(b));
    padding(1:k-1) = x;
    x = padding;
end