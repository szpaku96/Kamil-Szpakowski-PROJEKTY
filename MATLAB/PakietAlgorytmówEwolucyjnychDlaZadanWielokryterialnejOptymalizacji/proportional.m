function [selectedGenotype] = proportional(genotype,numberOfChromosoms,valueOfIndividual,variables)
    
    [w,h] = size(genotype);
    
    for i = 1 : w
        for j = 1 : h
            crossedGenotype(i,j) = 0;
        end
    end
   
    suma = sum(valueOfIndividual);

    for i = 1:numberOfChromosoms
       adaptation(i)= valueOfIndividual(i)/suma;
    end

    for i = 1:numberOfChromosoms
        buf = 0;
        for j = 1:i
            buf = buf + adaptation(j);   
        end
        distribution(i) = buf;
    end


    for j = 1:numberOfChromosoms
        r = rand(1);
        winIndex = 1;
        
        for i = 1:numberOfChromosoms
            if r > distribution(i)
                winIndex = i;
            end
        end
        
        
        for g = 1: variables   
            selectedGenotype(j*variables+ g - variables,:) = genotype(variables*winIndex+g-variables,:);
        end
    end
    
end