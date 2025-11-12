% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset));
load example_data;

%% Superimposing gramm plots with update(): Plotting all the data in the background of facets
%Inspired by https://drsimonj.svbtle.com/plotting-background-data-for-groups-with-ggplot2

load fisheriris.mat

clear g
figure;
%Create an histogram of all the data in the background (no facet_ is given yet)
g(1,1)=gramm('x',meas(:,2));
g(1,1).set_names('x','Sepal Width','column','');
g(1,1).stat_bin('fill','all'); %histogram
g(1,1).set_color_options('chroma',0,'lightness',75); %We make it light grey
g(1,1).set_title('Overlaid histograms');

%Create a scatter plot of all the data in the background (no facet_ is given yet)
g(2,1)=gramm('x',meas(:,2),'y',meas(:,1));
g(2,1).set_names('x','Sepal Width','column','','y','Sepal Length');
g(2,1).geom_point(); %Scatter plot
g(2,1).set_color_options('chroma',0,'lightness',75); %We make it light grey
g(2,1).set_point_options('base_size',6);
g(2,1).set_title('Overlaid scatter plots');

g.draw(); %Draw the backgrounds

g(1,1).update('color',species); %Add color with update()
g(1,1).facet_grid([],species); %Provide facets
g(1,1).stat_bin('dodge',0); %Histogram (we set dodge to zero as facet_grid makes it useless)
g(1,1).set_color_options(); %Reset to default colors
g(1,1).no_legend();
g(1,1).axe_property('ylim',[-2 30]); %We have to set y scale manually, as the automatic scaling from the first plot was forgotten

g(2,1).update('color',species); %Add color with update()
g(2,1).facet_grid([],species); %Provide facets
g(2,1).geom_point();
g(2,1).set_color_options();
g(2,1).no_legend();

%Set global axe properties
g.axe_property('TickDir','out','XGrid','on','Ygrid','on','GridColor',[0.5 0.5 0.5]);
%Draw the news elements
g.draw();
