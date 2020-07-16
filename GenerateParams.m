%% Setup for Industry Park Wastewater Optimisation
% ======================
% Edward O'Dwyer, November 2017
% 
% Generate input file for GAMS model
clear variables
clc
RunOffline = 0;
opt_gap = 0.0001;
numdays = 3652;
Techmultiplier = 2;
ResSell = 1;
hilly = 2;
if RunOffline == 1
    NumStreams = 1;
    NumCellsX = 1;
    NumCellsY = 2;
    TimeSteps = 1;    
    NumJoin = 1;
    NumTr = 1;
    NumRec = 1;
    NumM = NumJoin+NumTr+NumRec;
    NumResource = 1;
    NumDemand = 1;
    NumPipProp = 1;
    NumEl = 2;
else
    NumStreams = 5;
    NumCellsX = 4;
    NumCellsY = 4;
    TimeSteps = 1;
    NumJoin = 1;
    NumTr = 2;
    NumRec = 2;
    NumM = NumJoin+(NumTr+NumRec)*Techmultiplier;
    NumResource = 6;
    NumDemand = 3;
    NumPipProp = 4;
    NumEl = 8;
end
Delevation = zeros(NumCellsX,NumCellsY,NumCellsX,NumCellsY,NumEl);
if hilly == 0
    Elevs = zeros(NumCellsX,NumCellsY);
else
    % Elevs = [7,7,7,6,5,3;...
    %     7,7,6,5,3,3;...
    %     7,6,5,4,2,2;...
    %     6,6,4,4,2,1;...
    %     6,6,4,4,1,1;...
    %     6,5,4,3,1,0;...
    %     5,5,4,3,1,0];
    % Elevs = [7,7,6,4,3;...
    %     7,4,3,2,2;...
    %     6,4,2,2,1;...
    %     5,3,1,1,0];
    Elevs = [7,7,6,3;...
        7,4,2,2;...
        6,4,2,1;...
        5,3,1,0];
end
Wasters = zeros(NumResource,NumStreams,NumCellsX,NumCellsY);
MCost = zeros(1,NumM);
MOpCost = zeros(1,NumM);
UBounds = 100000*ones(1,NumM);
LBounds = zeros(NumM,NumResource);
Convert = ones(NumM,NumResource);
Concentration = zeros(NumStreams,NumResource);
DisLim = zeros(1,NumResource);
CostofDisp = zeros(1,NumResource);
PriSell = zeros(1,NumResource);
InstallPipe = 10*ones(NumPipProp,NumEl);
vel = 2*ones(1,NumPipProp);
Load = 0.8;
prodrate = [10000*numdays;10000*numdays;8000*numdays;4000*numdays;3000*numdays];
smalval = 0.02;
smalval1 = 1e-10;
flowup = 5e7;
if RunOffline == 1
    Wasters(1,1,1,:) = [0;20];
    MCost = 0.1*ones(1,NumM);
    MOpCost = 0.1*ones(1,NumM);
%     UBounds = UBounds;
    LBounds = 0*LBounds;
    Convert(1,:) = 0;
    Convert(2,:) = -1;
    Convert(3,:) = 0.5;
    Concentration(1,:) = 0.6;
    DisLim(1) = 10;  
    PriSell(1) = 6000;
    pipedi = 0.6;
    InstallPipe(1,1) = 1;
else
    Concentration(1,:) = [0.713,0.0863,0.0004,0,0,0];% These are in kg/m3
    Concentration(2,:) = [0.4,0.040,0.007,0,0,0];
    Concentration(3,:) = [1.5,0.100,0.08,0,0,0];
    Concentration(4,:) = [2.03,0.1263,0.00174,0,0,0];
    Concentration(5,:) = [15,0.420,0.245,0,0,0];
