function pipeSchematicGeneration(x,y,rOuter, rInner, Case)
% Purpose of function: 
    % The function was created to make 3 circles that will be filled with
    % different color. The radiuses will be shown with arrows. Additionally
    % pressure distribution will be shown on the inner surface of the
    % circles.
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
%   case - what needs to be plotted
    % case 1 - only Inner pressure for single layer
    % case 2 - only Contact pressure for 2 layer system
    % case 3 - Inner and Contact pressure for 2 layer system

figure
axis([-(rOuter+0.5) (rOuter+0.5) -(rOuter+0.5) (rOuter+0.5)])
hold on
th = 0:pi/50:2*pi;

% Generate Outer circle
filledCircle(x,y,rOuter,th,'r')

% Generate Contact circle
if strcmp(Case, 'case 2') || strcmp(Case, 'case 3')
    rContact = (rOuter+rInner)/2;
    filledCircle(x,y,rContact,th,'g')
end

% Generate Inner circle
filledCircle(x,y,rInner,th,'w')

% Generate Outer circle radius arrow and adds a notation
arrowTo([0 0], [3.438 0.6558], 'Ro')

% Generate Contact circle radius arrow and adds a notation
if strcmp(Case, 'case 2')
    arrowTo([0 0], [2.906 -0.7461], 'Rc')
end

% Generate Inner circle radius arrow and adds a notation
arrowTo([0 0], [1.594 -1.926], 'Ri')

% Generate arrows representing the pressure present for the different cases
% Inner pressure only
if strcmp(Case, 'case 1')
    PressureArrow(x, y, 2.25, 2.5, 'Pi')
% Contact Pressure only
elseif strcmp(Case, 'case 2')
    % Contact Pressure from inner
    PressureArrow(x, y, 2.75, 3, 'Pc')
    % Contact Pressure from outer
    PressureArrow(x, y, 3.25, 3, 'Pc')
% Inner and contact pressure
elseif strcmp(Case, 'case 3')
    PressureArrow(x, y, 2.25, 2.5, 'Pi')
    PressureArrow(x, y, 2.75, 3, 'Pc')
    PressureArrow(x, y, 3.25, 3, 'Pc')
end

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

% Generates the pressure representing arrows
function PressureArrow(x, y, innerRad, outerRad, pressure)
th1 = -pi/4:pi/25:pi/4;
xunitInner = innerRad * cos(th1) + x;
yunitInner = innerRad * sin(th1) + y;
xunitOuter = outerRad * cos(th1) + x;
yunitOuter = outerRad * sin(th1) + y;
dpX = xunitOuter-xunitInner;
dpY = yunitOuter-yunitInner;
quiver(xunitInner,yunitInner,dpX,dpY,0, 'Color', 'k', 'LineWidth', 0.75)
text(innerRad-0.25, y, pressure, 'FontSize', 14)
end