clc;
clear;
close all;
if isfolder('Results_Final')==0
    mkdir('Results_Final');
end

%% Loading Trained SVM Model

load('Results\SVR_MATLAB_Output_File.mat');

%%  Calculating the Land-slide for Final Data-set

Final_Inputs = xlsread('BIG_DATA.xlsx',1);

Final_Outputs = predict(SVRModel,Final_Inputs);

Final_Outputs(Final_Outputs>1)=1;
Final_Outputs(Final_Outputs<0)=0;

Final_DATA = [Final_Inputs , Final_Outputs];

xlswrite('Final_DATA.xlsx',Final_DATA);

save('Results_Final\SVM_MATLAB_Output_File.mat');

