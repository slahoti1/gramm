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
    etObj = examplesTester("gramm/examples", CodeCoveragePlugin = covPlugin);
    etObj.executeTests();
end

function checkDependenciesTask(context)
%Identify the missing dependencies
    
    % Check if dependencies.json exists
    depFile = 'dependencies.json';
    if ~isfile(depFile)
        error('Dependency file "%s" not found in the current directory.', depFile);
    end

    % Try to read and decode the JSON
    try
        deps = jsondecode(fileread(depFile));
    catch ME
        error('Failed to read or parse "%s": %s', depFile, ME.message);
    end

    % Check that the .products field exists 
    if ~isfield(deps, 'products')
        error('"%s" is missing the required "products" field.', depFile);
    end

    required = string(deps.products);

    % Get installed addons/toolboxes
    installed = matlab.addons.installedAddons().Name;

    % Make sure installed and required are string arrays
    installed = string(installed);
    requiredAlt = strrep(required, '_', ' ');
    
    % Check for presence (either original or alternative name)
    isPresent = ismember(required, installed) | ismember(requiredAlt, installed);
    
    % Find missing dependencies
    missing = required(~isPresent);
    
    if ~isempty(missing)
        error("Missing toolboxes: " + strjoin(missing, ", "));
    end
    disp("All dependencies are present.");
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

function getExamplesDrivenTesterTask(context)

% Parameters
fileExchangeId = 156374;   %File Exchange ID for ExamplesDrivenTester
version = 0.91;          %modify to change version of the add-on

% Generate metadata URL
urlGen = matlab.addons.repositories.FileExchangeRepositoryUrlGenerator;
url = urlGen.addonPackagesUrl(fileExchangeId, version);
meta = webread(url);  

isMltbx = arrayfun(@(p) strcmp(p.type, 'mltbx'), meta.packages);
mltbxEntry = meta.packages(find(isMltbx, 1));
if isempty(mltbxEntry)
    error('No mltbx package found for this File Exchange ID/version.');
end

% Download the mltbx file
websave(mltbxEntry.filename, mltbxEntry.url);

% Install the toolbox
matlab.addons.install(mltbxEntry.filename);

disp(['Installed toolbox from ', mltbxEntry.url]);

end

