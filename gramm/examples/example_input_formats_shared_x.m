%%
% If all X values are the same, it's possible to provide X as a single row
X=[1 2 3 4 5];
Y=[1 2 3 4 5;2 3 4 5 6; 3 4 5 6 7];
C=[1 2 2];
figure
g14=gramm('x',X,'y',Y,'color',C);
g14.geom_line();
g14.draw();
