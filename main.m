
clc;
clear;
close all;

mpc=loadcase('case14');
data=mpc;
ng=length(mpc.gen(:,1))-1;
flag=1;
Vg=mpc.gen(1:end,6);
S.nVar=2*ng + 1;                         % nombre de dimension
% VarSize=[1 S.nVar];                
% VarSize_P=[1 ng];
% VarSize_V=[1 ng+1];
Pgmin=data.gen(2:end,10);
Pgmax=data.gen(2:end,9);
Vgmin=ones(length(Vg),1)*0.94;
Vgmax=ones(length(Vg),1)*1.06;
S.Xmin=[Pgmin;Vgmin];
S.Xmax=[Pgmax;Vgmax];
%% GA Parameters

S.MaxIt=200;     
S.nPop=30;       

S.p_cross=0.8;                 % le porcentage du croisement 
S.n_cross=2*round(S.p_cross*S.nPop/2);  % nombre du Progéniture (aussi les parents)
%gamma=0.4;              % Extra Range Factor for Crossover

S.p_mu=0.3;                 % le porcentage du mutation
S.n_mu=round(S.p_mu*S.nPop);      % nombre des metations
S.mu_rate=0.1;                 % le taux de mutation

S.selection_type=1;

S.cross_type=1;






%% Initialisation


empty_individual.Position=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,S.nPop,1);

for i=1:S.nPop
    for k=1:S.nVar
    % Initialiser le Position
    pop(i).Position(k)= S.Xmin(k)+rand*(S.Xmax(k)-S.Xmin(k));
    end
    % Evaluation
    pop(i).Cost=CostFunction(pop(i).Position,data,flag);
    
end

% enregistrer la Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% enregistrer la mielleure Solution
BestSol=pop(1);

% vecteur pour enregistrer le mielleur cout
BestCost=zeros(S.MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;
tic;
for it=1:S.MaxIt
    [pop_mod,Best_Sol]=ga(pop,S,WorstCost,mpc);
    pop=pop_mod;
    WorstCost=max(WorstCost,pop(end).Cost);
    BestCost(it)=Best_Sol.Cost;
    disp(['Iteration ' num2str(it) ': le cout optimal est = ' num2str(BestCost(it))]);
end
z=toc;
disp('temps');
disp(z);
disp(['le cout optimal est :']);
disp(Best_Sol);
figure;
semilogy(BestCost,'LineWidth',2);
% plot(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Cout');
grid on;