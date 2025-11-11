% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
addpath('sample_data/','gramm/');
load example_data;

%% Grouping options in gramm
% With gramm there are a lot ways to map groups to visual properties of
% plotted data, or even subplots.
% Providing grouping variables to change visual properties is done in the
% constructor call |gramm()|. Grouping variables that determine subplotting
% are provided by calls to the |facet_grid()| or |facet_wrap()| methods.
% Note that *all the mappings presented below can be combined*, i.e. it's
% possible to previde different variables to each of the options.
%
% In order to plot multiple, diferent gramm objects in the same figure, an array of gramm objects
% is created, and the |draw()| function called at the end on the whole array

clear g
g(1,1)=gramm('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
g(1,1).geom_point();
g(1,1).set_names('x','Horsepower','y','MPG');
g(1,1).set_title('No groups');


g(1,2)=gramm('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'color',cars.Cylinders);
g(1,2).geom_point();
g(1,2).set_names('x','Horsepower','y','MPG','color','# Cyl');
g(1,2).set_title('color');

g(1,3)=gramm('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'lightness',cars.Cylinders);
g(1,3).geom_point();
g(1,3).set_names('x','Horsepower','y','MPG','lightness','# Cyl');
g(1,3).set_title('lightness');

g(2,1)=gramm('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'size',cars.Cylinders);
g(2,1).geom_point();
g(2,1).set_names('x','Horsepower','y','MPG','size','# Cyl');
g(2,1).set_title('size');

g(2,2)=gramm('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'marker',cars.Cylinders);
g(2,2).geom_point();
g(2,2).set_names('x','Horsepower','y','MPG','marker','# Cyl');
g(2,2).set_title('marker');

g(2,3)=gramm('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5,'linestyle',cars.Cylinders);
g(2,3).geom_line();
g(2,3).set_names('x','Horsepower','y','MPG','linestyle','# Cyl');
g(2,3).set_title('linestyle');

g(3,1)=gramm('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
g(3,1).facet_grid(cars.Cylinders,[]);
g(3,1).geom_point();
g(3,1).set_names('x','Horsepower','y','MPG','row','# Cyl');
g(3,1).set_title('subplot rows');


g(3,2)=gramm('x',cars.Horsepower,'y',cars.MPG,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
g(3,2).facet_grid([],cars.Cylinders);
g(3,2).geom_point();
g(3,2).set_names('x','Horsepower','y','MPG','column','# Cyl');
g(3,2).set_title('subplot columns');


figure;
g.draw();