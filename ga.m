function [pop_mod,Best_Sol]= ga(pop,S,WorstCost,mpc)

mpc1=mpc;
ng=length(mpc.gen(:,1))-1;
flag=1;
Costs=[pop.Cost];
empty_individual.Position=[];
empty_individual.Cost=[];


 beta=8; % Selection Pressure



%    pop_pow=pop(:,1:ng) ;
%    pop_volt=pop(:,ng+1:end);
   
   
    % Crossover
     popc=repmat(empty_individual,S.n_cross/2,2);

        
        % Select Parents Indices
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);


        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
%         v1=pop_volt(i1);
%         v2=pop_volt(i2);
        if p1.Cost > p2.Cost
            temp = p1;
            p1 = p2;
            p2 = temp;
        end
%         if v1.Cost > v2.Cost
%             temp = v1;
%             v1 = v2;
%             v2 = temp;
%         end
        
        % Apply Crossover
        
        [popc(k,1).Position, popc(k,2).Position]=SimpleCrossover(p1.Position,p2.Position,S.Xmin,S.Xmax);
%         [vol_Position1,vol_Position2]=SimpleCrossover(v1.Position,v2.Position,S.XMin(ng+1:end),S.XMax(ng+1:end));
%         popc(k,1).Position=[pow_Position1,vol_Position1];
%         popc(k,2).Position=[pow_Position2, vol_Position2];
        popc(k,1).Cost=CostFunction(popc(k,1).Position,mpc,flag);
        popc(k,2).Cost=CostFunction(popc(k,2).Position,mpc,flag);
     

        % Evaluate Offsprings
        
        
    
    popc=popc(:);
    
    
    % Mutation
    popm=repmat(empty_individual,S.n_mu,1);
    for k=1:S.n_mu
        
        % Select Parent
        i=randi([1 S.nPop]);
        p=pop(i);
        
        % Apply Mutation
        popm(k).Position=Mutate(p.Position,S.mu_rate,S.Xmin,S.Xmax);
        
        % Evaluate Mutant
        popm(k).Cost=CostFunction(popm(k).Position,mpc1,flag);
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm]; %%#ok
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    %WorstCost=pop(end).Cost;
    
    % Truncation
    pop_mod=pop(1:S.nPop);
    %Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    Best_Sol=pop(1);
 
end 
