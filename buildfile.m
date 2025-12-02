function plan = buildfile
import matlab.buildtool.tasks.*
import matlab.buildtool.Task

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("check") = CodeIssuesTask(Results="issues.mat");
plan("checkDependencies").Inputs = "dependencies.json";
plan("package").Inputs = "gramm.prj";
plan("publish").Inputs = fullfile(pwd, 'gramm', 'doc');

plan("publish").Outputs = ["gramm\html\*.html","images\*.png"];

plan.DefaultTasks = "check";
end

function packageTask(context)
% Package the toolbox
    
    prjFile = context.Task.Inputs.Path;
    packagingData = matlab.addons.toolbox.ToolboxOptions(prjFile);
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

function runExamplesTask(context)
% Run examples as tests
    reportFormat = matlab.unittest.plugins.codecoverage.CoverageReport('coverage-report');
    covPlugin = matlab.unittest.plugins.CodeCoveragePlugin.forFolder("gramm","Producing",  reportFormat);
    etObj = examplesTester("gramm/examples", CodeCoveragePlugin = covPlugin);
    etObj.executeTests();
end

function checkDependenciesTask(context)
%Identify the missing dependencies
    

% NOTE: "dependencies.json" is a temporary workaround for current and older releases of MATLAB. 
% We plan to release "matlab.toml" that will centralize project configurations and manage dependencies. 
% We hope you will adopt that solution once it becomes available.

    % Check if dependencies.json exists
    depFile = context.Task.Inputs.Path;
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
    
    % Get installed addons/toolboxes
    installed = matlab.addons.installedAddons().Name;

    % Make sure installed and required are string arrays
    installed = string(installed);
    required = string(deps.products);
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
    % Generate HTML documentation

    import matlab.buildtool.io.FileCollection
    docFolder = context.Task.Inputs.Path;

    % Export the .mlx files to .html
    mlxFiles = FileCollection.fromPaths(fullfile(docFolder, "*.mlx")).paths;
    destDir = fullfile(pwd, 'gramm', 'html');
    for mlxFile = mlxFiles
        [~, name] = fileparts(mlxFile);
        htmlFolder = fullfile(destDir, name + ".html");
        export(mlxFile, htmlFolder, Run=true, EmbedImages=true);
    end

    %Move the pngs from doc to image folder
    imageFolder = fullfile(pwd, 'images');
    pngFiles = FileCollection.fromPaths(fullfile(docFolder, "*.png")).paths;
    for pngFile = pngFiles
        [~, name] = fileparts(pngFile);
        movefile(pngFile, fullfile(imageFolder, name + ".png"));
    end

    % Remove downloaded sample data files
    matFiles = FileCollection.fromPaths(fullfile(docFolder, "*.mat")).paths;
    for matFile = matFiles
        delete(matFile);
    end
end

function installAddonTask(context)
%Install the ExamplesDrivenTester Addon

% NOTE: This is a temporary workaround for current and older releases of MATLAB. 
% We plan to depricate this functionality in a future release with an alternate solution. 
% We hope you will adopt that solution once it becomes available.

    fileExchangeId = 156374;   %File Exchange ID for ExamplesDrivenTester
    AddonReleaseversion = 0.91;          %modify to change version of the add-on
    
    % Generate metadata URL
    urlGen = matlab.addons.repositories.FileExchangeRepositoryUrlGenerator;
    url = urlGen.addonPackagesUrl(fileExchangeId, AddonReleaseversion);
    pkgMetadata = webread(url);  
    
    isMltbx = arrayfun(@(p) strcmp(p.type, 'mltbx'), pkgMetadata.packages);
    mltbxMetadata = pkgMetadata.packages(find(isMltbx, 1));
    if isempty(mltbxMetadata)
        error('No mltbx package found.');
    end
    
    % Download the mltbx file
    websave(mltbxMetadata.filename, mltbxMetadata.url);
    % Install the toolbox
    matlab.addons.install(mltbxMetadata.filename);
    
    disp(['Installed toolbox from ', mltbxMetadata.url]);

end

