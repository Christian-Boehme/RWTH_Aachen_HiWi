clc
clear all
close all
FZ = 20;
per = 0.1;
lw = 1.5;
set(0,'defaultAxesFontName','Times');
set(0,'defaultFigurePosition', [2 2 800, 600])
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaultAxesFontSize',FZ);
set(0, 'DefaultLineLineWidth', lw);

addpath('/home/jj343181/ReadCIAOBinaryFiles');
set(0, 'DefaultFigureRenderer', 'painters');
% name of output file

%Sim_loc='~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/SINGLES/2023-B7-B3-B2-C2-A8-CNF_singles/BIOMASS/AIR-20-DP-160/'; 
Sim_loc='~/NHR/Pooria/SINGLES/'; 
Fueltype = {"WS/","COL/"};
cases = {"OXY20-DP90/","OXY20-DP125/","OXY20-DP160/"};
%cases = {"OXY20-DP160/","OXY20-DP90/","OXY20-DP125/","AIR20-DP90/","AIR20-DP125/","AIR20-DP160/","AIR10-DP125/","AIR40-DP125/"};
cd(Sim_loc)
delete VolatileFlameStandOffDistance_Pooria_2.txt
output_file = "VolatileFlameStandOffDistance_Pooria_2.txt";
grid_ref = 125e-6;
fid = fopen(output_file, 'a+');
%fprintf(fid, 'FuelType(Coal=0,WS=1)\t Size\t atmosphere(Air=0,Oxy=1)\t O2\t flame_distance\n');% volatile flame stand-off distance
fclose(fid);

