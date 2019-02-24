function [newPopulation] = rangeMethod(oldPopulation,numberOfChromosoms,variables)
    
    valueOfIndividual = valueOfPopulation(oldPopulation,numberOfChromosoms)
    [out,idx] = sort(valueOfIndividual);
    out = fliplr(out);
    valueOfIndividual(2,:) = out;
    valueOfIndividual(idx);
    rank = 1;
    index = 1;
    
    while index ~= numberOfChromosoms+1
      ranking(index) = rank;
      index= index+1;
      rank = rank+1;
    end
    
    valueOfIndividual(3,:) = ranking;
    
    for i = 1 : numberOfChromosoms
       for j = 1 : numberOfChromosoms
          if out(j) == valueOfIndividual(1,i)
              valueOfIndividual(4,i) = valueOfIndividual(3,j);
          end
       end
    end
    valueOfIndividual(4,:)

    
    for i = 1 : numberOfChromosoms
        part1(i) = 1-(valueOfIndividual(3,i)/numberOfChromosoms);
    end
    sumPart1 = sum(part1);
    minPart1 = min(part1)
    maxPart1 = max(part1)

    
%valueOfIndividual:
%[1] - values [2] - sorted  [3] wyliczone indeksy [4] dopasowane indeksy


    newPopulation=oldPopulation;
    
end



%     while index ~= numberOfChromosoms
%        if out(index) > out(index+1)
%           ranking(index) = rank;
%           index= index+1;
%           rank = rank+1;
%        else
%           ranking(index) = rank;
%           index = index+1;
%        end
%     end
%     
%     if out(numberOfChromosoms-1) == out(numberOfChromosoms)
%         ranking(numberOfChromosoms)=ranking(numberOfChromosoms-1);
%     else
%         ranking(numberOfChromosoms) = ranking(numberOfChromosoms-1) + 1;
%     end
%     
%     valueOfIndividual(3,:) = ranking;
%     
%     for i = 1 : numberOfChromosoms
%        for j = 1 : numberOfChromosoms
%           if out(j) == valueOfIndividual(1,i)
%               valueOfIndividual(4,i) = valueOfIndividual(3,j);
%           end
%        end
%     end