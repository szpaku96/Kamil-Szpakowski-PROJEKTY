function[genotype] = mutation(genotype,populationNum,variables,bitsLen,probability)
    for i = 1:populationNum
        for g =1:variables
            x = rand(1,bitsLen(g));
            for k = 1 : bitsLen(g)
               if x(k)< probability
                   if genotype(i*variables+ g - variables,k) == 1
                       genotype(i*variables+ g - variables,k) = 0;
                   else
                       genotype(i*variables+ g - variables,k)= 1;
                   end
               end
            end
        end
    end
end