%     Wasters(:,1,2,1) = Concentration(1,:)*prodrate(1);
%     Wasters(:,2,1,2) = Concentration(2,:)*prodrate(2);
%     Wasters(:,3,4,1) = Concentration(3,:)*prodrate(3);
%     Wasters(:,4,7,6) = Concentration(4,:)*prodrate(4);
%     Wasters(:,5,6,6) = Concentration(5,:)*prodrate(5);
    Wasters(:,1,2,1) = Concentration(1,:)*prodrate(1);
    Wasters(:,2,1,2) = Concentration(2,:)*prodrate(2);
    Wasters(:,3,4,1) = Concentration(3,:)*prodrate(3);
    Wasters(:,4,3,4) = Concentration(4,:)*prodrate(4);
    Wasters(:,5,4,4) = Concentration(5,:)*prodrate(5);
    MCost(1) = 10000;
    MCost(2) = 2783733.3;
    MCost(3) = 3854400;
    MCost(4) = 963600;
    MCost(5) = 3997155.6;
    MOpCost(1) = 0;
    MOpCost(2) = 0.0078;
    MOpCost(3) = 0.009;
    MOpCost(4) = 0.0027;
    MOpCost(5) = 0.0112;
    UBounds(1) = 1000000*numdays;
    UBounds(2) = 40000*numdays;
    UBounds(3) = 40000*numdays;
    UBounds(4) = 40000*numdays;
    UBounds(5) = 40000*numdays;
    LBounds = 0*LBounds;    
    Convert(1,:) = [0,0,0,0,0,0];
    Convert(2,:) = [-.93,-.63,-.871,0.375,0.08,0.87];
    Convert(3,:) = [-.7,-1,-1,0.375*1.59,0,0];
    Convert(4,:) = [-.88,-.94,-.3,0,0,0];
    Convert(5,:) = [-.93,-.75,-.97,0,0,0];
    if Techmultiplier == 2
        MCost(6) = 765526.67;
        MCost(7) = 1059960;
        MCost(8) = 264990;
        MCost(9) = 1099217.8;
        MOpCost(6) = 0.00858;
        MOpCost(7) = 0.0099;
        MOpCost(8) = 0.00297;
        MOpCost(9) = 0.01232;
        UBounds(6) = 10000*numdays;
        UBounds(7) = 10000*numdays;
        UBounds(8) = 10000*numdays;
        UBounds(9) = 10000*numdays;
        Convert(6,:) = [-.93,-.63,-.871,0.375,0.08,0.87];
        Convert(7,:) = [-.7,-1,-1,0.375*1.59,0,0];
        Convert(8,:) = [-.88,-.94,-.3,0,0,0];
        Convert(9,:) = [-.93,-.75,-.97,0,0,0];
    end
    DisLim(5) = sum(prodrate)*0.015;%*0.01;
    DisLim(6) = sum(prodrate)*0.001;%*0.01;
    PriSell(4) = 0.16*ResSell*0;
    PriSell(5) = 0.67*ResSell;
    PriSell(6) = 0.27*ResSell;
    CostofDisp(2) = 0.8;
    CostofDisp(3) = 0.8;
    pipedi = [0.3,0.4,0.5,0.6];
    InstallPipe = [275,3765,4944,5478,29248,46111,114498,116165;...
        465,4145,5324,5857,29626,46487,114873,116541;...
        809,4830,6009,6541,30308,47166,115550,117218;...
        1111,5434,6612,7144,30910,47764,116147,117814];    
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %   Sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = struct('form','full','dim',1,'type','set','uels',cell(1),'val',...
    ones(1,TimeSteps),'name','t');
for ii = 1:TimeSteps
    t.uels{ii} = strcat('t_',num2str(ii));
end

j = struct('form','full','dim',1,'type','set','uels',cell(1),'val',...
    ones(1,NumStreams),'name','j');
for ii = 1:NumStreams
    j.uels{ii} = strcat('j_',num2str(ii));
end

nx = t;
nx.name = 'nx';
nx.uels = [];
for ii = 1:NumCellsX
    nx.uels{ii} = strcat('nx_',num2str(ii));
end
nx.val = ones(1,NumCellsX);

ny = t;
ny.name = 'ny';
ny.uels = [];
for ii = 1:NumCellsY
    ny.uels{ii} = strcat('ny_',num2str(ii));
end
ny.val = ones(1,NumCellsY);

p = t;
p.name = 'p';
p.uels = [];
for ii = 1:NumResource
    p.uels{ii} = strcat('p_',num2str(ii));
end
p.val = ones(1,NumResource);

dp = p;
dp.name = 'dp';
dp.uels = [];
for ii = 1:NumDemand
    dp.uels{ii} = strcat('p_',NumResource-NumDemand+num2str(ii));
end
dp.val = ones(1,NumDemand);

% mp = p;
% mp.name = 'mp';
% mp.uels = [];
% for ii = 1:NumResource
%     mp.uels{ii} = strcat('mp_',num2str(ii));
% end
% mp.val = double(sum(Convert<0)>1);

m = t;
m.name = 'm';
m.uels = [];
for ii = 1:NumM
    m.uels{ii} = strcat('m_',num2str(ii));
end
m.val = ones(1,NumM);

jm = m;
jm.name = 'jm';
jm.uels = [];
for ii = 1:NumJoin
    jm.uels{ii} = strcat('m_',num2str(ii));
