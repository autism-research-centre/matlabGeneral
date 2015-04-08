function [ standard_error ] = sem( A, dim )
%SEM standard_error = sem(A)
%   Calculates the Standard Error of the Mean by working out the standard
%   deviation and dividing by the root of N

if nargin < 2
    if size(A, 1)>1
        dim = 1;
    elseif size(A, 2)>1
        dim = 2;
    elseif size(A, 3)>1
        dim = 3;
    end
    
end

stdev = std(A, [], dim);
standard_error = stdev / sqrt(size(A, dim));

end

