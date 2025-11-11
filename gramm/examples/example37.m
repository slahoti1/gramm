%%
% Similar results can be obtained with cells of arrays
Y={[1 2 3 4 5] [2 3 4 5 6] [3 4 5 6 7]};
X={[1 2 3 4 5] [0 1 2 3 4] [-1 0 1 2 3]};
C=[1 2 2];
figure
g15=gramm('x',X,'y',Y,'color',C);
g15.geom_line();
g15.draw();

Y={[1 2 3 4 5] [2 3 4 5 6] [3 4 5 6 7]};
X=[1 2 3 4 5];
figure
g16=gramm('x',X,'y',Y,'color',C);
g16.geom_line();
g16.draw();
