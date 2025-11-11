% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
addpath('sample_data/','gramm/');
load example_data;

%% Superimposing gramm plots with update(): Using different groups for different stat_ and geom_ methods
% By using the method update() after a first draw() call of a gramm object,
% it is possible to add or remove grouping variables.
% Here in a first gramm plot we make a glm fit of cars Acceleration as a
% function of Horsepower, across all countries and number of cylinders, and
% change the color options so that the fit appears in grey

clear g10
figure;
g10=gramm('x',cars.Horsepower,'y',cars.Acceleration,'subset',cars.Cylinders~=3 & cars.Cylinders~=5);
g10.set_names('color','# Cylinders','x','Horsepower','y','Acceleration','Column','Origin');
g10.set_color_options('chroma',0,'lightness',30);
g10.stat_glm('geom','area','disp_fit',false);
g10.set_title('Update example'); %Title must be provided before the first draw() call
g10.draw();
snapnow;

% After the first draw() call (optional), we call the update() method by specifying a
% new grouping variable determining colors. We also change the facet_grid()
% options, which will duplicate the fit made earlier across all new facets.
% Last, color options are reinitialized to default values

g10.update('color',cars.Cylinders);
g10.facet_grid([],cars.Origin_Region);
g10.set_color_options();
g10.geom_point();
g10.draw();

