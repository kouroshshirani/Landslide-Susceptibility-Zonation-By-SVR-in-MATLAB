function Plot_Curve_Fit(Targets,Outputs,Name)
    
    figure;    
    plot(Targets,'bo-','linewidth',1.2,'Markerfacecolor','b')
    ax = gca;
    ax.FontSize = 12;
    ax.TickDir = 'in';
    ax.TickLength = [0.02 0.02];
    grid minor
    ax.MinorGridLineStyle = '-' ;
    ax.XGrid = 'off';
    ax.YGrid = 'off';
    ax.GridColorMode ='manual';
    ax.GridColor = [0 0 0];
    ax.GridAlpha = 0.75;
    hold on
    plot(Outputs,'rs-','linewidth',1.2,'Markerfacecolor','r')
    title(['\fontsize{24}\bf' num2str(Name)]);
    xlabel('Number of Sample','FontSize',22,'FontWeight','bold')
    ylabel('Targets and Outputs','FontSize',22,'FontWeight','bold')
    set(findobj(gcf,'type','axes'),'FontWeight','Bold', 'LineWidth', 0.9)
    hold off
    legend({'Targets','Outputs'},'FontSize',18,'FontWeight','bold')


end