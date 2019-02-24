function [genotype,phenotype,bitsLen] = createPopulation(populationNum,variables,minRange,maxRange,digits)
    
    for k = 1 : populationNum
        for i = 1 : variables % wyznaczane dla ka�dej zmiennej
            size(i) = maxRange(i) - minRange(i); % Dziedzina poszukiwa�
            size(i) = size(i) * 10^digits; % Ilo�� podprzedzia��w
            flag = 0; % flaga, kt�ra przerywa p�tl�
            j = 0; % pot�ga wyk�adnika
            while flag ~= 1
                if 2^j < size(i)
                   if 2^(j+1) >= size(i)
                      flag = 1; 
                   end
                end
                j= j+1;
            end
            bitsLen(i) = j+1; % zawiera d�ugo�ci bit�w 
        end
        
        for i = 1:variables
            % tworzymy genotyp 
            r = randi([0,1],1,bitsLen(i));
            decR = bi2de(r);

            for l = 1:bitsLen(i)
               genotype(k*variables+i-variables ,l) = r(l); 
            end

            decGenotype = bi2de(genotype(k*variables+ i - variables,:));
            phenotype(i,k) = minRange(i) + ((maxRange(i)-minRange(i)) * decGenotype )/ ((2^bitsLen(i))-1) ;
        end

    end

end