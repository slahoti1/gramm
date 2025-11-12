%%
Y=[1 2 3 4 5 2 3 4 5 6 3 4 5 6 7];
X=[1 2 3 4 5 0 1 2 3 4 -1 0 1 2 3];
C=[1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
% Adding a group variable solves the problem in a ggplot-like way
G=[1 1 1 1 1 2 2 2 2 2 3 3 3 3 3];
figure
g12=gramm('x',X,'y',Y,'color',C,'group',G);
g12.geom_line();
g12.draw();