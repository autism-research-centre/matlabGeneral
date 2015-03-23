%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab analyses function for calculating signal detection theorie values
% from both z-scores and regular scores
%
% Takes in two single vector arrays with equal dimensions, hits and false
% alarms
%
%% © R.A.I. Bethlehem 2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pr Bias dPrime zBeta] = dprime(Hit,False_Alarm)

%% Sensivity (d')
Pr = Hit-False_Alarm;

%% Bias
Bias = False_Alarm./((1-Hit)+False_Alarm);

%% Convert to Z scores
% zHit = zscore(Hit);
% zFA = zscore(False_Alarm);
zHit = norminv(Hit,0,1);
zFA = norminv(False_Alarm,0,1);

%% Calculate d-prime for z-scores
dPrime = zHit - zFA ;

%% Calculate beta
zBeta = zHit./zFA;
