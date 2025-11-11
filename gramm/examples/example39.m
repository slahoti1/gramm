% gramm examples and how-tos

% Shared variable
% We stat by loading the sample data (structure created from the carbig
% dataset)
addpath('sample_data/','gramm/');
load example_data;

%% Raw matlab code equivalent to the first figure (in paper.md)

figure('Color',[1 1 1]);

% Define groups
cyl = [4 6 8]; % Manually
orig = unique(cars.Origin_Region); % Based on data

% Loop over groups
for oi = 1:length(orig) % External loop on the axes

    % Axes creation
    ax = subplot(1,length(orig),oi);
    hold on

    for ci = 1:length(cyl) %Internal loop on the colors

        % Data selection
        sel = strcmp(cars.Origin_Region,orig{oi}) & ...
            cars.Cylinders==cyl(ci) & ...
            ~isnan(cars.Model_Year) & ~isnan(cars.MPG);

        % Plotting of raw data
        plot(cars.Model_Year(sel),cars.MPG(sel),'.', ...
            'MarkerSize',15);

        % Keep the same color for the statistics
        ax.ColorOrderIndex = ax.ColorOrderIndex - 1;

        % Statistics (linear fit and plotting)
        b = [ones(sum(sel),1) cars.Model_Year(sel)] \ ...
			cars.MPG(sel);
        x_fit = [min(cars.Model_Year(sel)) ...
			max(cars.Model_Year(sel))];
        plot(x_fit, x_fit * b(2) + b(1),'LineWidth',1.5);
    end

    % Axes legends
    title(['Origin: ' orig{oi}]);
    xlabel('Year');
    ylabel('Fuel Economy (MPG)');
end
% Ugly color legend
l = legend('4','','6','','8','','Location','southeast');
title(l,'#Cyl');
