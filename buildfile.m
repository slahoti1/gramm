function plan = buildfile
import matlab.buildtool.tasks.*
import matlab.buildtool.Task

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("check") = CodeIssuesTask(Results="issues.mat");

plan.DefaultTasks = ["check"];
end

function packageTask(context)
% Package the toolbox
    
    packagingData = matlab.addons.toolbox.ToolboxOptions("gramm.prj");
    % Update the version number with the github tag 
    tagVersion = getenv("CI_COMMIT_TAG"); 
    if ~isempty(tagVersion)
        if startsWith(tagVersion, 'v')
            tagVersion = erase(tagVersion, 'v');
        end
        packagingData.ToolboxVersion = tagVersion;
    end
    outputFileName = packagingData.ToolboxName + "_" + packagingData.ToolboxVersion + ".mltbx";
    packagingData.OutputFile =outputFileName;
    
    % Create toolbox MLTBX
    matlab.addons.toolbox.packageToolbox(packagingData);
    
    fprintf("Created %s.\n", outputFileName);
end

function examplesTask(context)
% Run the examples as test
    reportFormat = matlab.unittest.plugins.codecoverage.CoverageReport('coverage-report');
    covPlugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder("gramm","Producing",  reportFormat);
    obj = examplesTester("gramm/examples", CodeCoveragePlugin = covPlugin);
    obj.executeTests();
end

function checkDependenciesTask(context)
%Identify the missing dependencies
    % Read dependencies.json
    deps = jsondecode(fileread('dependencies.json'));
    required = string(deps.products);

    % Get installed addons/toolboxes
    T = matlab.addons.installedAddons;
    installed = T.Name;

    % Check for missing dependencies
    missing = {};
    for i = 1:numel(required)
        reqName = required(i);
        reqNameAlt = strrep(reqName, '_', ' '); % For MathWorks toolboxes

        found = any(strcmp(reqName, installed)) || any(strcmp(reqNameAlt, installed));
        if ~found
            missing{end+1} = char(reqName); %#ok<AGROW>
        end
    end

    if ~isempty(missing)
        result = "Missing toolboxes: " + strjoin(missing, ", ");
        error(result); % Fails the build task
    else
        result = "All dependencies are present.";
        disp(result);
    end
end



function publishTask(context)
    % Generate the html files

    import matlab.buildtool.io.FileCollection

    % Use FileCollection to get .mlx files
    fcMlx = FileCollection.fromPaths("gramm/doc/*.mlx");
    mlxFiles = fcMlx.paths;
    destDir = fullfile(pwd, 'gramm', 'html');
    for k = 1:numel(mlxFiles)
        [~, name] = fileparts(mlxFiles{k});
        src = mlxFiles{k};
        dest = fullfile(destDir, [name '.html']);
        export(src, dest, Run=true);
    end

    % Move the pngs from doc to image folder
    dstDir = fullfile(pwd, 'images');
    fcPng = FileCollection.fromPaths("gramm/doc/*.png");
    pngFiles = fcPng.paths;
    for k = 1:numel(pngFiles)
        [~, name] = fileparts(pngFiles{k});
        src = pngFiles{k};
        dst = fullfile(dstDir, [name '.png']);
        movefile(src, dst);
    end

    % We need to run it again to have correctly sized figures in the html pages
    % (repeat for .mlx files)
    for k = 1:numel(mlxFiles)
        [~, name] = fileparts(mlxFiles{k});
        src = mlxFiles{k};
        dest = fullfile(destDir, [name '.html']);
        export(src, dest);
    end

    % Remove downloaded sample data files
    fcMat = FileCollection.fromPaths("gramm/doc/*.mat");
    matFiles = fcMat.paths;
    for k = 1:numel(matFiles)
        delete(matFiles{k});
    end
end