%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Simple Genetic Algorithm%%%%%%%%%%%%%%%%%%%%%%%%
IndLength=20;
PopLength=10;
generation=50;
runEnd=1;
FitnessRun=zeros(runEnd,1);
Lb=-5.12;
Ub=5.12;
for run = 1:runEnd
    InitPop=round(rand(PopLength,IndLength));
    
    CurrentPop=InitPop;
    SelectedPop=zeros(PopLength,IndLength);
    Fitness=zeros(PopLength,1);
    DecVal=zeros(PopLength,1);
    FitnessStore=zeros(generation,1);
    xval=zeros(generation,1);
%%Fitness Value Calculation%%%%%%
    for gen=1:generation
        for i=1:PopLength
            for j=IndLength:-1:1%%convert binary to decimal
                Fitness(i)= Fitness(i) + CurrentPop(i,j)*(2^(IndLength-j));
            end
            Fitness(i)=Lb+Fitness(i)*((Ub-Lb)/((2^IndLength)-1));%%put value into the valid region that means between upper and lower bound
            DecVal(i)=Fitness(i);%store the decimal value within the valid region
            Fitness(i)=Fitness(i)^2;%%sqare function
        end

%%%%%%%%  Rank Selection %%%%%%%%%%%%%%%
    
    NewFitness=sort(Fitness);
    NewPop=round(rand(PopLength,IndLength));
    
    for i=1:PopLength
        for j=1:PopLength
            if(NewFitness(i)==Fitness(j))
                NewPop(i,1:IndLength)=CurrentPop(j,1:IndLength);
                break;
            end
        end
    end
    CurrentPop=NewPop;
            
    ProbSelection=zeros(PopLength,1);
    CumProb=zeros(PopLength,1);

    for i=1:PopLength
        ProbSelection(i)=i/PopLength;
        if i==1
            CumProb(i)=ProbSelection(i);
        else
            CumProb(i)=CumProb(i-1)+ProbSelection(i);
        end
    end

    SelectInd=rand(PopLength,1);
  
    for i=1:PopLength
        flag=0;
        for j=1:PopLength
            if(CumProb(j)<SelectInd(i) && CumProb(j+1)>=SelectInd(i))
                SelectedPop(i,1:IndLength)=CurrentPop(j+1,1:IndLength);
                flag=1;
                break;
            end
        end
        if(flag==0)
            SelectedPop(i,1:IndLength)=CurrentPop(1,1:IndLength);
        end
    end
            
            
 
%%Single point Crossover%%%%
        Crossover=rand(PopLength,1);%randomly generate crossover value(0-1) of each population 
        CrossInd=zeros(PopLength,1);
        Crosscount=0;j=1;
        for i=1:PopLength
            if(Crossover(i,1)<0.25)
                CrossInd(j,1)=i;%store the individuals those are selected for crossover
                j=j+1;
            end
        end
        lengthCross=j-1;%%number of individual selected for crossover
%%checking whether no. of individuals selected for crossover odd or even
        if(mod(lengthCross,2)==1)
            lengthCross=lengthCross-1;%if odd then discard the last one
        end
        for i=1:2:lengthCross
            crossPoint=randi([2,IndLength-1]);%%select crossover point 
            temp=SelectedPop(CrossInd(i,1),crossPoint:IndLength);
            SelectedPop(CrossInd(i,1),crossPoint:IndLength)=SelectedPop(CrossInd(i+1,1),crossPoint:IndLength);
            SelectedPop(CrossInd(i+1,1),crossPoint:IndLength)=temp;
        end
%%%%%Flipping mutation%%%%
        Mutation=rand(PopLength,IndLength);
        for i=1:PopLength
            for j=1:IndLength
                if Mutation(i,j)<0.01
                    SelectedPop(i,j)=1-SelectedPop(i,j);
                end
            end
        end
        CurrentPop=SelectedPop;%%next generation population
        [FitnessStore(gen,1),x]=min(Fitness(:));%minimum fitness value in this generation
        xval(gen,1)=DecVal(x);%decimal value of the individual that have minimum fitness value
        for i=1:PopLength
            Fitness(i)=0;
        end
    end
FitnessRun(run,1)=FitnessStore(generation-1,1)
xval(gen-1,1)
end
mean(FitnessRun(:,:));