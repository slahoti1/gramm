% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
addpath('sample_data/','gramm/');
load example_data;

%% Options for dodging and spacing graphic elements in |stat_summary()| and |stat_boxplot()|
% |stat_summary()| and |stat_boxplot()|, as well as |stat_bin()|, use a pair of options for
% setting the width of graphical elements (|'width'|) and setting how
% elements of different colors can be dodged to the side to avoid overlap
% (|'dodge'|)

%Create data
x=repmat(1:10,1,100);
catx=repmat({'A' 'B' 'C' 'F' 'E' 'D' 'G' 'H' 'I' 'J'},1,100);
y=randn(1,1000)*3;
c=repmat([1 1 1 1 1 1 1 1 1 1    1 1 2 2 2 2 2 3 2 2     2 1 1 2 2 2 2 3 2 3     2 1 1 2 2 2 2 2 2 2],1,25);
y=2+y+x+c*0.5;


clear g
g(1,1)=gramm('x',catx,'y',y,'color',c);
g(2,1)=copy(g(1));
g(3,1)=copy(g(1));
g(4,1)=copy(g(1));
g(5,1)=copy(g(1));


g(1,1).stat_boxplot();
g(1,1).geom_vline('xintercept',0.5:1:10.5,'style','k-');
g(1,1).set_title('''width'',0.6,''dodge'',0.7 (Default)');

g(2,1).stat_boxplot('width',0.5,'dodge',0);
g(2,1).geom_vline('xintercept',0.5:1:10.5,'style','k-');
g(2,1).set_title('''width'',0.5,''dodge'',0');

g(3,1).stat_boxplot('width',1,'dodge',1);
g(3,1).geom_vline('xintercept',0.5:1:10.5,'style','k-');
g(3,1).set_title('''width'',1,''dodge'',1');

g(4,1).stat_boxplot('width',0.6,'dodge',0.4);
g(4,1).geom_vline('xintercept',0.5:1:10.5,'style','k-');
g(4,1).set_title('''width'',0.6,''dodge'',0.4');

g(5,1).facet_grid([],c);
g(5,1).stat_boxplot('width',0.5,'dodge',0,'notch',true);
g(5,1).set_title('''width'',0.5,''dodge'',0,''notch'',true');

g.set_title('Dodge and spacing options for stat_boxplot()');

figure;
g.draw();

% With |stat_summary()|, |'width'| controls the width of bars and error bars.

clear g
g(1,1)=gramm('x',catx,'y',y,'color',c);
g(2,1)=copy(g(1));
g(3,1)=copy(g(1));
g(4,1)=copy(g(1));
g(5,1)=copy(g(1));

g(1,1).stat_summary('geom',{'bar' 'black_errorbar'},'setylim',true);
g(1,1).geom_vline('xintercept',0.5:1:10.5,'style','k-');
g(1,1).set_title('Default dodging with ''geom'',''bar''');

g(2,1).stat_summary('geom',{'bar' 'black_errorbar'},'dodge',0.7,'width',0.7);
g(2,1).set_title('''dodge'',0.7,''width'',0.7');
g(2,1).geom_vline('xintercept',0.5:1:10.5,'style','k-');

g(3,1).stat_summary('geom',{'area'});
g(3,1).set_title('''geom'',''area''');
g(3,1).set_title('No dodging with ''geom'',''area''');

g(4,1).stat_summary('geom',{'point' 'errorbar'},'dodge',0.3,'width',0.5);
g(4,1).set_title('''dodge'',0.3,''width'',0.5');
g(4,1).geom_vline('xintercept',0.5:1:10.5,'style','k-');

g(5,1).facet_grid([],c);
g(5,1).stat_summary('geom',{'bar' 'black_errorbar'},'width',0.5,'dodge',0);
g(5,1).set_title('''width'',0.5,''dodge'',0');

g.set_title('Dodge and width options for stat_summary()');

figure;
g.draw();
