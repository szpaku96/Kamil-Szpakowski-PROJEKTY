function [genotype3,phenotypeFIN,phenotype2] = VEGA(genotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,value,crossoverType)

    for i = 1: numberOfFunctions
        [out(i,:),idx(i,:)] = sort(value(i,:));
    end

    individualsPerFunction = populationNum/numberOfFunctions;
    startIndex = populationNum - individualsPerFunction;
    startIndex = startIndex;
    if startIndex == 0
        startIndex = 1;
    end
    
     for j = 1 : numberOfFunctions
         for i = 1 : individualsPerFunction
             for k = 1 : variables 
                %genotype2(j*individualsPerFunction+i-individualsPerFunction,:) = genotype(idx(j,startIndex+i),:);
                genotype2((j-1)*variables*individualsPerFunction+(i-1)*variables+k,:) = genotype(variables*idx(j,(startIndex+i))+(k-variables),:);
             end
         end
     end
     

     for k = 1 : populationNum
        for i = 1 : variables
            decGenotype = bi2de(genotype2(k*variables+ i - variables,:));
            phenotypeFIN(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )/ ((2^bitsLen(i))-1) ;
        end
     end
     
   
     [num,~] = size(genotype2);
     vec = randperm(num);
    
    for i = 1 : num
        genotypeRAND(i,:) = genotype2(vec(i),:);
    end
    

    if crossoverType == 1
        [genotype3] = crossover(genotypeRAND,populationNum,variables,bitsLen,Pc);
    elseif crossoverType ==2
        [genotype3] = multipleCrossover(genotypeRAND,populationNum,variables,bitsLen,Pc);
    elseif crossoverType == 3
        [genotype3] = uniformCrossover(genotypeRAND,populationNum,variables,bitsLen,Pc);
    end
    
    
    genotype3 = mutation(genotype3,populationNum,variables,bitsLen,Pm);
    
    for k = 1 : populationNum
        for i = 1 : variables
            decGenotype = bi2de(genotype3(k*variables+ i - variables,:));
            phenotype2(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )/ ((2^bitsLen(i))-1) ;
        end
    end

end