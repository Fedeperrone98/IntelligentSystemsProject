%% Sequentialfs criterion for Fuzzy Inference System
function performance = sequentialfs_criterion (input_train, ...
                                                   target_train, ...
                                                   input_test, ...
                                                   target_test)

    input_train = input_train';
    target_train = target_train';
    input_test = input_test';
    target_test = target_test';

    % Create a patternet network
    net = patternnet(5);
    
    net.divideParam.trainRatio = 0.85;
    net.divideParam.testRatio = 0;
    net.divideParam.valRatio = 0.15;
    
    net.trainParam.showWindow = 1; % Disable GUI

    % Train network
    net = train(net, input_train, target_train);
    
    % Test network
    y_test = net(input_test);
    performance = perform(net, target_test, y_test);

end