function Plot_Errors(Errors,Name,MSE,RMSE)

    % Errors Plot
    figure;
    plot(Errors,'b');
    xlabel('Number of Sample','FontSize',22,'FontWeight','bold')
    ylabel('Errors','FontSize',22,'FontWeight','bold')
    title(['\fontsize{20}\bf',{Name,['MSE = ' num2str(MSE) ' , RMSE = ' num2str(RMSE) ]}])
    xlim([0 size(Errors,1)+5]);

end