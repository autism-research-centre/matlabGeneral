%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab function to plot 3 vectors as a circular plot using griddata
%
%% © R.A.I. Bethlehem 2012
%
% Version History:
%
% Richard Bethlehem
% 02-09-2012: Created basic structure & experimented with pcolor functionality for plotting
% 04-09-2012: Implemented meshrgid to create a circular and griddata to fit
%             the data to this grid

function [] = CircularPlot(x,y,z,colour)

% check the input and restore to defaults if there is a mistake 
if isempty(colour), colour = 'Gray', end;
if isempty(colour), fprintf('You have not entered a colour, default is greyscale\n'), end;

% transpose all matrices
x = x';
y = y';
z = z';


%% Plotting a circular grid:
% % input is 3 vectors
% x = angle; % in radials 
% y = radius; % in radials
% z = strength; % how bright do you want it?

linespacing = length(x);

%% Create a circular grid
[r, theta] = meshgrid(0:.1:1, linspace(0,2*pi,linespacing));
% create the cartesian coordinates for this grid
[x2, y2] = pol2cart(theta, r);

%% Fit the data to the circular grid
z2 = griddata(x,y,z,x2,y2);

%% Plot it
figure;
subplot(2,1,1);
scatter(x,y,50,z, 'filled');
axis equal tight;
subplot(2,1,2);
pcolor(x2,y2,z2);
shading flat;
colormap(colour);
axis equal tight;

end
