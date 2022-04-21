function gfigure(x_la,y_la,tit,gca,varargin)
% INPUTS 
% x_la -> X axis label
% y_la -> Y axis label
% (optional) z_la -> Z axis label
% tit -> title

% gca -> axis handle
afs=8; % default axis font
fs=20;
% if(~isempty(varargin)) % non zero
%     fs=varargin{1}; % text font
%     if(length(varargin)>1)
%     afs=varargin{2}; % axis font
%     end
% else
%     fs = 20;
% end



iFontSize = fs;
strFontUnit = 'points'; % [{points} | normalized | inches | centimeters | pixels]
strFontName = 'Times'; % [Times | Courier | ] TODO complete the list
strFontWeight = 'bold'; % [light | {normal} | demi | bold]
%strFontAngle = 'normal'; % [{normal} | italic | oblique] ps: only for axes
strInterpreter = 'latex'; % [{tex} | latex]
%fLineWidth = 2.0; % width of the line of the axes
% axis tight;
if(x_la)
xlabel(x_la, ...
'FontName', strFontName, ...
'FontUnit', strFontUnit, ...
'FontSize', iFontSize, ...
'FontWeight', strFontWeight, ...
'Interpreter', strInterpreter);
end
ylabl=ylabel(y_la, ...
'FontName', strFontName, ...
'FontUnit', strFontUnit, ...
'FontSize', iFontSize, ...
'FontWeight', strFontWeight, ...
'Interpreter', strInterpreter);
%'Rotation',yrot);
% if(yshft)
% set(ylabl, 'Units', 'Normalized', 'Position', [-0.1, 0.5, 0]);
% end

if(~isempty(varargin)) % non zero
    z_la=varargin{1}; % for Z axis
else
    z_la=0;
end

if(z_la)
    zlabel(z_la, ...
'FontName', strFontName, ...
'FontUnit', strFontUnit, ...
'FontSize', iFontSize, ...
'FontWeight', strFontWeight, ...
'Interpreter', strInterpreter);
end

% It was observed 'title' stopped 'colorbar' to appear to the side of
% figure

if(tit)
title(tit, ...
'FontName', strFontName, ...
'FontUnit', strFontUnit, ...
'FontSize', iFontSize, ...
'FontWeight', strFontWeight, ...
'Interpreter', strInterpreter);
end
set(gca,'FontWeight','normal'); % making axes font bold
set(gca,'FontSize',afs); % previously 12