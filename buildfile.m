function plan = buildfile
import matlab.buildtool.tasks.*
import matlab.buildtool.Task

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("check") = CodeIssuesTask(Results="issues.mat");
plan("test") = TestTask("test_examples_dev.m",SourceFiles=["gramm/@gramm/*.m" "gramm/@gramm/private/*.m"], ...
    TestResults = "test-report\index.html").addCodeCoverage("coverageresults.html");

plan("package") = Task( ...
    Description = "Package the toolbox", ...
    Actions     = @(context) createPackage());

plan("examples") = Task( ...
    Description = "Run the examples", ...
    Actions     = @(context) runExamples() ...
);
plan("examples").Actions(end+1) = @(~)open(fullfile("test-report","index.html"));

plan.DefaultTasks = ["check" "test"];
end

function createPackage ()

    packagingData = matlab.addons.toolbox.ToolboxOptions("gramm.prj");
    % Update the version number
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

function runExamples()
    obj = examplesTester("gramm/examples");
    obj.executeTests;
end