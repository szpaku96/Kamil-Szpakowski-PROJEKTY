function [crossedGenotype] = multipleCrossover(genotype,populationNum,variables,bitsLen,Pc)

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
                len = bitsLen(i);
                numberOfCuts = randi([1,4],1);
                cuts = randperm(len-1,numberOfCuts); 
                cuts = sort(cuts);
                cuts(numberOfCuts+1) = len;
                A = genotype((k-1)*variables+i,:);
                B = genotype(k*variables+i,:);

                j=1;
                
                for m = 1:len 
                    while j<=numberOfCuts+1 
                        buf = mod(j,2);
                        if buf == 1
                            for b = m:cuts(j)
                                finalA(b)= A(b); % Potomek A' dostaje genotyp rodzica A
                                finalB(b)= B(b); % Potomek B' dostaje genotyp rodzica B
                            end
                        j=j+1;
                        else
                            for b = m:cuts(j)
                                finalA(b)=B(b);% Potomek A' dostaje genotyp rodzica B
                                finalB(b)=A(b); % Potomek B' dostaje genotyp rodzica A
                            end
                        j=j+1;
                        end
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






