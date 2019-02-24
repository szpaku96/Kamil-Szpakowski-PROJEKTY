function[HV,golVAL,golIDX,delta,GOLMIN,fimin] = WSKAZNIKI(value,numberOfFunctions,populationNum,minMax)

    HV = 0;
    %%% HYPER VOLUME
    for i = 1 : populationNum
        if value(1,i) * value(2,i) < 0
            value(1,i) = value(1,i)*(-1);
        end
        HV = HV + value(1,i) * value(2,i);
    end
    
    %%% GLOBAL OPTIMALITY LEVEL
    for j = 1 : numberOfFunctions
        [fmax,fmaxidx] = max(value(j,:));
        for i = 1 : populationNum
            fi(j,i) = value(j,i) / fmax;
        end
        
        [fmin,fminidx] = min(value(j,:));
        for i = 1 : populationNum
            fimin(j,i) = value(j,i) / fmin;
        end
    end
    
    for i = 1 : populationNum
        GOL(i) = min(fi(:,i));
        GOLMIN(i) = max(fimin(:,i));
    end
 
    if minMax(1) == 1
    [golVAL,golIDX] = max(GOL);
    else
        [golVAL,golIDX] = min(GOLMIN);
    end
    
    %%% HYPERCUBE
    delta = 1;
    for j = 1 : numberOfFunctions
        fmax = max(value(j,:));
        if fmax < 0
            fmax = fmax *(-1);
        end
        delta = delta * fmax;
    end
    
    
   %%% HYPER RADIUS
   
   radius = delta.^(1/numberOfFunctions);
   
   

    
    
end