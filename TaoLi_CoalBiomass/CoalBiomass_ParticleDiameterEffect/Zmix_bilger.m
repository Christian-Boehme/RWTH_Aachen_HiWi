clc
clear
close all

%% Stoichimetry
%% mass fractions
% Volatiles
Vol = ["C2H2","CH4","CO","CO2","H2O"];
Vol2N = containers.Map('KeyType', 'char', 'ValueType', 'int32');
for i = 1:length(Vol)
    Vol2N(Vol(i)) = i;
end
yVol(Vol2N("H2O"))=0.268;
yVol(Vol2N("CO2"))=0.072;
yVol(Vol2N("CO"))=0.087;
yVol(Vol2N("CH4"))=0.057;
yVol(Vol2N("C2H2"))=0.516;

%Oxidizer
Ox = ["N2","O2","CO2","H2O"];
Ox2N = containers.Map('KeyType', 'char', 'ValueType', 'int32');
for i = 1:length(Ox)
    Ox2N(Ox(i)) = i;
end
yOx(Ox2N("N2")) = 0.586;
yOx(Ox2N("O2")) = 0.2242;
yOx(Ox2N("CO2")) = 0.1042;
yOx(Ox2N("H2O")) = 0.0856;

%%
MW_Vol = 0;
for i = 1:length(Vol)
    MW_Vol = MW_Vol + yVol(i)/MW(Vol(i));
end
MW_Vol = 1/MW_Vol;
sum_v= 0;
for i = 1:length(Vol)
    xVol(i) = yVol(i)*MW_Vol / MW(Vol(i));
    sum_v = sum_v + xVol(i);
end

MW_Ox = 0;
for i = 1:length(Ox)
    MW_Ox = MW_Ox + yOx(i)/MW(Ox(i));
end
MW_Ox = 1/MW_Ox;
sum_o = 0;
for i = 1:length(Ox)
    xOx(i) = yOx(i)*MW_Ox / MW(Ox(i));
    sum_o = sum_o + xOx(i);
end

%% Write reaction
str_Vol = "";
coeffs_Vol = ["a1","b1","c1","d1","e1"];
for i = 1:length(Vol)
    str_Vol= str_Vol + strcat('+ ',coeffs_Vol(i),'(',num2str(xVol(i)),')',Vol(i));
end
str_Vol = strrep(str_Vol,'+a','a')
str_Ox = "";
coeffs_Ox = ["a2","b2","c2","d2","e2"];
for i = 1:length(Ox)
    str_Ox= str_Ox+ strcat('+ ',coeffs_Ox(i),'(',num2str(xOx(i)),')',Ox(i));
end

str_Ox = strrep(str_Ox,'+a','a')
str_Pr = "";
coeffs_Pr = ["a3","b3","c3","d3","e3","f3","g3"];
Pr = ["CO2","H2O","N2","CO2","H2O","CO2","H2O"];
for i = 1:length(Pr)
    str_Pr= str_Pr + strcat('+ ',coeffs_Pr(i),Pr(i));
end
str_Pr = strrep(str_Pr,'+a','a')
disp("--------------------------------------------")
disp("simplifying and crossing the dilution gases (additional CO2 and H2O)...")
disp("modified Reaction: str_Vol + str_Ox => str_Pr...")
disp("--------------------------------------------")
str_Vol = "";
coeffs_Vol = [" "," "," "," "," "];
for i = 1:length(Vol)-2
    str_Vol= str_Vol + strcat('+ ',coeffs_Vol(i),'(',num2str(xVol(i)),')',Vol(i));
end
str_Vol = strrep(str_Vol,strcat('+ (',num2str(xVol(1))),strcat('(',num2str(xVol(1))))
str_Ox = "";
coeffs_Ox = ["a2","b2","c2","d2","e2"];
for i = 2:length(Ox)-2
    str_Ox= str_Ox+ strcat('+ ',coeffs_Ox(i),'(','1',')',Ox(i));
end

str_Ox = strrep(str_Ox,'+b','b')
str_Pr = "";
coeffs_Pr = ["a3","b3","c3","d3","e3","f3","g3"];
Pr = ["CO2","H2O","N2","CO2","H2O","CO2","H2O"];
for i = 1:length(Pr)-5
    str_Pr= str_Pr + strcat('+ ',coeffs_Pr(i),Pr(i));
