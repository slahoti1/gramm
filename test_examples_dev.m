classdef test_examples_dev < matlab.unittest.TestCase
    % Test class that runs examples_dev.m for code coverage

    methods(Test)
        function testExamples(testCase)
            % Run the examples script
            % This will execute all the gramm examples and generate coverage
            run('examples_dev.m');

            % If we get here without error, the test passes
            testCase.verifyTrue(true, 'examples_dev.m completed successfully');
        end
    end
end
