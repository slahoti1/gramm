% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
addpath('sample_data/','gramm/');
load example_data;

%% Examples of other histogram-generation options
%
% * Default binning
% * |'normalization','probability'|
% * |'normalization','cumcount'|
% * |'normalization','cdf'|
% * |'edges',-1:0.5:10|
% * |'normalization','countdensity'| and custom edges

%Create variables
x=randn(1200,1)-1;
cat=repmat([1 1 1 2],300,1);
x(cat==2)=x(cat==2)+2;

clear g7
g7(1,1)=gramm('x',x,'color',cat);
g7(1,2)=copy(g7(1));
g7(1,3)=copy(g7(1));
g7(2,1)=copy(g7(1));
g7(2,2)=copy(g7(1));
g7(2,3)=copy(g7(1));

g7(1,1).stat_bin('geom','overlaid_bar'); %Default binning (30 bins)

%Normalization to 'probability'
g7(2,1).stat_bin('normalization','probability','geom','overlaid_bar');
g7(2,1).set_title('''normalization'',''probability''','FontSize',10);

%Normalization to cumulative count
g7(1,2).stat_bin('normalization','cumcount','geom','stairs');
g7(1,2).set_title('''normalization'',''cumcount''','FontSize',10);

%Normalization to cumulative density
g7(2,2).stat_bin('normalization','cdf','geom','stairs');
g7(2,2).set_title('''normalization'',''cdf''','FontSize',10);

%Custom edges for the bins
g7(1,3).stat_bin('edges',-1:0.5:10,'geom','overlaid_bar');
g7(1,3).set_title('''edges'',-1:0.5:10','FontSize',10);

%Custom edges with non-constand width (normalization 'countdensity'
%recommended)
g7(2,3).stat_bin('geom','overlaid_bar','normalization','countdensity','edges',[-5 -4 -2 -1 -0.5 -0.25 0 0.25 0.5  1 2 4 5]);
g7(2,3).set_title({'''normalization'',''countdensity'',' '''edges'',' '[-5 -4 -2 -1 -0.5 -0.25 0 0.25 0.5  1 2 4 5]'},'FontSize',10);

g7.set_title('Other options for stat_bin()');

figure;
g7.draw();