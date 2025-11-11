% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
addpath('sample_data/','gramm/');
load example_data;

%% Options for creating histograms with stat_bin() 
% Example of different |'geom'| options:
%
% * |'bar'| (default), where color groups are side-by-side (dodged)
% * |'stacked_bar'|
% * |'line'|
% * |'overlaid_bar'|
% * |'point'|
% * |'stairs'|


%Create variables
x=randn(1200,1)-1;
cat=repmat([1 1 1 2],300,1);
x(cat==2)=x(cat==2)+2;

clear g5
g5(1,1)=gramm('x',x,'color',cat);
g5(1,2)=copy(g5(1));
g5(1,3)=copy(g5(1));
g5(2,1)=copy(g5(1));
g5(2,2)=copy(g5(1));
g5(2,3)=copy(g5(1));

g5(1,1).stat_bin(); %by default, 'geom' is 'bar', where color groups are side-by-side (dodged)
g5(1,1).set_title('''bar'' (default)');

g5(1,2).stat_bin('geom','stacked_bar'); %Stacked bars option
g5(1,2).set_title('''stacked_bar''');

g5(2,1).stat_bin('geom','line'); %Draw lines instead of bars, easier to visualize when lots of categories, default fill to edges !
g5(2,1).set_title('''line''');

g5(2,2).stat_bin('geom','overlaid_bar'); %Overlaid bar automatically changes bar coloring to transparent
g5(2,2).set_title('''overlaid_bar''');

g5(1,3).stat_bin('geom','point'); 
g5(1,3).set_title('''point''');


g5(2,3).stat_bin('geom','stairs'); %Default fill is edges
g5(2,3).set_title('''stairs''');

g5.set_title('''geom'' options for stat_bin()');

figure;
g5.draw();