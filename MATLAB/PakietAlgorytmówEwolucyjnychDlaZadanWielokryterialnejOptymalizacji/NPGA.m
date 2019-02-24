function [genotype4,phenotype,phenotype2] = NPGA(genotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,value,minMax,niche,crossoverType)
 
nacisk=10;

    for u = 1 : populationNum
        randomPop = randperm(populationNum,2+populationNum/nacisk);
        competitors(1) = randomPop(1);
        competitors(2) = randomPop(2);

        for i = 1: populationNum/nacisk
            comparisionSet(i) = randomPop(i+2);
        end

         for i = 1: populationNum
            leftovers(i) = 0;
        end

        for i = 1: populationNum/nacisk
            leftovers(comparisionSet(i)) = 1;
        end

        for k = 1 : 2
            ranks(k) = 1;
            for i = 1 : populationNum/nacisk
                counter(k) = 0;
                counter2(k) = 0;
                for j = 1 : numberOfFunctions
                    checkValue(j,k) = value(j,competitors(k));
                    if minMax(j) == 0
                        if checkValue(j,k) >= value(j,comparisionSet(i))
                            counter(k) = counter(k) + 1;
                        end
                        if checkValue(j,k) > value(j,comparisionSet(i))
                            counter2(k) = counter2(k) + 1;
                        end
                    elseif minMax(j)==1
                        if checkValue(j,k) <= value(j,comparisionSet(i))
                            counter(k) = counter(k) + 1;
                        end
                        if checkValue(j,k) < value(j,comparisionSet(i))
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
    
      for i = 1 : 2
        counterNiche(i) = 0;
        for j = 1:populationNum
           sum = 0;
           for k = 1 : numberOfFunctions
               sum = sum +( value(k,j) - value(k,competitors(i)) ).^2;
           end
           dist = sqrt(sum);
           if dist < niche
               counterNiche(i) = counterNiche(i) + 1 ;
           end
        end
      end           
  
        
    i=1;
        if (ranks(i) == 1 && ranks(i+1) == 1) || ((ranks(i) >1 && ranks(i+1) > 1))
            if counterNiche(i) >= counterNiche(i+1)
                winIndex(u) = competitors(i+1);
            elseif counterNiche(i) < counterNiche(i+1)
                winIndex(u) = competitors(i);
            end
        elseif ranks(i) == 1 && ranks(i+1) > 1
            winIndex(u) = competitors(i); 
        elseif ranks(i) >1  && ranks(i+1) == 1
            winIndex(u) = competitors(i+1);
        end
    end

    for j = 1 : populationNum
        for g = 1: variables
            selectedGenotype(j*variables+ g - variables,:) = genotype(variables*winIndex(j)+g-variables,:);
        end
    end
    
    for k = 1 : populationNum
        for i = 1 : variables
            decGenotype = bi2de(selectedGenotype(k*variables+ i - variables,:));
            phenotype(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )...
            /((2^bitsLen(i))-1) ;
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