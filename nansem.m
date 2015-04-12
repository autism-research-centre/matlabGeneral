function [ standard_error, ignored_values ] = nansem( A, dim )
%SEM standard_error = sem(A)
%   Calculates the Standard Error of the Mean by working out the standard
%   deviation and dividing by the root of N. This version of the function
%   ignores NaN values (and returns how many were NaN in an optional second
%   output

if nargin < 2
    if size(A, 1)>1
        dim = 1;
    elseif size(A, 2)>1
        dim = 2;
    elseif size(A, 3)>1
        dim = 3;
    end
    
end

ignored_values = isnan(A);

A = A(~ignored_values);

stdev = std(A, [], dim);
standard_error = stdev / sqrt(size(A, dim));

end