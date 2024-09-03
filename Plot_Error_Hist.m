function Plot_Error_Hist(Errors,Name,MSE,MAE,RSE,EVS)

    % Errors Histogram Plot
    figure;
    histfit(Errors,50);
    xlabel('Error Range','FontSize',22,'FontWeight','bold')
    ylabel('Sample Number','FontSize',22,'FontWeight','bold')
    title(['\fontsize{20}\bf',{Name,['MSE = ' num2str(MSE) ' , MAE = ' num2str(MAE) ' , RSE = ' num2str(RSE) ' , EVS = ' num2str(EVS) ]}])
    

end