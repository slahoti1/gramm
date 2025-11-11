% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
addpath('sample_data/','gramm/');
load example_data;

%% Customizing color maps with set_color_options()
% With the method set_color_options(), automatic color generation for
% color and lightness groups can be tweaked

%Default: LCH-based colormap with hue variation
clear g
g(1,1)=gramm('x',cars.Origin,'y',cars.Horsepower,'color',cars.Origin);
g(1,1).stat_summary('geom',{'bar'},'dodge',0);
g(1,2)=copy(g(1));
g(1,3)=gramm('x',cars.Origin,'y',cars.Horsepower,'lightness',cars.Origin);
g(2,1)=copy(g(1));
g(2,2)=copy(g(1));
g(2,3)=copy(g(1));



g(1,1).set_title('Default LCH (''color'' groups)','FontSize',12);

%Possibility to change the hue range as well as lightness and chroma of
%the LCH-based colormap
g(1,2).set_color_options('hue_range',[-60 60],'chroma',40,'lightness',90);
g(1,2).set_title('Modified LCH (''color'' groups)','FontSize',12);

%Possibility to change the lightness and chroma range of the LCH-based
%colormap when a 'lightness' variable is given
g(1,3).stat_summary('geom',{'bar'},'dodge',0);
g(1,3).set_color_options('lightness_range',[0 95],'chroma_range',[0 0]);
g(1,3).set_title('Modified LCH (''lightness'' groups)','FontSize',12);

%Go back to Matlab's defauls colormap
g(2,1).set_color_options('map','matlab');
g(2,1).set_title('Matlab 2014B+ ','FontSize',12);

%Brewer colormap 1
g(2,2).set_color_options('map','brewer1');
g(2,2).set_title('Color Brewer 1','FontSize',12);

%Brewer colormap 2
g(2,3).set_color_options('map','brewer2');
g(2,3).set_title('Color Brewer 2','FontSize',12);

%Some methods can be called on all objects at the same time !
g.axe_property('YLim',[0 140]);
g.axe_property('XTickLabelRotation',60); %Should work for recent Matlab versions
g.set_names('x','Origin','y','Horsepower','color','Origin','lightness','Origin');
g.set_title('Colormap customizations examples');

figure
g.draw();
