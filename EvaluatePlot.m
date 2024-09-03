function Results = EvaluatePlot(Data,name,Folder)

% X = Data.InputsDeNormal;
Y = Data.TargetsDeNormal;
Yhat = Data.SVROutputsDeNormal;

Errors = Y-Data.SVROutputs;

% Mean Squared Error
MSE = mean((Yhat - Y).^2);

% Root Mean Squared Error
RMSE = (mean((Yhat - Y).^2))^0.5;

% Relative Squared Error
RSE = sum((Yhat - Y).^2)/sum((ones(size(Y))*mean(Y) - Y).^2);

% Mean Absolute Error
MAE = mean(abs(Yhat - Y));

% R² score, the coefficient of determination
R2 = 1 - RSE;

% Explained variance score
EVS = 1 - std(Yhat - Y)/std(Y);



% Curve Fitting Plot
Plot_Curve_Fit(Y,Yhat,[name ' Curve Fitting Plot']);
savefig([Folder '\'  [name ' Curve Fitting Plot']]);


% Errors Plot
Plot_Errors(Errors,[name ' Errors Plot'],MSE,RMSE)
savefig([Folder '\' [name ' Errors Plot' ]]);


% Errors Histogram Plot
Plot_Error_Hist(Errors,[name ' Errors Histogram Plot'],MSE,MAE,RSE,EVS)
savefig([Folder '\' [name ' Errors Histogram Plot' ]]);


% Regression Plot
figure, plotregression(Y,Yhat,'Regression');
xlabel(['Observed Targets of ' name],'FontSize',12,'FontWeight','bold');
ylabel(['Predicted Targets of ' name],'FontSize',12,'FontWeight','bold');
title(['\fontsize{15}\bf',{[name ' Regression Plot'],...
['R^2 = ' num2str(R2) ' , RMSE = ' num2str(RMSE)]}]); 
savefig([Folder '\' [name ' Regression Plot' ]]);


s1 = ['R2 = ' num2str(R2)];
s2 = ['MSE = ' num2str(MSE)];
s3 = ['RMSE = ' num2str(RMSE)];
s4 = ['MAE = ' num2str(MAE)];
s5 = ['RSE = ' num2str(RSE)];
s6 = ['EVS = ' num2str(EVS)];


% fid = fopen(['Results\' [name '_Results.txt']],'wt');
fid = fopen([Folder '\' [name '_Results.txt']],'wt');
fprintf(fid, [s1 '\n' s2 '\n' s3 '\n' s4 '\n' s5 '\n' s6]);
fclose(fid);

% Store Results
Results.Name = [name,' Data'];
Results.R2 = R2;
Results.MSE = MSE;
Results.RMSE = RMSE;
Results.MAE = MAE;
Results.RSE = RSE;
Results.EVS = EVS;
Results.Errors = Errors;
% Results.X = X;
Results.Y = Y;
Results.Yhat = Yhat;
disp(Results);
end
