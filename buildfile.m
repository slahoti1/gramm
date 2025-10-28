function plan = buildfile
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("check") = CodeIssuesTask(Results="issues.mat");
plan("test") = TestTask("test_examples_dev.m",SourceFiles=["gramm/@gramm/*.m" "gramm/@gramm/private/*.m"], ...
    TestResults = "testresults.html").addCodeCoverage("coverageresults.html");

plan.DefaultTasks = ["check" "test"];
end

