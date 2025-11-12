%%
% With cells of arrays, there is the opportunity to have different lengths
% for different groups
Y={[1 2 3 4 5] [3 4 5] [3 4 5 6 7]};
X={[1 2 3 4 5] [1 2 3] [-1 0 1 2 3]};
C=[1 2 2];
figure
g17=gramm('x',X,'y',Y,'color',C);
g17.geom_line();
g17.draw();