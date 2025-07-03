clc
clear
close all

monitor = '~/NHR/AmirReza/Coal/01-Coal-test-NR-DM-Phi0_5-Beta_1.7/monitor_plot' ;

% monitor_2= '/rwthfs/rz/cluster/hpcwork/itv/cq817671_AmirReza/Drag-model/02-test-R-drag-model/monitor_plot';

cd(monitor)
    files_in = dir(fullfile(pwd, 'coal'));
    n_f_in = size(files_in,1);
    filename_in = files_in.name;
    n_columns1 = 190;
    Format1 = repmat(' %f',1,n_columns1);
    fid1 = fopen(filename_in, 'rt');
    COAL = cell2mat(textscan(fid1,Format1,'HeaderLines',1, 'CollectOutput', true));
    fclose(fid1);

% cd(monitor_2)
%     files_in_2 = dir(fullfile(pwd, 'coal'));
%     n_f_in_2 = size(files_in_2,1);
%     filename_in_2 = files_in_2.name;
%     n_columns1_2 = 190;
%     Format1_2 = repmat(' %f',1,n_columns1_2);
%     fid1_2 = fopen(filename_in_2, 'rt');
%     COAL_2 = cell2mat(textscan(fid1_2,Format1_2,'HeaderLines',1, 'CollectOutput', true));
%     fclose(fid1_2);

    load('exp_data/rotation/Rota_Velo.mat')
    load('exp_data/BoundaryCondition.mat')

%%

%%
    FZ = 18;
    per = 0.1;
    lw = 1.5;
    set(0,'defaultAxesFontName','Helvetica');
    set(0, 'DefaultFigureRenderer', 'painters');

    set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
    set(groot, 'defaultLegendInterpreter','latex');
    set(0,'defaultAxesFontSize',FZ);
    set(0, 'DefaultLineLineWidth', lw);
    close

%%

x = Rota_Velo.t(1,:);                     
y = Rota_Velo.omega_EDF_mean_fine(1,:);

xconf = [x x(end:-1:1)] ;    
y1 = 0.5*Rota_Velo.omega_EDF_std_fine(1,:);

yconf = [y+y1 y(end:-1:1)-y1(end:-1:1)];

figure
set(gcf,'color','w');
box on
hold on
fill(xconf,yconf,'red');
%p.FaceColor = [1 0.8 0.8];      
%p.EdgeColor = 'none';           


plot(x(1,1:5:end),y(1,1:5:end),'ro-')
plot(1000*COAL(2:end,2),COAL(2:end,39), 'b-')
%plot(1000*COAL_2(2:end,2),-(60/(2*pi))*COAL_2(2:end,39), 'r-')
xlabel('$t(ms)$ ','Interpreter','latex','fontsize',FZ)
ylabel('$\omega (rpm)$','Interpreter','latex','fontsize',FZ)
%%xlim(Zmix_range)
xlim([0 26])
legend('','Experiment','NR-Simulation','NR_Simulation_2','Location','Best');
set(gca,'XMinorTick','on','YMinorTick','on')
%hold off
saveas(gcf,"Angular_Velocity","jpg")


    %%

x = velo_over_t.t_A-velo_over_t.t_A(1);                     
y = velo_over_t.A_avg;

xconf = [x x(end:-1:1)] ;    
y1 = 0.5*velo_over_t.A_std;

yconf = [y+y1 y(end:-1:1)-y1(end:-1:1)];

    figure(2)
    hold on
    box on
    set(gcf,'color','w');
    fill(xconf,yconf,'red');
    plot(x,y,'ro-')
    plot(1000*COAL(2:end,2),COAL(2:end,14), 'b-')
    %plot(1000*COAL_2(2:end,2),COAL_2(2:end,14), 'r-')
    xlabel('$t(ms)$ ','Interpreter','latex','fontsize',FZ)
    ylabel('$V_p (m/s)$','Interpreter','latex','fontsize',FZ)
    xlim([0 26])
    %ylim(ZPDF_range)
    legend('','Experiment','NR-Simulation','Location','Best');
    set(gca,'XMinorTick','on','YMinorTick','on')
    %title(strcat('Time=',num2str(time_label,'%.2f'),'ms'),'Interpreter','latex','fontsize',FZ)
    hold off
    saveas(figure(2),"Velocity","jpg")

    %%
    figure(3)
    set(gcf,'color','w');
    plot(1000*COAL(2:end,2),COAL(2:end,31), 'r-')
    xlabel('$t(ms)$ ','Interpreter','latex','fontsize',FZ)
    ylabel('$Euler \ angle (rad)$','Interpreter','latex','fontsize',FZ)
    %%xlim(Zmix_range)
    xlim([0 26])
    legend('Simulation','Location','Best');
    set(gca,'XMinorTick','on','YMinorTick','on')
    %title(strcat('Time=',num2str(time_label,'%.2f'),'ms'),'Interpreter','latex','fontsize',FZ)
    hold off
    saveas(figure(3),"Euler_Angles","jpg")