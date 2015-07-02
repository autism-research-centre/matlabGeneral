function [ outliers ] = sdoutliers( A, dim)
%SDOUTLIERS Summary of this function goes here
%   Detailed explanation goes here

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
average = mean(A, dim);

outliers = false(size(A));

for iRows = 1:size(A', dim)
    if dim == 1
        outliers() = 
    elseif dim == 2
        
    end
end


end

