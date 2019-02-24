function [crossedGenotype] = uniformCrossover(genotype,populationNum,variables,bitsLen,Pc)

    [w,h] = size(genotype);
    
    for i = 1 : w
        for j = 1 : h
            crossedGenotype(i,j) = 0;
        end
    end

 for k = 1:2:(populationNum)
        for i = 1 : variables
             r = rand(1);
             if r<Pc
                A = genotype((k-1)*variables+i,:);
                B = genotype(k*variables+i,:);
                len = bitsLen(i); 
                uniformVector = randi([0,1],1,len);
                for j = 1:len
                    if uniformVector(j) == 0
                        finalA(j) = A(j); % Potomek A' dostaje genotyp rodzica A
                        finalB(j) = B(j); % Potomek B' dostaje genotyp rodzica B
                    elseif uniformVector(j) == 1
                        finalA(j) = B(j); % Potomek A' dostaje genotyp rodzica B
                        finalB(j) = A(j); % Potomek B' dostaje genotyp rodzica A
                    end
                end
               bits = bitsLen(i);
                
                for g = 1 : bits
                    crossedGenotype((k-1)*variables+i,g) = finalA(1,g);
                    crossedGenotype(k*variables+i,g) = finalB(1,g);
                end

             else
                crossedGenotype((k-1)*variables+i,:) = genotype((k-1)*variables+i,:);
                crossedGenotype(k*variables+i,:) = genotype(k*variables+i,:);
             end
        end
    end
end



