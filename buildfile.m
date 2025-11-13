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

function publishTask(context)
% Generate the html files 
    
    %Export the files to html
    files = dir('gramm/doc/*.mlx');
    destDir = fullfile(pwd, 'gramm', 'html'); % Absolute path to gramm/html
    for k = 1:numel(files)
        [~, name] = fileparts(files(k).name); % Get base filename without extension
        src = fullfile(files(k).folder, files(k).name); % Absolute source path
        dest = fullfile(destDir, [name '.html']);       % Absolute destination path
        export(src, dest, Run=true);
    end

    %move the mngs from doc to image folder
    srcDir = fullfile(pwd, 'gramm', 'doc');
    dstDir = fullfile(pwd, 'images');
    files = dir(fullfile(srcDir, '*.png'));
    for k = 1:numel(files)
        src = fullfile(files(k).folder, files(k).name);
        dst = fullfile(dstDir, files(k).name);
        movefile(src, dst);
    end

    %We need to run it again to have correctly sized figures in the html pages
    files = dir('gramm/doc/*.mlx');
    destDir = fullfile(pwd, 'gramm', 'html'); % Absolute path to gramm/html
    for k = 1:numel(files)
        [~, name] = fileparts(files(k).name); % Get base filename without extension
        src = fullfile(files(k).folder, files(k).name); % Absolute source path
        dest = fullfile(destDir, [name '.html']);       % Absolute destination path
        export(src, dest);
    end

    %Remove downloaded sample data files
    matfiles = dir('gramm/doc/*.mat');
    for k = 1:numel(matfiles)
        fileAbs = fullfile(matfiles(k).folder, matfiles(k).name);
        delete(fileAbs);
    end
end