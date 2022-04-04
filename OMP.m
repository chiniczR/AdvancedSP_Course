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

function [x] = OMP(A, b, n)
    % Initialization of residue vec and index set
    r = b;
    Lambda = [];

    % Normalize columns and make A full rank
    normc(A);
    A = unique(A', 'rows')';

    % Calculate mutual coherence of matrix A - naive, but still NOT working
    mu = 0;
    for iCol=1:size(A,2)
        for jCol=1:size(A,2)
            if iCol~=jCol
                ai = A(:,iCol);
                aj = A(:,jCol);
                % PROB: curr always one!!!
                Curr = max(xcorr(ai, aj)) / (norm(ai) * norm(aj));
                if Curr > mu
                    mu = Curr;
                end
            end
        end
    end

    % Initialize sparseness
    k = 1;

    % Maximum sparseness
    kMax = floor(1/2*mu); % PROB: always zero (since mu always one)!!!

    % Main loop
    while k <= kMax
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
        x = inv(A_Lambda*A_Lambda') * A_Lambda' * b;

        % Compute new b estimate and upated residue
        bkHat = A_lmb * x; 
        r = r - bkHat;

        % Increment sparseness counter
        k = k + 1;
    end
end