end
str_Pr = strrep(str_Pr,'+a','a')
%%
specs = ["N2", "AR", "I-CO", "I-CO2", "I-H2O", "I-H2", "I-N2", "H", "O2", "O", "OH", "H2", "H2O", "HE", "HO2", "H2O2", "CO", "CO2", "HCO", "C", "CH", "T-CH2", "CH3", "CH2O", "HCCO", "C2H", "CH2CO", "C2H2", "S-CH2", "CH3OH", "CH2OH", "CH3O", "CH4", "CH3O2", "C2H3", "C2H4", "C2H5", "HCCOH", "CH2CHO", "CH3CHO", "H2C2", "C2H5O", "N-C3H7", "C2H6", "C3H8", "C3H6", "C3H3", "P-C3H4", "A-C3H4", "S-C3H5", "N-C4H3", "C2H3CHO", "A-C3H5", "C2O", "C4H4", "C3H2", "C3H2O", "C4H2", "I-C4H3", "T-C3H5", "C3H5O", "C4H", "C8H2", "C6H2", "C4H6", "N-C4H5", "I-C4H5", "A1-C6H6"];
n_C =   [0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 3, 3, 3, 3, 3, 3, 4, 3, 3, 2, 4, 3, 3, 4, 4, 3, 3, 4, 8, 6, 4, 4, 4, 6];
n_H =   [0, 0, 0, 0, 2, 2, 0, 1, 0, 0, 1, 2, 2, 0, 1, 2, 0, 0, 1, 0, 1, 2, 3, 2, 1, 1, 2, 2, 2, 4, 3, 3, 4, 3, 3, 4, 5, 2, 3, 4, 2, 5, 7, 6, 8, 6, 3, 4, 4, 5, 3, 4, 5, 0, 4, 2, 2, 2, 3, 5, 5, 1, 2, 2, 6, 5, 5, 6];
n_O =   [0, 0, 1, 2, 1, 0, 0, 0, 2, 1, 1, 0, 1, 0, 2, 2, 1, 2, 1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 2, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
n_N =   [2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];


num_species = size(specs,2);
S2N = containers.Map('KeyType', 'char', 'ValueType', 'int32');



for i = 1:num_species
    S2N(specs(i)) = i;
end
%%
per_mole_fuel = 1/(xVol(1)+xVol(2)+xVol(3));
disp("--------------------------------------------")
disp("Reactions Per mole Fuel...")
disp("modified Reaction: str_Vol + str_Ox => str_Pr...")
disp("--------------------------------------------")
str_Vol = "";
coeffs_Vol = [" "," "," "," "," "];
for i = 1:length(Vol)-2
    str_Vol= str_Vol + strcat('+ ',coeffs_Vol(i),'(',num2str(per_mole_fuel*xVol(i)),')',Vol(i));
end
str_Vol = strrep(str_Vol,strcat('+ (',num2str(per_mole_fuel*xVol(1))),strcat('(',num2str(per_mole_fuel*xVol(1))))
str_Ox = "";
coeffs_Ox = ["a2","b2","c2","d2","e2"];
for i = 2:length(Ox)-2
    str_Ox= str_Ox+ strcat('+ ',coeffs_Ox(i),'(',num2str(1),')',Ox(i));
end

str_Ox = strrep(str_Ox,'+b','b')
str_Pr = "";
coeffs_Pr = ["a3","b3","c3","d3","e3","f3","g3"];
Pr = ["CO2","H2O","N2","CO2","H2O","CO2","H2O"];
for i = 1:length(Pr)-5
    str_Pr= str_Pr + strcat('+ ',coeffs_Pr(i),'(',num2str(1),')',Pr(i));
end
str_Pr = strrep(str_Pr,'+a','a')
%% Stoichiometric reaction
% A=1 F + B O2 --> P CO2 + Q H2O
% F = xF_C2H2 C2H2 + xF_CH4 CH4 + xF_CO CO
% Ox = O2 
syms B2 A3 B3
% C Balance:
eqn1 = n_C(S2N("C2H2"))*per_mole_fuel*xVol(Vol2N("C2H2"))+n_C(S2N("CH4"))*per_mole_fuel*xVol(Vol2N("CH4"))+n_C(S2N("CO"))*per_mole_fuel*xVol(Vol2N("CO")) == A3*n_C(S2N("CO2"));
% H Balance:
eqn2 = n_H(S2N("C2H2"))*per_mole_fuel*xVol(Vol2N("C2H2"))+n_H(S2N("CH4"))*per_mole_fuel*xVol(Vol2N("CH4")) == B3*n_H(S2N("H2O"));
%O Balance:
eqn3=n_O(S2N("CO"))*per_mole_fuel*xVol(Vol2N("CO"))+B2*n_O(S2N("O2")) == A3*n_O(S2N("CO2"))+B3*n_O(S2N("H2O"));


sol = solve([eqn1, eqn2, eqn3], [B2, A3, B3]);
%% 
disp('Balance for Stoichiometry...')
b2 = double(sol.B2)
a3 = double(sol.A3)
b3 = double(sol.B3)
%%
disp("--------------------------------------------")
disp("Final Reaction per mole Fuel: str_VolN + str_OxN => str_PrN...")
disp("--------------------------------------------")
str_VolN = "";
for i = 1:length(Vol)-2
    coeffs_VolN(i) = per_mole_fuel*xVol(i);
end

for i = 1:length(Vol)-2
    str_VolN= str_VolN + strcat('+ ',num2str(coeffs_VolN(i)),Vol(i));
end

str_VolN = strrep(str_VolN,strcat('+',num2str(coeffs_VolN(1))),num2str(coeffs_VolN(1)))
str_OxN = "";

coeffs_OxN = b2;
for i = 2:2
    str_OxN= str_OxN+ strcat('+ ',num2str(coeffs_OxN),Ox(i));
end

str_OxN = strrep(str_OxN,strcat('+',num2str(coeffs_OxN)),num2str(coeffs_OxN))
str_PrN = "";
coeffs_PrN = [a3,b3];
PrN = ["CO2","H2O"];
for i = 1:length(PrN)
    str_PrN= str_PrN + strcat('+ ',num2str(coeffs_PrN(i)),PrN(i));
end
str_PrN = strrep(str_PrN,strcat('+',num2str(coeffs_PrN(1))),num2str(coeffs_PrN(1)))

%% Z_st
MW_F = 0;
for i = 1:3 %neglecting  CO2 and H2O as a part of Fuel
    MW_F = MW_F + xVol(i)*MW(Vol(i));
end
%%
nu_O2 = coeffs_OxN
%%
nu = nu_O2*(MW("O2")/MW_F) % normalize nu to calculate the amount of Oxygen per mole fuel
%%
Y_Ox_O2 = yOx(Ox2N("O2"));
Z_St = Y_Ox_O2 / (nu + Y_Ox_O2) 



%% Calculate Mixture fractions from outputs


sim_loc = '~/itv/nz635150/ITV-Simulations/Point-Particle/Cluster_T_Box/T1500_eta100_D20_st5_NP10K_12,8mm_dx50/reactive-FVC1/selected/';
save_loc = '~/itv/nz635150/ITV-Simulations/Point-Particle/Cluster_T_Box/T1500_eta100_D20_st5_NP10K_12,8mm_dx50/HDF5_Reactive/unfiltered/selected_set/';

addpath('/home/jj343181/ReadCIAOBinaryFiles'); % ADD YOUR OWN HOME PATH
addpath(pwd); % Add the "scripts" directory to path that contains the mechanism (mechanism.mexa64) function and enthalpy supporting function

% -----------------------------------------------------------------------

cd (sim_loc);

comp_loc = extractAfter(pwd,"cluster");

% ---------- Single or Multiple Output Values ----------------------

%files = dir(fullfile(pwd, 'data.out_*')); % For all files
files = dir(fullfile(pwd, 'data.out_2.100E-02')); % For single file
%files = dir(fullfile(pwd, 'data.out_2.115E-02')); % For single file

% ------------------------------------------------------------------

n_f = size(files,1)

filename = files(1).name;

grids  = CIAO_read_grid(filename);
xm = grids.xm;
ym = grids.ym;
zm = grids.zm;
nx = size(xm,1);
ny = size(ym,1);
nz = size(zm,1);

% read list of variables in CIAO file
varlist  = CIAO_read_varlist(filename);
%%
parpool('local',20) % For Parallel Processing, may want to comment
%% Read species mass fractions
parfor s = 1:num_species
    %fprintf('Progress : %2.0f out of %2.0f species.\n',s,num_species);
    [Y(s,:,:,:)] = Yfrac(specs(s), nx, ny, nz, n_f, files);
end
%% element mass fractions

% C element mass fraction
Z_C = zeros(nx,ny,nz);
for i = 1:num_species
    Z_C = Z_C + n_C(i) .* (MW("C")./MW(specs(i))) .* squeeze(Y(S2N(specs(i)),:,:,:)) ;
end

% H element mass fraction
Z_H = zeros(nx,ny,nz);
for i = 1:num_species
    Z_H = Z_H + n_H(i) .* (MW("H")./MW(specs(i))) .* squeeze(Y(S2N(specs(i)),:,:,:)) ;
end

% O element mass fraction
Z_O = zeros(nx,ny,nz);
for i = 1:num_species
    Z_O = Z_O + n_O(i) .* (MW("O")./MW(specs(i))) .* squeeze(Y(S2N(specs(i)),:,:,:)) ;
end

% N element mass fraction
MW_N = 14;
Z_N = zeros(nx,ny,nz);
for i = 1:num_species
    Z_N = Z_N + n_N(i) .* (MW_N./MW(specs(i))) .* squeeze(Y(i,:,:,:)) ;
end


%% Bilger mixture fraction
Z_C1 = 0;
for i = 1:length(Vol)
    Z_C1 = Z_C1 + (n_C(S2N(Vol(i))).* MW("C").*squeeze(Y(S2N(Vol(i)),:,:,:)))./MW(Vol(i));   
end

Z_C2 = 0;
for i = 1:length(Ox)
    Z_C2 = Z_C2 + (n_C(S2N(Ox(i))).* MW("C").*squeeze(Y(S2N(Ox(i)),:,:,:)))./MW(Ox(i));   
end

Z_H1 = 0;
for i = 1:length(Vol)
    Z_H1 = Z_H1 + (n_H(S2N(Vol(i))).* MW("H").*squeeze(Y(S2N(Vol(i)),:,:,:)))./MW(Vol(i));   
end

Z_H2 = 0;
for i = 1:length(Ox)
    Z_H2 = Z_H2 + (n_H(S2N(Ox(i))).* MW("H").*squeeze(Y(S2N(Ox(i)),:,:,:)))./MW(Ox(i));   
end

Z_O1 = 0;
for i = 1:length(Vol)
    Z_O1 = Z_O1 + (n_O(S2N(Vol(i))).* MW("O").*squeeze(Y(S2N(Vol(i)),:,:,:)))./MW(Vol(i));   
end

Z_O2 = 0;
for i = 1:length(Ox)
    Z_O2 = Z_O2 + (n_O(S2N(Ox(i))).* MW("O").*squeeze(Y(S2N(Ox(i)),:,:,:)))./MW(Ox(i));   
end

beta_f = 2.*(Z_C1)./MW("C")+0.5.*(Z_H1)./MW("H")-1.*(Z_O1)./MW("O");
beta_ox = 2.*(Z_C2)./MW("C")+0.5.*(Z_H2)./MW("H")-1.*(Z_O2)./MW("O");
beta = 2.*(Z_C)./MW("C")+0.5.*(Z_H)./MW("H")-1.*(Z_O)./MW("O");
Z_bilger = (beta - beta_ox)./(beta_f - beta_ox);

%%
m = 2*xVol(Vol2N("C2H2")) + xVol(Vol2N("CH4")) + xVol(Vol2N("CO"))+xVol(Vol2N("CO2"));
n = 2*xVol(Vol2N("C2H2")) + 4*xVol(Vol2N("CH4"))+2*xVol(Vol2N("H2O"));

W_C = MW("C");
W_H = MW("H");
W_O = MW("O");
W_O2 = MW("O2");

Beta_f = (Z_C1)./(m*MW("C"))+(Z_H1)./(n*MW("H"))-(Z_O1)./(nu_O2*MW("O2"));
Beta_ox = (Z_C2)./(m*MW("C"))+(Z_H2)./(n*MW("H"))-(Z_O2)./(nu_O2*MW("O2"));
Beta = (Z_C)./(m*MW("C"))+(Z_H)./(n*MW("H"))-(Z_O)./(nu_O2*MW("O2"));
ZBilger = (Beta - Beta_ox)./(Beta_f - Beta_ox);

%ZBilger = ((Z_C./(m.*W_C))+(Z_H./(n.*W_H))+(2.*((Y_Ox_O2)-Z_O)./(nu_O2.*W_O2)))./((Z_C1./(m.*W_C))+(Z_H1./(n*W_H))+(2.*((Y_Ox_O2)./(nu_O2.*W_O2))));

%% N2 mixture fraction
Ox1_N2 = yOx(Ox2N("N2"));
min_N2 = 0;%0.412286; %0.44235;%
N2 = squeeze(Y(S2N("N2"),:,:,:));
%min_N2 = min(min(min(N2)));
ZMIX_N2 = (N2-Ox1_N2)./(min_N2-Ox1_N2);

%% Volatile mixture fraction
% Vol = C2H2 + CH4 + CO + CO2 + H2O

ZC_vol = Z_C1;
ZH_vol = Z_H1;
ZO_vol = Z_O1;
ZN_vol = 0;
Zmix_vol_ox = 0;
Zmix_vol_f= 1;
Zmix_vol0 = ZC_vol + ZH_vol + ZO_vol + ZN_vol;
Zmix_vol = (Zmix_vol0 - Zmix_vol_f) ./ (Zmix_vol_ox-Zmix_vol_f);

%%
FZ = 16;
per = 0.1;
lw = 1.5;
set(0,'defaultAxesFontName','Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(0,'defaultFigurePosition', [2 2 700, 500])
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaultAxesFontSize',FZ);
set(0, 'DefaultLineLineWidth', lw);

%%
disp('I am plotting...')
close all
figure(1)
set(gcf,'color','w');
box on
%scatter(IN_n(:,6),OUT_n(:,6))
histogram2(Z_bilger(:),ZBilger(:),'DisplayStyle','tile','ShowEmptyBins','off');

hold on
grid off
colormap('turbo');
c=colorbar;
set(c,'TickLabelInterpreter','latex')
c_max = max(size(ZMIX_N2),[],'all');
caxis([1 c_max*per]);
format long
ylabel(c, 'PDF','Interpreter','latex','fontsize',FZ-2)
xlim([min(min(Z_bilger(:)),min(ZBilger(:))) max(max(Z_bilger(:)),max(ZBilger(:)))]);
ylim([min(min(Z_bilger(:)),min(ZBilger(:))) max(max(Z_bilger(:)),max(ZBilger(:)))]);

rline = refline(1,0);
rline.Color = 'k';
rline.LineStyle = ':';
axis equal

set(gca,'ColorScale','log')
xlabel('$Z_{Bilger_{Sandia}}$ ','Interpreter','latex','fontsize',FZ)
ylabel('$Z_{Bilger_{Peters}}$','Interpreter','latex','fontsize',FZ)


set(gca,'XMinorTick','on','YMinorTick','on')
%title(strcat('Time=',num2str(time_label,'%.2f'),'ms'),'Interpreter','latex','fontsize',FZ)
hold off


%%
disp('I am plotting...')
close all
figure(1)
set(gcf,'color','w');
box on
%scatter(IN_n(:,6),OUT_n(:,6))
histogram2(Z_bilger(:),ZMIX_N2(:),'DisplayStyle','tile','ShowEmptyBins','off');

hold on
grid off
colormap('turbo');
c=colorbar;
set(c,'TickLabelInterpreter','latex')
c_max = max(size(ZMIX_N2),[],'all');
caxis([1 c_max*per]);
format long
ylabel(c, 'PDF','Interpreter','latex','fontsize',FZ-2)
xlim([min(min(Z_bilger(:)),min(ZMIX_N2(:))) max(max(Z_bilger(:)),max(ZMIX_N2(:)))]);
ylim([min(min(Z_bilger(:)),min(ZMIX_N2(:))) max(max(Z_bilger(:)),max(ZMIX_N2(:)))]);

rline = refline(1,0);
rline.Color = 'k';
rline.LineStyle = ':';
axis equal

set(gca,'ColorScale','log')
xlabel('$Z_{Bilger_{Sandia}}$ ','Interpreter','latex','fontsize',FZ)
ylabel('$Z_{N_2}$','Interpreter','latex','fontsize',FZ)


set(gca,'XMinorTick','on','YMinorTick','on')
%title(strcat('Time=',num2str(time_label,'%.2f'),'ms'),'Interpreter','latex','fontsize',FZ)
hold off

%%
disp('I am plotting...')
close all
figure(1)
set(gcf,'color','w');
box on
%scatter(IN_n(:,6),OUT_n(:,6))
histogram2(ZBilger(:),ZMIX_N2(:),'DisplayStyle','tile','ShowEmptyBins','off');

hold on
grid off
colormap('turbo');
c=colorbar;
set(c,'TickLabelInterpreter','latex')
c_max = max(size(ZMIX_N2),[],'all');
caxis([1 c_max*per]);
format long
ylabel(c, 'PDF','Interpreter','latex','fontsize',FZ-2)
xlim([min(min(ZBilger(:)),min(ZMIX_N2(:))) max(max(ZBilger(:)),max(ZMIX_N2(:)))]);
ylim([min(min(ZBilger(:)),min(ZMIX_N2(:))) max(max(ZBilger(:)),max(ZMIX_N2(:)))]);

rline = refline(1,0);
rline.Color = 'k';
rline.LineStyle = ':';
axis equal

set(gca,'ColorScale','log')
xlabel('$Z_{Bilger_{Peters}}$ ','Interpreter','latex','fontsize',FZ)
ylabel('$Z_{N_2}$','Interpreter','latex','fontsize',FZ)


set(gca,'XMinorTick','on','YMinorTick','on')
%title(strcat('Time=',num2str(time_label,'%.2f'),'ms'),'Interpreter','latex','fontsize',FZ)
hold off
%%
% %disp('I am plotting...')
% %close all
% figure(2)
% set(gcf,'color','w');
% box on
% %scatter(IN_n(:,6),OUT_n(:,6))
% histogram2(Z_bilger(:),Zmix_vol(:),'DisplayStyle','tile','ShowEmptyBins','off');
% 
% hold on
% grid off
% colormap('turbo');
% c=colorbar;
% set(c,'TickLabelInterpreter','latex')
% c_max = max(size(ZMIX_N2),[],'all');
% caxis([1 c_max*per]);
% format long
% ylabel(c, 'PDF','Interpreter','latex','fontsize',FZ-2)
% xlim([min(min(Z_bilger(:)),min(Zmix_vol(:))) max(max(Z_bilger(:)),max(Zmix_vol(:)))]);
% ylim([min(min(Z_bilger(:)),min(Zmix_vol(:))) max(max(Z_bilger(:)),max(Zmix_vol(:)))]);
% 
% rline = refline(1,0);
% rline.Color = 'k';
% rline.LineStyle = ':';
% axis equal
% 
% set(gca,'ColorScale','log')
% xlabel('$Z_{Bilger}$ ','Interpreter','latex','fontsize',FZ)
% ylabel('$Z_{vol}$','Interpreter','latex','fontsize',FZ)
% 
% 
% set(gca,'XMinorTick','on','YMinorTick','on')
% %title(strcat('Time=',num2str(time_label,'%.2f'),'ms'),'Interpreter','latex','fontsize',FZ)
% hold off

% %%
% %disp('I am plotting...')
% %close all
% figure(3)
% set(gcf,'color','w');
% box on
% %scatter(IN_n(:,6),OUT_n(:,6))
% histogram2(Zmix_vol(:),ZMIX_N2(:),'DisplayStyle','tile','ShowEmptyBins','off');
% 
% hold on
% grid off
% colormap('turbo');
% c=colorbar;
% set(c,'TickLabelInterpreter','latex')
% c_max = max(size(ZMIX_N2),[],'all');
% caxis([1 c_max*per]);
% format long
% ylabel(c, 'PDF','Interpreter','latex','fontsize',FZ-2)
% xlim([min(min(Zmix_vol(:)),min(ZMIX_N2(:))) max(max(Zmix_vol(:)),max(ZMIX_N2(:)))]);
% ylim([min(min(Zmix_vol(:)),min(ZMIX_N2(:))) max(max(Zmix_vol(:)),max(ZMIX_N2(:)))]);
% 
% rline = refline(1,0);
% rline.Color = 'k';
% rline.LineStyle = ':';
% axis equal
% 
% set(gca,'ColorScale','log')
% xlabel('$Z_{vol}$ ','Interpreter','latex','fontsize',FZ)
% ylabel('$Z_{N_2}$','Interpreter','latex','fontsize',FZ)
% 
% 
% set(gca,'XMinorTick','on','YMinorTick','on')
% %title(strcat('Time=',num2str(time_label,'%.2f'),'ms'),'Interpreter','latex','fontsize',FZ)
% hold off
%%
%close
%close all
figure(4)
set(gcf,'color','w');
ax1 = nexttile(1);
s1=pcolor(ZBilger(:,:,128));
colormap(ax1,turbo)
caxis(ax1,[0 0.3])
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
axis image
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
cb1=colorbar(ax1,'westoutside'); 
title('$Z_{Bilger_{Peters}}$','fontsize',FZ,'interpreter','latex')
ylabel(cb1, '$Z$','fontsize',FZ,'interpreter','latex')

ax1 = nexttile(2);
s1=pcolor(ZMIX_N2(:,:,128));
colormap(ax1,turbo)
caxis(ax1,[0 0.3])
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
axis image
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
cb1=colorbar(ax1,'westoutside'); 
title('$Z_{N_2}$','fontsize',FZ,'interpreter','latex')
ylabel(cb1, '$Z$','fontsize',FZ,'interpreter','latex')
hold off

ax1 = nexttile(3);
s1=pcolor(Z_bilger(:,:,128));
colormap(ax1,turbo)
caxis(ax1,[0 0.3])
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
axis image
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
cb1=colorbar(ax1,'westoutside'); 
title('$Z_{Bilger_{sandia}}$','fontsize',FZ,'interpreter','latex')
ylabel(cb1, '$Z$','fontsize',FZ,'interpreter','latex')
hold off
%%
ax1 = nexttile(3);
s1=pcolor(squeeze(Y(S2N("N2"),:,:,128)));
colormap(ax1,turbo)
caxis(ax1,[0 0.586])
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
axis image
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
cb1=colorbar(ax1,'westoutside'); 
title('$Y_{N_2}$','fontsize',FZ,'interpreter','latex')
ylabel(cb1, '$Y$','fontsize',FZ,'interpreter','latex')
hold off

%%
figure
hold on
%z_dir = zeros(size(Pz1_data,1),1)+c_max1+1;
%plot3(Pz1_data,avg1_dataPz,z_dir,'k','LineWidth', lw);
histogram2(ZBilger(:),OH(:),'DisplayStyle','tile','ShowEmptyBins','off');
colormap('Turbo');
colorbar
%%xlim(Zmix_range)
%ylim(src_pv_range)
set(gca,'XMinorTick','on','YMinorTick','on')
caxis([1 c_max*per]);
format long
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex');
ylabel('$Y_{OH}$','fontsize',FZ,'interpreter','latex')
xlabel('$Z_{Bilger}$','fontsize',FZ,'interpreter','latex')
legend('DNS','Location','Best');
title(strcat('t= 0.5ms'),'Interpreter','latex','fontsize',FZ)
set(gca,'ColorScale','log')
box on
hold off
%%
function Y = Yfrac(SpeciesName, nx, ny, nz, i_f, files)
    %fprintf('Now computing concentration for %s\n', SpeciesName);
    % Y is for mass fraction
    % X is for mole fraction (Mixture molar mass would take too long too compute, I decided not to implement this)
    % C is for molar concentration
    Y = zeros(nx,ny,nz);
        filename = files(i_f).name;
        Y(:,:,:) = CIAO_read_real(filename,SpeciesName);
        %C_i = Y_i *(RHO/M_i). Added 1000 to convert from kmol to mol
        %C(:,:,:) = Y(:,:,:).*(RHO(:,:,:)./MolarMassOfSpecies(SpeciesName));
end



function M_i = MW(aSpecies)
    %I used https://www.webqc.org/molecular-weight-of-H2.html to look up
    %species molar mass
    switch aSpecies
        case 'N2'
            M_i = 28.0134;
        case 'AR'
            M_i = 39.948;
        case 'I-CO'
            M_i = 28.0101;
        case 'I-CO2'
            M_i = 44.0095;
        case 'I-H2O'
            M_i = 18.01528;
        case 'I-H2'
            M_i = 2.01588;
        case 'I-N2'
            M_i = 28.0134;
        case 'H'
            M_i = 1.00794;
        case 'O2'
            M_i = 31.99880;
        case 'O'
            M_i = 15.99940;
        case 'OH'
            M_i = 17.00734;
        case 'H2'
            M_i = 2.01588;
        case 'H2O'
            M_i = 18.01528;
        case 'HE'
            M_i = 4.0026020;
        case 'HO2'
            M_i = 33.00674;
        case 'H2O2'
            M_i = 34.01468;
        case 'CO'
            M_i = 28.0101;
        case 'CO2'
            M_i = 44.0095;
        case 'HCO'
            M_i = 29.0180;
        case 'C'
            M_i = 12.01070;
        case 'CH'
            M_i = 13.01864;
        case 'T-CH2'
            M_i = 14.02658;
        case 'CH3'
            M_i = 15.0345;
        case 'CH2O'
            M_i = 30.0260;
        case 'HCCO'
            M_i = 41.0287;
        case 'C2H'
            M_i = 25.0293;
        case 'CH2CO'
            M_i = 42.0367;
        case 'C2H2'
            M_i = 26.0373;
        case 'S-CH2'
            M_i = 14.02658;
        case 'CH3OH'
            M_i = 32.0419;
        case 'CH2OH'
            M_i = 31.0339;
        case 'CH3O'
            M_i = 31.0339;
        case 'CH4'
            M_i = 16.0425;
        case 'CH3O2'
            M_i = 47.0333;
        case 'C2H3'
            M_i = 27.0452;
        case 'C2H4'
            M_i = 28.0532;
        case 'C2H5'
            M_i = 29.0611;
        case 'HCCOH'
            M_i = 42.0367;
        case 'CH2CHO'
            M_i = 43.0446;
        case 'CH3CHO'
            M_i = 44.0526;
        case 'H2C2'
            M_i = 26.0373;
        case 'C2H5O'
            M_i = 45.0605;
        case 'N-C3H7'
            M_i = 43.0877;
        case 'C2H6'
            M_i = 30.0690;
        case 'C3H8'
            M_i = 44.0956;
        case 'C3H6'
            M_i = 42.0797;
        case 'C3H3'
            M_i = 39.0559;
        case 'P-C3H4'
            M_i = 40.0639;
        case 'A-C3H4'
            M_i = 40.0639;
        case 'S-C3H5'
            M_i = 41.0718;
        case 'N-C4H3'
            M_i = 51.0666;
        case 'C2H3CHO'
            M_i = 56.0633;
        case 'A-C3H5'
            M_i = 41.0718;
        case 'C2O'
            M_i = 40.0208;
        case 'C4H4'
            M_i = 52.0746;
        case 'C3H2'
            M_i = 38.0480;
        case 'C3H2O'
            M_i = 54.0474;
        case 'C4H2'
            M_i = 50.0587;
        case 'I-C4H3'
            M_i = 51.0666;
        case 'T-C3H5'
            M_i = 41.0718;
        case 'C3H5O'
            M_i = 57.0712;
        case 'C4H'
            M_i = 49.0507;
        case 'C8H2'
            M_i = 98.1015;
        case 'C6H2'
            M_i = 74.0801;
        case 'C4H6'
            M_i = 54.0904;
        case 'N-C4H5'
            M_i = 53.0825;
        case 'I-C4H5'
            M_i = 53.0825;
        case 'A1-C6H6'
            M_i = 78.1118;
    end
end