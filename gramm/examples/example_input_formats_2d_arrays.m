%%
% For a more matlab-like solution, Y and X can be 2D arrays, rows will automatically be considered as groups.
% as a consequence grouping data (color, etc...) are provided for the rows !
Y=[1 2 3 4 5;2 3 4 5 6; 3 4 5 6 7];
X=[1 2 3 4 5; 0 1 2 3 4; -1 0 1 2 3];
C=[1 2 2];
figure
g13=gramm('x',X,'y',Y,'color',C);
g13.geom_line();
g13.draw();