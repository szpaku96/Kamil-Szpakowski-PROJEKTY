function fronts = findFronts(populationNum,numberOfFunctions,value,minMax)
    finish = 0;
    front = 1;
    
    for i = 1:populationNum
        leftovers(i) = 1;
    end

    while finish == 0

        for k = 1 : populationNum
            if leftovers(k) == 1
            ranks(k) = 1;
                for i = 1 : populationNum
                    if leftovers(i) == 1
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
            end
        end
        
        for var = 1 : populationNum
            if ranks(var) == 1 && leftovers(var) == 1
                fronts(var) = front;
                leftovers(var) = 0;
            end
        end
        
        leftoversCounter = 0;
        
        for var = 1 : populationNum
            if leftovers(var) == 1
                leftoversCounter = leftoversCounter + 1;
            end
        end
        
        if leftoversCounter == 0
            finish = 1;
        end
        front = front + 1;
    end
end