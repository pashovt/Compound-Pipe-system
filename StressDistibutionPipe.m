function StressDistibutionPipe(x,y,rOuter,rInner, Case)
% Purpose of function: 
    % The function was created a system representation of cylinders that 
    % will be filled with different color. The X and Y axes will be shown 
    % with arrows. Additionally stress distribution will be shown for
    % Radial and Hoop stress.
    %
    % The main purpose is to create a schematic that represents compound
    % pipe system that has 2 pipes (press fitted into each other).
%
% How to call the function
%   circle(0,0,3.5,2.5,'case 1')
%
% Parameters
%   x - origin point in X direction
%   y - origin point in Y direction
%   rOuter - outer radius of the system
%   rOuter - inner radius the system
%   case - represent a specific dataset for the stresses present
    % case 1 - single layer system 
        % RadialStress = [-1.0000; 0];
        % HoopStress = [3.0832; 2.0832];
    % case 2 - 2 layer system
        % RadialStress = [0; -1; -1.6];
        % HoopStress = [-6.54; -5.54; -4.94];

% Generated Curves for stress distribution
% Case 1
if strcmp(Case, 'case 1')
    % used to reduce the values in order for them to fit onto of the
    % cylinder scale
    devider = 3;
    % Radial Stress points
    yRadial = [-1.0000; -0.2; 0]/devider;
    % Inner point
    % The algorythm is based on the revers function of "r * cos(t) + x" for
    % a specified input value
    t = asin((yRadial(1) - y)/rInner);
    xpointInner = rInner * cos(t) + x;
    % Outer point
    t = asin((yRadial(length(yRadial)) - y)/rOuter);
    xpointOuter = rOuter * cos(t) + x;
    midPoint = 0.67*(xpointOuter-xpointInner)+xpointInner;
    % generated radial stress points
    xRadial = [xpointInner; midPoint; xpointOuter]; % [2.2913; 3.1 2.6; 3.5000];
    [XRadialPoints, YRadialPoints] = CurveDataPoints(xRadial, yRadial);
    % plot(XRadialPoints, YRadialPoints, 'g')
    % Hoop
    % dataPoints1.HoopStress = [3.0832; 2.0832];
    xHoop = [rInner; 3;  rOuter];
    yHoop = [3.0832; 2.4; 2.0832]/devider; % - 2 from the actual value
    [XHoopPoints, YHoopPoints] = CurveDataPoints(xHoop, yHoop);
    % plot(XHoopPoints, YHoopPoints, 'g')
% Case 2
elseif strcmp(Case, 'case 2')
    devider = 5;
    % Radial Stress
    yRadial = [-1; -1.45; -1.6]/devider;
    % Inner point
    t = asin((yRadial(1) - y)/rInner);
    xpointInner = rInner * cos(t) + x;
    % Outer point
    t = asin((yRadial(length(yRadial)) - y)/rOuter);
    xpointOuter = rOuter * cos(t) + x;
    midPoint = 0.62*(xpointOuter-xpointInner)+xpointInner;
    xRadial = [xpointInner; midPoint; xpointOuter]; % [2.2913; 2.8; 3.1129];
    [XRadialPoints, YRadialPoints] = CurveDataPoints(xRadial, yRadial);
    XRadialPoints = [0 XRadialPoints];
    YRadialPoints = [-1/devider YRadialPoints];
    % plot(XRadialPoints, YRadialPoints, 'g')
    % Hoop
    % dataPoints2.HoopStress = [-6.54 -5.54 -4.94];
    xHoop = [rInner; 3;  rOuter];
    yHoop = [-6.54; -5.54; -4.94]/devider; % [-1.54; -0.54; 0.06] -5 from the actual value
    [XHoopPoints, YHoopPoints] = CurveDataPoints(xHoop, yHoop);
    % plot(XHoopPoints, YHoopPoints, 'g')
end

% Main figure properties
figure
axis([-(rOuter+0.5) (rOuter+0.5) -(rOuter+0.5) (rOuter+0.5)])
hold on
th = -pi/2:pi/25:pi/2;

% Cylinder layer generation
% Outer circle
filledCircle(x,y,rOuter,th,'r')

% Contact circle
if strcmp(Case, 'case 2')
    rContact = (rOuter+rInner)/2;
    filledCircle(x,y,rContact,th,'g')
end

% Inner circle
filledCircle(x,y,rInner,th,'w')

% Axis generation
% X axis
arrowTo([0 0], [rOuter+0.5 0], 'X')
% Y axis
arrowTo([0 -(rOuter+0.5)], [0 rOuter+0.5], 'Y')

% Finds the middle point inside the matrix
mRadPoint = ceil(length(XRadialPoints)/2);
mHoopPoint = ceil(length(XHoopPoints)/2);
% plots the radial stress curve
plot(XRadialPoints, YRadialPoints, 'k', 'LineWidth', 1.4)
% adds the RADIAL as a text variable on the graph
text(XRadialPoints(mRadPoint),YRadialPoints(mRadPoint)-0.25, 'Radial', 'FontSize', 14)
% plots the hoop stress curve
plot(XHoopPoints, YHoopPoints, 'k', 'LineWidth', 1.4)
% adds the HOOP as a text variable on the graph
text(XHoopPoints(mHoopPoint),YHoopPoints(mHoopPoint)-0.25, 'Hoop', 'FontSize', 14)

% changes the y axis number by a multiple of devider variable
set(gca,'YTickLabel',(-4:1:4)*devider)
% change the viewed location of the schematic
axis([0 8 -4 4])
end

% Create a circle and fills it
function filledCircle(x,y,r,th,color)
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
fill(xunit, yunit, color)
end

% Renerates arrow and adds a notation
function arrowTo(p1, p2, radius)
dp = p2-p1; % Difference
quiver(p1(1),p1(2),dp(1),dp(2),0, 'Color', 'k', 'LineWidth', 1)
text(p2(1),p2(2), radius, 'FontSize', 14)
end

% Outputs the datapoints that are needed to generate the stress data curve
% without returning the equation
function [XRadialPoints, YRadialPoints] = CurveDataPoints(xpoints, ypoints)
fRadial = fit(xpoints, ypoints, 'poly2');
figure;
plotData = plot(fRadial);
XRadialPoints = plotData.XData;
YRadialPoints = plotData.YData;
close figure 1
end