function [fun,numberOfFunctions,realfun] = valueOfFunctions(phenotype,populationNumber,numberOfVariables,minMax)

    for i = 1 : populationNumber
        for j = 1 : numberOfVariables
            x(j) = phenotype(j,i);
        end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%% PONI¯EJ WPISYWAÆ WARTOŒCI FUNKCJI ZGODNIE Z PRZYK£ADEM %%%%%%%%%%%

    %      PRZYK£AD
    %      fun(1,i) =  x(1);
    %      fun(2,i) =  x(2)+x(3);

    A1 = 0.5*sin(1)-2*cos(1)+sin(2)-1.5*cos(2);
    A2 = 1.5*sin(1)-cos(1)+2*sin(2)-0.5*cos(2);
    B1 = 0.5*sin(x(1))-2*cos(x(1))+sin(x(2))-1.5*cos(x(2));
    B2 = 1.5*sin(x(1))-cos(x(1))+2*sin(x(2))-0.5*cos(x(2));

    fun(1,i) = -(1+((A1-B1).^2)+ ((A2-B2).^2))+80;
    fun(2,i) = -((x(1)+3).^2 + (x(2)+1).^2)+80;
    
%      fun(1,i) = ((x(1) - 2).^2)/2 + (( x(2) + 1 )^2)/13 + 40;
%      fun(2,i) = ((x(1) +x(2) -3 ).^2)/36 + (( -(x(1)) + x(2) + 2 )^2)/8 + 40;
%      fun(3,i) = ((x(1) +2* x(2) -1 ).^2)/175 + ((2*x(2) - x(1) )^2)/17 + 40;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
 
    end  
    
    [numberOfFunctions,~] = size(fun);
    realfun = fun;
    
     % 0 - min 1 - max
    
    for i = 1 : numberOfFunctions
       if minMax(i) == 0
           for j = 1 : populationNumber
                fun(i,j) = -1*fun(i,j);
           end
           minimum =  min(fun(i,:));
           if minimum < 0
               for j = 1 : populationNumber
                  fun(i,j) = fun(i,j) - minimum; 
               end

            end
           
       elseif minMax(i) ==1
           minimum =  min(fun(i,:));
            if minimum < 0
               for j = 1 : populationNumber
                  fun(i,j) = fun(i,j) - minimum; 
               end
           
            end
            
       end
   
end