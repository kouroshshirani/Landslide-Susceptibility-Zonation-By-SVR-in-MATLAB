threshold = 0.5;

% Convert continuous outputs to binary using the threshold
TrainData.BinaryTargets = TrainData.TargetsDeNormal >= threshold;
TrainData.BinaryOutputs = TrainData.SVROutputsDeNormal;

TestData.BinaryTargets = TestData.TargetsDeNormal >= threshold;
TestData.BinaryOutputs = TestData.SVROutputsDeNormal;

% Compute ROC Curve for Training Data
[TrainFPR, TrainTPR, ~, TrainAUC] = perfcurve(TrainData.BinaryTargets, TrainData.BinaryOutputs, 1);

% Compute ROC Curve for Test Data
[TestFPR, TestTPR, ~, TestAUC] = perfcurve(TestData.BinaryTargets, TestData.BinaryOutputs, 1);

% Plot ROC Curve for Training Data
figure;
plot(TrainFPR, TrainTPR, 'b-', 'LineWidth', 2);
hold on;
plot([0 1], [0 1], 'k--');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title(['ROC Curve for Training Data (AUC = ' num2str(TrainAUC) ')']);
hold off;

% Plot ROC Curve for Test Data
figure;
plot(TestFPR, TestTPR, 'r-', 'LineWidth', 2);
hold on;
plot([0 1], [0 1], 'k--');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title(['ROC Curve for Test Data (AUC = ' num2str(TestAUC) ')']);
hold off;

% Save AUC Results
ResultsTrain.AUC = TrainAUC;
ResultsTest.AUC = TestAUC;





