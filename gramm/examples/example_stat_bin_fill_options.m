% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
load example_data;

%% Example of alternative |'fill'| options
%
% * |'face'|
% * |'all'|
% * |'edge'|
% * |'transparent'|

%Create variables
x=randn(1200,1)-1;
cat=repmat([1 1 1 2],300,1);
x(cat==2)=x(cat==2)+2;

clear g6
g6(1,1)=gramm('x',x,'color',cat);
g6(1,2)=copy(g6(1));
g6(1,3)=copy(g6(1));
g6(2,1)=copy(g6(1));
g6(2,2)=copy(g6(1));
g6(2,3)=copy(g6(1));


g6(1,1).stat_bin('fill','face');
g6(1,1).set_title('''face''');

g6(1,2).stat_bin('fill','transparent');
g6(1,2).set_title('''transparent''');

g6(1,3).stat_bin('fill','all');
g6(1,3).set_title('''all''');

g6(2,1).stat_bin('fill','edge');
g6(2,1).set_title('''edge''');

g6(2,2).stat_bin('geom','stairs','fill','transparent');
g6(2,2).set_title('''transparent''');


g6(2,3).stat_bin('geom','line','fill','all');
g6(2,3).set_title('''all''');

g6.set_title('''fill'' options for stat_bin()');

figure;
g6.draw();