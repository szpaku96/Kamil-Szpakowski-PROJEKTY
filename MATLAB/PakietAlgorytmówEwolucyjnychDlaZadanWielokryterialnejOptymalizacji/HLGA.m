function [genotype4,phenotype,phenotype2] = HLGA(genotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,value,crossoverType)

    for i = 1 : populationNum
        for j = 1: numberOfFunctions
            weights(:,i) = rand(1,numberOfFunctions);
            weights(:,i) = weights(:,i)/sum(weights(:,i));
        end
    end 
   
    for i = 1 : populationNum
        finalValue(i) = 0;
        for j = 1: numberOfFunctions
            finalValue(i) = finalValue(i) + weights(j,i)*value(j,i);
        end
    end 

    
    selectedGenotype = proportional(genotype,populationNum,finalValue,variables);

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