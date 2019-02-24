function [genotype4,phenotype,phenotype2] = Algorithm5(genotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,value,minMax,niche,crossoverType)

    for k = 1 : populationNum
        ranks(k) = 1;
        for i = 1 : populationNum
            counter(k) = 0;
            counter2(k) = 0;
            if i ~= k
                for j = 1 : numberOfFunctions
                    checkValue(j,k) = value(j,k);
                    if minMax(j) == 0
                        if checkValue(j,k) >= value(j,i)
                            counter(k) = counter(k) + 1;
                        end
                        if checkValue(j,k) > value(j,i)
                            counter2(k) = counter2(k) + 1;
                        end
                    elseif minMax(j)==1
                        if checkValue(j,k) <= value(j,i)
                            counter(k) = counter(k) + 1;
                        end
                        if checkValue(j,k) < value(j,i)
                            counter2(k) = counter2(k) + 1;
                        end
                    end
                end
                if counter(k) == numberOfFunctions
                    if counter2(k) >= 1
                        ranks(k) = ranks(k) + 1;
                    end
                end
            end
        end
    end
    
    for i = 1 : populationNum
        counterNiche(i) = 0;

        for j = 1:populationNum
           sum = 0;

           for k = 1 : numberOfFunctions
               sum = sum +( value(k,j) - value(k,i) ).^2;
           end
           dist = sqrt(sum);
           if dist < niche
               counterNiche(i) = counterNiche(i) + 1 ;
           end

        end
    end            
        
    for i = 1 : populationNum-1
        if (ranks(i) == 1 && ranks(i+1) == 1) || ((ranks(i) >1 && ranks(i+1) > 1))
            if counterNiche(i) >= counterNiche(i+1)
                winIndex(i) = i+1;
            elseif counterNiche(i) < counterNiche(i+1)
                winIndex(i) = i;
            end
        elseif ranks(i) == 1 && ranks(i+1) > 1
            winIndex(i) = i; 
        elseif ranks(i) >1  && ranks(i+1) == 1
            winIndex(i) = i+1;
        end
    end
    
    if (ranks(populationNum) == 1 && ranks(1) == 1) || ((ranks(populationNum) >1 && ranks(1) >1))
        if counterNiche(populationNum) >= counterNiche(1)
            winIndex(populationNum) = 1;
        elseif counterNiche(populationNum) < counterNiche(1)
            winIndex(populationNum) = populationNum;
        end
    elseif ranks(populationNum) == 1 && ranks(1) > 1
        winIndex(populationNum) = populationNum; 
    elseif ranks(populationNum) >1  && ranks(1) == 1
        winIndex(populationNum) = 1;
    end
   

    for j = 1 : populationNum
        for g = 1: variables
            selectedGenotype(j*variables+ g - variables,:) = genotype(variables*winIndex(j)+g-variables,:);
        end
    end
    
    for k = 1 : populationNum
        for i = 1 : variables
            decGenotype = bi2de(selectedGenotype(k*variables+ i - variables,:));
            phenotype(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )/ ((2^bitsLen(i))-1) ;
        end
    end
    
    if crossoverType == 1
        [genotype3] = crossover(selectedGenotype,populationNum,variables,bitsLen,Pc);
    elseif crossoverType ==2
        [genotype3] = multipleCrossover(selectedGenotype,populationNum,variables,bitsLen,Pc);
    elseif crossoverType == 3
        [genotype3] = uniformCrossover(selectedGenotype,populationNum,variables,bitsLen,Pc);
    end
    
    genotype4 = mutation(genotype3,populationNum,variables,bitsLen,Pm);

    for k = 1 : populationNum
        for i = 1 : variables
            decGenotype = bi2de(genotype4(k*variables+ i - variables,:));
            phenotype2(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )/ ((2^bitsLen(i))-1) ;
        end
    end
    
end