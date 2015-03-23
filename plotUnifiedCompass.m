% Matlab seems to have some issues with drawing compass plot and then
% afterwards changing the axes limits, this is a 'simple' work-around.
% 
% First we draw a fake compass-plot with the desired axes sizes, then we
% draw the real one, then remove the fake one
%
%% © R.A.I. Bethlehem 2013

function [] = drawUnifiedCompass(dir, amp, samp)

% not always appliccable but for my data I first need to change the
% directions to radians
dir = dir * pi/180;
% then convert the direction and amplitude to cartesian coordinates
[x,y] = pol2cart(dir,amp);

% then we first draw a fake compass
x_fake=[0 23 0 -23];
y_fake=[23 0 -23 0];
h_fake=compass(x_fake,y_fake);

% keep it on
hold on;
% draw the real one
h=compass(x,y);
% remove fake one
set(h_fake,'Visible','off')

% draw in standard deviation
samp = amp+samp;
[xa,ya] = pol2cart(dir,samp);
compass(xa,ya,'-.r')

end
