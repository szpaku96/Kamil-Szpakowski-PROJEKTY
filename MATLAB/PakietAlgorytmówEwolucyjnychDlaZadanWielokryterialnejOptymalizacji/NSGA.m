function [nsgaGenotype,NSGAphenotype,NSGAphenotype2] =  NSGA(genotype,phenotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,value,minMax,crossoverType)
   % wyznaczam fronty
   fronts = findFronts(populationNum,numberOfFunctions,value,minMax);
    % turniej binarny
    for i = 1 : populationNum
        a = randperm(populationNum,2);
        
        if fronts(a(1)) > fronts(a(2))
            winIndex(i) = a(2);
        elseif fronts(a(1)) < fronts(a(2))
            winIndex(i) = a(1);
        else
            totalRand= randi(2,1);
            if totalRand ==1
                 winIndex(i) = a(1);
            else
                 winIndex(i) = a(2);
            end
        end
    end
    % wybieramy zwyciezcow turnieju
    for j = 1 : populationNum
        for g = 1: variables
            selectedGenotype(j*variables+ g - variables,:) = genotype(variables*winIndex(j)+g-variables,:);
        end
    end
    
    for k = 1 : populationNum
        for i = 1 : variables
            decGenotype = bi2de(selectedGenotype(k*variables+ i - variables,:));
            phenotypeT(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )/ ((2^bitsLen(i))-1) ;
        end
    end
    sort(phenotypeT);
    
    %krzyzowanie i mutacja
    
    if crossoverType == 1
        [genotype3] = crossover(selectedGenotype,populationNum,variables,bitsLen,Pc);
    elseif crossoverType ==2
        [genotype3] = multipleCrossover(selectedGenotype,populationNum,variables,bitsLen,Pc);
    elseif crossoverType == 3
        [genotype3] = uniformCrossover(selectedGenotype,populationNum,variables,bitsLen,Pc);
    end
    
    genotype4 = mutation(genotype3,populationNum,variables,bitsLen,Pm);

     [num,~] = size(genotype4);
     vec = randperm(num);
    
    for i = 1 : num
        genotypeRAND(i,:) = genotype4(vec(i),:);
    end
    
    % obliczany fenotyp nowego pokolenia
    for k = 1 : populationNum
        for i = 1 : variables
            decGenotype = bi2de(genotypeRAND(k*variables+ i - variables,:));
            phenotype2(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )/ ((2^bitsLen(i))-1) ;
        end
    end
    
    % laczymy stare pokolenie z nowym
    mergeGenotype = [genotype;genotypeRAND];
    mergePhenotype = [phenotype,phenotype2];
    
    % obliczamy front dla nowej podwojonej populacji

    [value2,numberOfFunctions,realfun] = valueOfFunctions(mergePhenotype,2*populationNum,variables,minMax);
    fronts = findFronts(2*populationNum,numberOfFunctions,realfun,minMax);
    
    finish = 0;
    front = 1;
    index = 1;
    popCounter = 0;
    frontCounter = 0;
    crowdingIdx = 1;

    
    while finish == 0
        
        for i = 1 : 2 *populationNum
            if fronts(i) == front
               frontCounter = frontCounter +1;
            end
        end
        
       if popCounter + frontCounter <= populationNum
           
            for i = 1 : 2 *populationNum
                if fronts(i) == front
                    for g = 1: variables   
                        nsgaGenotype(index*variables+ g - variables,:) = mergeGenotype(variables*i+g-variables,:);
                    end
                    index = index + 1;
                end
            end
           popCounter = popCounter + frontCounter;
           frontCounter = 0;
           front = front + 1;
       else
           howManyDoIneed = populationNum-popCounter;
           
           for i = 1 : 2 * populationNum
                if fronts(i) == front
                   crowding(crowdingIdx) = i;
                   crowdingIdx = crowdingIdx +1;
                end
           end
           
           crowding;
           
%         choosing = randperm(crowdingIdx-1,howManyDoIneed);
%             
%            for i = 1 : howManyDoIneed
%                winIndex = crowding(choosing(i));
%                for g = 1: variables   
%                     nsgaGenotype(index*variables+ g - variables,:) = mergeGenotype(variables*winIndex+g-variables,:);
%                 end
%                     index = index + 1;
%            end
%            

           for i = 1 : crowdingIdx -1 
              crowdingVal(i) = 0; 
           end
           
       % tu sie powinien zaczynac for m = 1 : fun number; w value2 zastapic
       % 1 = > m
           for i = 1 : crowdingIdx-1
               a(i)=realfun(1,crowding(i));

           end
           [sortedVal,sortIdx] = sort(a);
           
           sortedVal;
           
           crowdingVal(1) = 5;
           crowdingVal(crowdingIdx -1) = 5;

           for i = 2 : crowdingIdx-2
               crowdingVal(i) = crowdingVal(i) + ( sortedVal(i+1) - sortedVal(i-1))/( max(sortedVal) - min(sortedVal));
           end

          % a tu konczyc for m
   
          
          [sortCrowdingVal,crowdingValIdx]=sort(crowdingVal);
          
          %sortCrowdingVal = fliplr(sortCrowdingVal);
          %crowdingValIdx = fliplr(crowdingValIdx);
          
            for i = 1 : howManyDoIneed
                selected3(i) = crowdingVal(crowdingValIdx(i));  % tu s¹
                % wartoœci które wybraliœmy
                selected(i) = crowdingValIdx(i);
            end
            for i = 1 : howManyDoIneed
                selected2(i) = crowding(selected(i));
            end
 
           
           for i = 1 : howManyDoIneed
               winIndex = selected2(i);
               for g = 1: variables   
                    nsgaGenotype(index*variables+ g - variables,:) = mergeGenotype(variables*winIndex+g-variables,:);
                end
                    index = index + 1;
           end
         
           finish = 1;
       end
       
        
    end
    
    for k = 1 : populationNum
        for i = 1 : variables
            decGenotype = bi2de(nsgaGenotype(k*variables+ i - variables,:));
            NSGAphenotype(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )/ ((2^bitsLen(i))-1) ;
        end
    end
    sort(NSGAphenotype);
    
    NSGAphenotype2 = NSGAphenotype;

end