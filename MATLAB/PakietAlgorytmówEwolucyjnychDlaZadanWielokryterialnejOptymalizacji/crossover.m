function [crossedGenotype] = crossover(genotype,populationNum,variables,bitsLen,Pc)

    [w,h] = size(genotype);
    
    for i = 1 : w
        for j = 1 : h
            crossedGenotype(i,j) = 0;
        end
    end

    for k = 1:2:(populationNum)
        for i = 1 : variables
            
             r = rand(1); % Wylosowanie liczby z przedzia³u <0,1>
             if r<Pc % Porównanie z prawdopodobieñstwem krzy¿owania 
                A = genotype((k-1)*variables+i,:); % Do zmiennych A i B
                B = genotype(k*variables+i,:); % przepisanie odpowiedniego genotypu
                len = bitsLen(i); % maksymalny zakres puunktu krzy¿owania
                cut = randi(len-1); % losownie punktu przeciêcia
                for j = 1:len 
                    if i <= cut % Do punktu przeciêcia
                        finalA(j)= A(j); % Potomek A' dostaje genotyp rodzica A
                        finalB(j)= B(j); % Potomek B' dostaje genotyp rodzica B
                    else % Po punkcie przeciêcia
                        finalA(j)=B(j); %Potomek A' dostaje genotyp rodzica B
                        finalB(j)=A(j); %Potomek B' dostaje genotyp rodzica A
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

%         if variables == 1
%             for k = 1:2:(populationNum)
%                  r = rand(1);
%                  if r<Pc
%                     A = genotype(k,:);
%                     B = genotype(k+1,:);
%                     len = bitsLen(1); % len oznacza d³ugoœæ wektora
%                     cut = randi(len-1); % cut, miejsce przeciecia
%                     for i = 1:len % zamiana 
%                         if i <= cut
%                             finalA(i)= A(i);
%                             finalB(i)= B(i);
%                         else
%                             finalA(i)=B(i);
%                             finalB(i)=A(i);
%                         end
%                     end
%                     crossedGenotype(k,:) = finalA(1,:);
%                     crossedGenotype(k+1,:) = finalB(1,:);
%                  else
%                      crossedGenotype(k,:) = genotype(k,:);
%                     crossedGenotype(k+1,:) = genotype(k+1,:);
%                  end
%                 
%             end
%             
%         elseif variables ==2
%             for k = 1:4:(populationNum*variables)
%                  r = rand(1);
%                  if r<0.6
%                     A = genotype(k,:);
%                     B = genotype(k+1,:);
%                     C = genotype(k+2,:);
%                     D = genotype(k+3,:);
% 
%                     len = bitsLen(2);
%                     cut = randi(len-1);
%                     cut2 = len - cut;
%                     for i = 1:len % zamiana 
%                         if i <= cut
%                             newA(1,i)= A(i);
%                             newA(2,i)= B(i);
%                         else
%                             newA(1,i)=B(i);
%                             newA(2,i)=A(i);
%                         end
% 
%                         if i<= cut2
%                             newB(1,i)= C(i);
%                             newB(2,i)= D(i);
%                         else
%                             newB(1,i)= D(i);
%                             newB(2,i)= C(i);
%                         end    
%                     end
% 
%                     finalA(1,:) = newA(1,:);
%                     finalA(2,:) = newB(2,:);
% 
%                     finalB(1,:) = newB(1,:);
%                     finalB(2,:) = newA(2,:);
% 
%                     crossedGenotype(k,:) = finalA(1,:);
%                     crossedGenotype(k+1,:) = finalA(2,:);
%                     crossedGenotype(k+2,:) = finalB(1,:);
%                     crossedGenotype(k+3,:) = finalB(2,:);
%                  else
%                     crossedGenotype(k,:) = genotype(k,:);
%                     crossedGenotype(k+1,:) = genotype(k+1,:);
%                     crossedGenotype(k+2,:) = genotype(k+2,:);
%                     crossedGenotype(k+3,:) = genotype(k+3,:);
%                  end
%             end
%         end

    end