end
jm.val = ones(1,NumJoin);

% tr = m;
% tr.name = 'tr';
% tr.uels = [];
% for ii = 1:NumTr
%     tr.uels{ii} = strcat('m_',num2str(ii+NumJoin+NumRe));
% end
% tr.val = ones(1,NumTr);
% 
re = t;
re.name = 're';
re.uels = [];
county = 0;
if Techmultiplier == 2
    reend = [1:NumRec,NumRec+NumTr+1:NumTr+2*NumRec];
else
    reend = 1:NumRec;
end
for ii = reend
    county = county+1;
    re.uels{county} = strcat('m_',num2str(ii+NumJoin));
end
re.val = ones(1,NumRec*Techmultiplier);

trure = m;
trure.name = 'trure';
trure.uels = [];
for ii = 1:(NumTr+NumRec)*Techmultiplier
    trure.uels{ii} = strcat('m_',num2str(ii+NumJoin));
end
trure.val = ones(1,(NumRec+NumTr)*Techmultiplier);

l = t;
l.name = 'l';
l.uels = [];
for ii = 1:NumPipProp
    l.uels{ii} = strcat('l_',num2str(ii));
end
l.val = ones(1,NumPipProp);

el = t;
el.name = 'el';
el.uels = [];
el.uels{1} = strcat('el_',num2str(0));
for ii = 2:NumEl
    el.uels{ii} = strcat('el_',num2str(ii-0.5));
end
el.val = ones(1,NumEl);

obj_set = struct('form','full','dim',1,'type','set','uels',cell(1),'val',ones(1,6),'name','obj_set');
obj_set.uels{1} = 'TotalCost';
obj_set.uels{2} = 'PipeCost';
obj_set.uels{3} = 'TreatCost';
obj_set.uels{4} = 'MiscCost';
obj_set.uels{5} = 'ResourceSold';
obj_set.uels{6} = 'Obj';
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %   Params
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gen = t;
gen.type = 'parameter';
gen.dim = 4;
gen.name = 'gen';
gen.uels = [];
gen.val = [];
for ii = 1:NumResource
    gen.uels{1,1}{ii} = strcat('p_',num2str(ii));
end
for ii = 1:NumStreams
    gen.uels{1,2}{ii} = strcat('j_',num2str(ii));
end
for ii = 1:NumCellsX
    gen.uels{1,3}{ii} = strcat('nx_',num2str(ii));
end
for ii = 1:NumCellsY
    gen.uels{1,4}{ii} = strcat('ny_',num2str(ii));
end
gen.val = Wasters;

gYN = t;
gYN.type = 'parameter';
gYN.dim = 3;
gYN.name = 'gYN';
gYN.uels = [];
for ii = 1:NumStreams
    gYN.uels{1,1}{ii} = strcat('j_',num2str(ii));
end
for ii = 1:NumCellsX
    gYN.uels{1,2}{ii} = strcat('nx_',num2str(ii));
end
for ii = 1:NumCellsY
    gYN.uels{1,3}{ii} = strcat('ny_',num2str(ii));
end
gYN.val = zeros(NumStreams,NumCellsX,NumCellsY);
for hh = 1:NumStreams
    for ii = 1:NumCellsX
        for jj = 1:NumCellsY
            if sum(Wasters(:,hh,ii,jj))>0
                gYN.val(hh,ii,jj) = 1;
            else
                gYN.val(hh,ii,jj) = 0;
            end
        end
    end
end

Capl = t;
Capl.type = 'parameter';
Capl.dim = 2;
Capl.name = 'Capl';
Capl.uels = [];
for ii = 1:NumPipProp
    Capl.uels{1,1}{ii} = strcat('l_',num2str(ii));
end
Capl.uels{1,2}{1} = strcat('el_',num2str(0));
for ii = 2:NumEl
    Capl.uels{1,2}{ii} = strcat('el_',num2str(ii-0.5));
end
Capl.val = InstallPipe;

Opl = t;
Opl.type = 'parameter';
Opl.dim = 2;
Opl.name = 'Opl';
Opl.uels = [];
for ii = 1:NumPipProp
    Opl.uels{1,1}{ii} = strcat('l_',num2str(ii));
end
Opl.uels{1,2}{1} = strcat('el_',num2str(0));
for ii = 2:NumEl
    Opl.uels{1,2}{ii} = strcat('el_',num2str(ii-0.5));
end
Opl.val = InstallPipe*0;

