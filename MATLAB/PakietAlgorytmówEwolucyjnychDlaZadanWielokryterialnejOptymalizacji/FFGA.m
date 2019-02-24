function FFGA(populationNum,numberOfFunctions,value,minMax,phenotype,algorithmType,golIDX,HV,delta,iterations)

    for k = 1 : populationNum
        ranks(k) = 1;
        for i = 1 : populationNum
            counter(k) = 0;
            counter2(k) = 0;
            if i ~= k
                for j = 1 : numberOfFunctions
                    checkValue(j,k) = value(j,k);
                    if minMax(j) == 0
                        if checkValue(j,k) >= value(j,i)
                            counter(k) = counter(k) + 1;
                        end
                        if checkValue(j,k) > value(j,i)
                            counter2(k) = counter2(k) + 1;
                        end
                    elseif minMax(j)==1
                        if checkValue(j,k) <= value(j,i)
                            counter(k) = counter(k) + 1;
                        end
                        if checkValue(j,k) < value(j,i)
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
    end
    index = 1;
    for i = 1 : populationNum
       
        if ranks(i) == 1
             for j = 1 : numberOfFunctions
                front(j,index) = value(j,i);      
            end

            index = index+1;
        end
    end

    if numberOfFunctions==2

        ax2=subplot(2,2,2);
        scatter(ax2,value(1,:),value(2,:))
        hold on
        scatter(front(1,:),front(2,:),'r')
        hold on
        scatter(ax2,value(1,golIDX),value(2,golIDX),450,'g','x')

        xlabel("f1"); 
        ylabel("f2");
        if algorithmType == 1
            title("VEGA");
        elseif algorithmType == 2
            title("HLGA");
        elseif algorithmType == 3
            title("NPGA");
        elseif algorithmType == 4
            title("NSGA II");
        elseif algorithmType == 5
            title("MOGA");
        end

        ax= subplot(2,2,1);
        scatter(ax,phenotype(1,:),phenotype(2,:))
        xlabel("wartoœæ X"); 
        ylabel("wartoœæ Y");

    
    end
    t = 1 : iterations;

    ax= subplot(2,2,3);
    plot(ax,t,HV)
    title('HyperVolume')
    xlabel("iteracje"); 
    ylabel("HV");

    ax= subplot(2,2,4);
    plot(ax,t,delta)
    title('HyperCube')
    xlabel("iteracje"); 
    ylabel("HC");
    
    
    
    
%     x1 = -3:0.1:3;
%     x2 = -3:0.1:3;
%     
%     y1 = -x1.^2+10;
%     y2 = -(sqrt(y1) - 2 ).^2+10;
 
    %     for i = 1 : populationNum
%         if ranks(i) ==1
%             scatter(value(1,i),value(2,i),'r')
%         end
%     end
    
    index = 1;
    
        
    


    
%     sum1 = 0;
%     
%     [out,idx] = sort(ranks)
%     out = fliplr(out);
%     rank = 1;
%     index = 1;
%     
%     while index ~= populationNum+1
%       ranking(index) = rank;
%       index= index+1;
%       rank = rank+1;
%     end
%     
%     
%     for i = 1 : populationNum
%        for j = 1 : populationNum
%           if out(j) == ranks(i)
%               sorted(i) = ranking(j);
%           end
%        end
%     end
%     
%     sorted
%     
    
end