for i_case= 1:length(Fueltype)
    cd(Fueltype{i_case});
    for j_case = 1:length(cases)
    cd(cases{j_case});
    disp(strcat(Fueltype{i_case},cases{j_case}))
    clear files Sortedfiles ii time

    % monitor read===================================================
    if Fueltype{i_case} == "WS/"
        n_columns_solid = 208;
        n_columns_gas = 158;
        type_f = 1;
    else
        n_columns_solid = 190;
        n_columns_gas = 128;
        type_f = 0;
    end
    Format_solid = repmat(' %f',1,n_columns_solid);
    Format_gas = repmat(' %f',1,n_columns_gas);
    
    fileID_solid = fopen(strcat(Sim_loc,Fueltype{i_case},cases{j_case},'monitor/coal'));
    fileID_gas = fopen(strcat(Sim_loc,Fueltype{i_case},cases{j_case},'monitor/scalar'));
    %mydata_solid = cell2mat(textscan(fileID_solid,Format_solid,'HeaderLines',2));
    %mydata_gas = cell2mat(textscan(fileID_gas,Format_gas,'HeaderLines',2));
    mydata_gas = readtable(strcat(Sim_loc,Fueltype{i_case},cases{j_case},'monitor_TaoLi/scalar'),ReadVariableNames=true);
    mydata_solid = readtable(strcat(Sim_loc,Fueltype{i_case},cases{j_case},'monitor_TaoLi/coal'),ReadVariableNames=true);
    
    OH_monitor = mydata_gas.max_OH;
    [MaxOH,Ind_OHt] = max(OH_monitor);
    time_monitor= mydata_gas.time;
    t_OH_max = time_monitor(Ind_OHt);
    Dp = mydata_solid.dmax(end);
    O2_i = mydata_gas.max_O2(2);
    N2_i = mydata_gas.max_N2(2);
    
    if N2_i ~= 0
        atm = 0;
    else
        atm = 1;
    end

    if O2_i < 0.15
        O2 = 10;
    elseif O2_i > 0.35
        O2 = 40;
    else 
        O2 = 20;
    end

    fclose(fileID_solid);
    fclose(fileID_gas);
    %delete mydata_gas mydata_solid
    %================================================================
    
    files = dir(fullfile(pwd, 'data.out_*'));
    n_f = size(files,1);
    for i = 1:n_f
        filename = files(i).name;
        time(i)  = CIAO_read_real(filename,'time');
    end
    [time_1,ii] = sort(time);
    
    time = time_1;
    clear time_1
    sim_time = interp1(time, time, t_OH_max, 'nearest');
    sim_case=find(time==sim_time);
    
    Sortedfiles = files(ii);
    filename = Sortedfiles(sim_case).name;
    
    %%
    grid  = CIAO_read_grid(filename);
    xm = grid.xm;
    ym = grid.ym;
    zm = grid.zm;
    nx = size(xm,1);
    ny = size(ym,1);
    nz = size(zm,1);
    
    % read list of variables in CIAO file
    varlist  = CIAO_read_varlist(filename);
    dx = xm(2)-xm(1);
    dratio = grid_ref /dx;
    %
    
    Tx = zeros(nx,n_f);
    Q_T = zeros(nx,n_f);
    
    CHx = zeros(nx,n_f);
    Q_CH = zeros(nx,n_f);
    
    OHx = zeros(nx,n_f);
    Q_OH = zeros(nx,n_f);
    
    fl_pos_i = zeros(n_f,1);
    fl_pos_x = zeros(n_f,1);
    
    %ls_pos_i = zeros(n_f,1);
    %ls_pos_x = zeros(n_f,1);
    
    TT      = CIAO_read_real(filename,'T'); 
    CHH     = CIAO_read_real(filename,'CH');  
    OHH     = CIAO_read_real(filename,'OH');  
    ND_COAL = CIAO_read_real(filename, 'ND_COAL');
    
    particle_num = 0;
    rfrp = 0;
    for i = 1:nz
       if sum(sum(ND_COAL(:,:,i))) >= 1
           particle_num = particle_num + sum(sum(ND_COAL(:,:,i)));
       end
    end
    %fprintf('\ntotal number of particles in domain: %i\n', particle_num);
                
    if particle_num == 1
        for i = 1:nz
            matrix = ND_COAL(:,:,i);
            for j = 1:ny
                for k = 1:nx
                    if matrix(k,j) == 1
                        CenterX = k;
                        CenterY = j;
                        CenterZ = i;
                        break
                    end
                end
            end
        end
    end
    
    %fprintf('Particle position: i=%i, j=%i, and k=%i\n', CenterX, CenterY, CenterZ);
    %fprintf('Particle location: i=%i, j=%i, and k=%i\n', xm(CenterX), ym(CenterY), zm(CenterZ));
    Tx      = TT(:,CenterY, CenterZ);
    CHx     = CHH(:,CenterY, CenterZ);
    OHx     = OHH(:,CenterY, CenterZ);
    [Maxp,Indp] = max(OHx(CenterX:end));
    [Maxm,Indm] = max(OHx(1:CenterX));
    IndP = CenterX+Indp-1;
    fl_pos_x_1 = xm(Indm);
    fl_pos_x_2 = xm(IndP);
    Fl_distance_m = (abs(xm(Indm)-xm(CenterX))-0.5*Dp)/(0.5*Dp);
    Fl_distance_p = (abs(xm(IndP)-xm(CenterX))-0.5*Dp)/(0.5*Dp);
    Fl_distance = 0.5*(Fl_distance_m+Fl_distance_p)*dratio
    
    close all
    figT = figure(1);
    step = ['timestep = ',num2str(i)];
    set(gcf,'color','w');
    box on
    %yyaxis left
    subplot(3,1,1);
    plot(xm(CenterX-20:CenterX+20)-xm(CenterX),Tx(CenterX-20:CenterX+20));
    xline(fl_pos_x_1-xm(CenterX),'r--','LineWidth',lw)
    xline(fl_pos_x_2-xm(CenterX),'r--','LineWidth',lw)
    %ylim([0 2800]);
    %xlim([0 0.045]);
    ylabel('T_g');
    xlabel('x [m]');
    title('Temperature')
    legend(step, 'Location','Best')
    
    subplot(3,1,2);
    %yyaxis right
    plot(xm(CenterX-20:CenterX+20)-xm(CenterX),CHx(CenterX-20:CenterX+20));
    xline(fl_pos_x_1-xm(CenterX),'r--','LineWidth',lw)
    xline(fl_pos_x_2-xm(CenterX),'r--','LineWidth',lw)
    %ylim([0 3e-5]);
    %xlim([0 0.045]);
    ylabel('CH');
    xlabel('x [m]');
    title('CH')
    legend(step, 'Location','Best')
    
    subplot(3,1,3);
    %yyaxis right
    plot(xm(CenterX-20:CenterX+20)-xm(CenterX),OHx(CenterX-20:CenterX+20));
    xline(fl_pos_x_1-xm(CenterX),'r--','LineWidth',lw)
    xline(fl_pos_x_2-xm(CenterX),'r--','LineWidth',lw)
    %ylim([0 0.015]);
    %xlim([0 0.045]);
    ylabel('OH');
    xlabel('x [m]');
    title('OH')
    legend(step, 'Location','Best')
         
    outputfile = strcat('../../',output_file);
    fid1 = fopen(outputfile, 'a+');
    fprintf(fid1, '%f\t %f\t %f\t %f\t %f\n', type_f,Dp,atm,O2,Fl_distance);
    cd('../')
    end 
    cd('../')
end
%fclose(fid1);