distance = t;
distance.type = 'parameter';
distance.dim = 4;
distance.name = 'distance';
distance.uels = [];
distance.val = [];
for ii = 1:NumCellsX
    distance.uels{1,1}{ii} = strcat('nx_',num2str(ii));
end
for ii = 1:NumCellsY
    distance.uels{1,2}{ii} = strcat('ny_',num2str(ii));
end
for ii = 1:NumCellsX
    distance.uels{1,3}{ii} = strcat('nx_',num2str(ii));
end
for ii = 1:NumCellsY
    distance.uels{1,4}{ii} = strcat('ny_',num2str(ii));
end
dist = zeros(NumCellsX,NumCellsY,NumCellsX,NumCellsY);
for hh = 1:NumCellsX
    for ii = 1:NumCellsY
        for jj = 1:NumCellsX
            for kk = 1:NumCellsY
                dist(hh,ii,jj,kk) = sqrt((jj-hh)^2+(kk-ii)^2)+0.01;
            end
        end
    end
end
distance.val = dist;

Flmin = t;
Flmin.type = 'parameter';
Flmin.dim = 2;
Flmin.name = 'Flmin';
Flmin.uels = [];
for ii = 1:NumM
    Flmin.uels{1,1}{ii} = strcat('m_',num2str(ii));
end
for ii = 1:NumResource
    Flmin.uels{1,2}{ii} = strcat('p_',num2str(ii));
end
Flmin.val = LBounds;

Promax = t;
Promax.type = 'parameter';
Promax.dim = 1;
Promax.name = 'Promax';
Promax.uels = [];
for ii = 1:NumM
    Promax.uels{1,1}{ii} = strcat('m_',num2str(ii));
end
Promax.val = UBounds;

Con = t;
Con.type = 'parameter';
Con.dim = 2;
Con.name = 'Con';
Con.uels = [];
for ii = 1:NumM
    Con.uels{1,1}{ii} = strcat('m_',num2str(ii));
end
for ii = 1:NumResource
    Con.uels{1,2}{ii} = strcat('p_',num2str(ii));
end
Con.val = Convert;

Con2 = t;
Con2.type = 'parameter';
Con2.dim = 2;
Con2.name = 'Con2';
Con2.uels = [];
for ii = 1:NumM
    Con2.uels{1,1}{ii} = strcat('m_',num2str(ii));
end
for ii = 1:NumResource
    Con2.uels{1,2}{ii} = strcat('p_',num2str(ii));
end
Con2.val = 0*Convert;
Con2.val(Convert<0)=Convert(Convert<0);

Con3 = t;
Con3.type = 'parameter';
Con3.dim = 2;
Con3.name = 'Con3';
Con3.uels = [];
for ii = 1:NumM
    Con3.uels{1,1}{ii} = strcat('m_',num2str(ii));
end
for ii = 1:NumResource
    Con3.uels{1,2}{ii} = strcat('p_',num2str(ii));
end
Con3.val = 0*Convert;
Con3.val(Convert>0)=Convert(Convert>0);

C = t;
C.type = 'parameter';
C.dim = 2;
C.name = 'C';
C.uels = [];
for ii = 1:NumStreams
    C.uels{1,1}{ii} = strcat('j_',num2str(ii));
end
for ii = 1:NumResource
    C.uels{1,2}{ii} = strcat('p_',num2str(ii));
end
C.val = Concentration;

pmax = t;
pmax.type = 'parameter';
pmax.dim = 1;
pmax.name = 'pmax';
pmax.uels = [];
for ii = 1:NumResource
    pmax.uels{1,1}{ii} = strcat('p_',num2str(ii));
end
pmax.val = DisLim;

pmin = t;
pmin.type = 'parameter';
pmin.dim = 1;
pmin.name = 'pmin';
pmin.uels = [];
for ii = 1:NumResource
    pmin.uels{1,1}{ii} = strcat('p_',num2str(ii));
end
pmin.val = DisLim*0;

Del = t;
Del.type = 'parameter';
Del.dim = 5;
Del.name = 'Del';
Del.uels = [];
Del.val = [];
for ii = 1:NumCellsX
    Del.uels{1,1}{ii} = strcat('nx_',num2str(ii));
end
for ii = 1:NumCellsY
    Del.uels{1,2}{ii} = strcat('ny_',num2str(ii));
end
for ii = 1:NumCellsX
    Del.uels{1,3}{ii} = strcat('nx_',num2str(ii));
end
for ii = 1:NumCellsY
    Del.uels{1,4}{ii} = strcat('ny_',num2str(ii));
