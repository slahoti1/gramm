% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
addpath('sample_data/','gramm/');
load example_data;

%% Using different input formats for x and y (1D arrays, cells of arrays, 2D arrays)
% Standard ggplot-like input (arrays for everything)
% Note the continuous line connecting all blue data points, gramm can't know
% when to start a new line in this case
Y=[1 2 3 4 5 2 3 4 5 6 3 4 5 6 7];
X=[1 2 3 4 5 0 1 2 3 4 -1 0 1 2 3];
C=[1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
figure
g11=gramm('x',X,'y',Y,'color',C);
g11.geom_line();
g11.draw();