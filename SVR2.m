clc;
clear;
close all;
if isfolder('Results')==0
    mkdir('Results');
end
%% 1 - Importing Data-set
Data = xlsread('DATA.xlsx',1);
Nan=isnan(Data);
Data(Nan==1)=0;
Inputs = Data(:,1:13);
Targets = Data(:,14);
[nSamples,nFeature] = size(Inputs);
TargetsNum = size(Targets,2);
%% 2 - Normalizing the Data-set
Prompt={'First of Normalization Interval','End of Normalization Interval'};
        Title='Normalization';
        DefaultValues={'0.1','0.9'};
        
        PARAMS=inputdlg(Prompt,Title,1,DefaultValues);
        
        a=str2num(PARAMS{1}); %#ok; 
        b=str2num(PARAMS{2}); %#ok;
        
% pause(0.1);
MinInputs = min(Inputs);
MaxInputs = max(Inputs);
MinTargets = min(Targets);
MaxTargets = max(Targets);
InputsNormal = Inputs;
TargetsNormal = Targets;
for ii = 1:nFeature
    InputsNormal(:,ii) = Normalize_Fcn(Inputs(:,ii),MinInputs(ii),MaxInputs(ii),a,b);
end
for ii = 1:TargetsNum
    TargetsNormal(:,ii) = Normalize_Fcn(Targets(:,ii),MinTargets(ii),MaxTargets(ii),a,b);
end
Option{1}='YES';
Option{2}='NO';
ANSWER=questdlg('Do you want to use Normalized Inputs?',...
                'Normalization',...
                Option{1},Option{2},Option{1});
% pause(0.1);
switch ANSWER
    
    case Option{1}
        Inputs = InputsNormal;
        Targets = TargetsNormal;
       
    case Option{2}
        Inputs = Data(:,1:13);
        Targets = Data(:,14);          
end
%% 3 - Selecting Train and Test Data-set
TrPercent = 70;
TrNum = round(nSamples * TrPercent / 100);
R = randperm(nSamples);
trIndex = R(1 : TrNum);
tsIndex = R(1+TrNum : end);
TrainData.Inputs = Inputs(trIndex,:);
TrainData.Targets = Targets(trIndex,:);
TrainData.nFeature = nFeature;
TestData.Inputs = Inputs(tsIndex,:);
TestData.Targets = Targets(tsIndex,:);
%% 4 - Create a SVM regression model
SVRModel = fitrsvm(TrainData.Inputs,TrainData.Targets,...
        'Standardize',false,'kernelfunction','gaussian','KernelScale','auto');
%% 5 - Test SVR
TrainData.SVROutputs = predict(SVRModel,TrainData.Inputs);  % Train Outputs of SVR
TestData.SVROutputs  = predict(SVRModel,TestData.Inputs);   % Test Outputs of SVR
%% 6 - DeNormalizing the Data-set 
Option{1}='YES';
Option{2}='NO';
ANSWER=questdlg('Do you want to DeNormalized Data-Sets?',...
                'DeNormalization',...
                Option{1},Option{2},Option{1});
pause(0.01);
switch ANSWER
    
    case Option{1}
        
        % Inputs DeNormalizing
        MinInputsNormal = min(InputsNormal);
        MaxInputsNormal = max(InputsNormal);
        InputsDeNormal = InputsNormal;
        for ii = 1:nFeature
            InputsDeNormal(:,ii) = DeNormalize_Fcn(InputsNormal(:,ii),MinInputsNormal(ii),MaxInputsNormal(ii),MinInputs(ii),MaxInputs(ii));
        end
        % Targets DeNormalizing
        MinTargetsNormal = min(TargetsNormal);
        MaxTargetsNormal = max(TargetsNormal);
        TargetsDeNormal = TargetsNormal;
        for i = 1:TargetsNum
            TargetsDeNormal(:,i) = DeNormalize_Fcn(TargetsNormal(:,i),MinTargetsNormal(i),MaxTargetsNormal(i),MinTargets(i),MaxTargets(i));
        end
        % Train Targets DeNormalizing
        MinYtr = min(TrainData.Targets);
        MaxYtr = max(TrainData.Targets);
        TrainData.TargetsDeNormal = TrainData.Targets;
        for i = 1:TargetsNum
            TrainData.TargetsDeNormal(:,i) = DeNormalize_Fcn(TrainData.Targets(:,i),MinYtr(i),MaxYtr(i),MinTargets(i),MaxTargets(i));
        end
        
        
        % TrainData.SVROutputs DeNormalizing
        MinYtrSVR = min(TrainData.SVROutputs);
        MaxYtrSVR = max(TrainData.SVROutputs);
        YtrSVRDeNormal = TrainData.SVROutputs;
        for i = 1:size(TrainData.SVROutputs,2)
            TrainData.SVROutputsDeNormal(:,i) = DeNormalize_Fcn(TrainData.SVROutputs(:,i),MinYtrSVR(i),MaxYtrSVR(i),MinTargets(i),MaxTargets(i));
        end
        
        
        % Test Targets DeNormalizing
        MinYts = min(TestData.Targets);
        MaxYts = max(TestData.Targets);
        TestData.TargetsDeNormal = TestData.Targets;
        for i = 1:TargetsNum
            TestData.TargetsDeNormal(:,i) = DeNormalize_Fcn(TestData.Targets(:,i),MinYts(i),MaxYts(i),MinTargets(i),MaxTargets(i));
        end
        
        
        % TestData.SVROutputs DeNormalizing
        MinYtsSVR = min(TestData.SVROutputs);
        MaxYtsSVR = max(TestData.SVROutputs);
        YtsSVRDeNormal = TestData.SVROutputs;
        for i = 1:size(TestData.SVROutputs,2)
            TestData.SVROutputsDeNormal(:,i) = DeNormalize_Fcn(TestData.SVROutputs(:,i),MinYtsSVR(i),MaxYtsSVR(i),MinTargets(i),MaxTargets(i));
        end
        
        
    case Option{2}
        
        TrainData.TargetsDeNormal = TrainData.Targets;
        TrainData.SVROutputsDeNormal = TrainData.SVROutputs;
        
        TestData.TargetsDeNormal = TestData.Targets;
        TestData.SVROutputsDeNormal = TestData.SVROutputs;
        
end
%% 7 - Assesment
ResultsTrain = EvaluatePlot(TrainData,'Train','Results');
ResultsTest  = EvaluatePlot(TestData,'Test','Results');
%% 8 - Export Predicted Targets
OUT = zeros(nSamples,1);
OUT(trIndex,1) = TrainData.SVROutputsDeNormal;
OUT(tsIndex,1) = TestData.SVROutputsDeNormal;
Header = {'Predicted_by_SVM'};
xlswrite('DATA.xls',Header,'O1:O1');
xlswrite('DATA.xls',OUT,['O2:O' num2str(nSamples+1)]);
AllData.TargetsDeNormal = Data(:,14);
AllData.SVROutputsDeNormal = OUT;
AllData.SVROutputs = OUT;
ResultsAll = EvaluatePlot(AllData,'All-Data','Results');
%% 9 - Export the Train & Test Data-set and Save the Results
save('Results\SVR_MATLAB_Output_File.mat');