end
Del.uels{1,5}{1} = strcat('el_',num2str(0));
for ii = 2:NumEl
    Del.uels{1,5}{ii} = strcat('el_',num2str(ii-0.5));
end
% 
% for hh = 1:NumCellsX
%     for ii = 1:NumCellsY
%         for jj = 1:NumCellsX
%             for kk = 1:NumCellsY
%                 for ll = 1
%                     Delevation(hh,ii,jj,kk,ll) = 1;
%                 end
%             end
%         end
%     end
% end
Diffel = zeros(NumCellsX,NumCellsY,NumCellsX,NumCellsY);
for ii = 1:NumCellsX
    for jj = 1:NumCellsY
        for kk = 1:NumCellsX
            for ll = 1:NumCellsY
                Diffel(ii,jj,kk,ll) = abs(Elevs(ii,jj)-Elevs(kk,ll));
                for mm = 1:NumEl
                    if mm-1 == Diffel(ii,jj,kk,ll)
                        Delevation(ii,jj,kk,ll,mm) = 1;
                    else
                        Delevation(ii,jj,kk,ll,mm) = 0;
                    end
                end
            end
        end
    end
end
Del.val = Delevation;

Capm = t;
Capm.type = 'parameter';
Capm.dim = 1;
Capm.name = 'Capm';
Capm.uels = [];
for ii = 1:NumM
    Capm.uels{1,1}{ii} = strcat('m_',num2str(ii));
end
Capm.val = MCost;

Opm = t;
Opm.type = 'parameter';
Opm.dim = 1;
Opm.name = 'Opm';
Opm.uels = [];
for ii = 1:NumM
    Opm.uels{1,1}{ii} = strcat('m_',num2str(ii));
end
Opm.val = MOpCost;

Opdis = struct('name','Opdis','type','parameter','dim',1,'form','full','uels',[],'val',CostofDisp);
for ii = 1:NumResource
    Opdis.uels{ii} = strcat('p_',num2str(ii));
end

Price = struct('name','Price','type','parameter','dim',1,'form','full','uels',[],'val',PriSell);
for ii = 1:NumResource
    Price.uels{ii} = strcat('p_',num2str(ii));
end

Install = t;
Install.type = 'parameter';
Install.dim = 2;
Install.name = 'Install';
Install.uels = [];
for ii = 1:NumPipProp
    Install.uels{1,1}{ii} = strcat('l_',num2str(ii));
end
Install.uels{1,2}{1} = strcat('el_',num2str(0));
for ii = 2:NumEl
    Install.uels{1,2}{ii} = strcat('el_',num2str(ii-0.5));
end
Install.val = InstallPipe;


FLOW = t;
FLOW.type = 'parameter';
FLOW.dim = 1;
FLOW.name = 'FLOW';
FLOW.uels = [];
for ii = 1:NumPipProp
    FLOW.uels{1,1}{ii} = strcat('l_',num2str(ii));
end
Area = 0.25*pi*(pipedi.^2);
FLOW.val = Area.*vel*Load*3600*24*numdays;

fl_up = struct('form','full','dim',0,'val',flowup,'type','parameter','name','fl_up');
small = struct('form','full','dim',0,'val',smalval,'type','parameter','name','small');
small1 = struct('form','full','dim',0,'val',smalval1,'type','parameter','name','small1');

gap = struct('form','full','dim',0,'val',opt_gap,'type','parameter','name','gap');
Timelimit = struct('name','timelimit','type','parameter','dim',0,'form','full','val',400000);
Threads = struct('name','threads','type','parameter','dim',0,'form','full','val',6);

save('1_input\Params','nx','ny','j','t','p','dp','m','jm','re','trure','l','el','obj_set',...
'gen','gYN','Capl','Opl','distance','Flmin','Promax','Con','Con2','Con3','C','pmax','pmin',...
'Del','Capm','Opm','Opdis','Price','Install','FLOW','fl_up','small','small1','gap',...
'Timelimit','Threads');

% Generate input file for GAMS model
addpath(pwd);
addpath('Mlab');
addpath('C:\GAMS\win64\24.8\');

clear;

load('1_input/Params.mat');

wgdx('input_params',nx,ny,j,t,p,dp,m,jm,re,trure,l,el,obj_set,gen,gYN,Capl,Opl,distance,...
    Flmin,Promax,Con,Con2,Con3,C,pmax,pmin,Del,Capm,Opm,Opdis,Price,Install,FLOW,fl_up,small,...
    small1,gap,Timelimit,Threads);

copyfile('input_params.gdx','2_gams\input.gdx');
% copyfile('input_params.gdx','SimpleCheck\input.gdx');