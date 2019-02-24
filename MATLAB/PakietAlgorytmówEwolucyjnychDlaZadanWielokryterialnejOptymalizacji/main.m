populationNum =300; % ILOŒÆ OSOBNIKOW
iterations = 100; % ITERACJE
minRange = [-3.1415, -3.1415]; % DOLNE ZAKRESY ZMIENNYCH
maxRange = [3.1415, 3.1415]; % GÓRNE ZAKRESY ZMIENNYCH

digits =3; % ILOŒÆ MNIEJSC PO PRZECINKU DLA ROZWI¥ZAÑ
niche = 0.2; % PROMIEN NISZY
[~,variables] = size(minRange); % OBLICZANA ILOŒÆ ZMIENNYCH
Pc = 0.6; % PRAWDOPODOBIENSTWO KRZY¯OWANIA
Pm = 0.01; % PRAWDOPODOBIEÑSTWO MUTACJI

% TYP OPTYMALIZACJI DLA KAZDEJ FUNKCJI
% 1 - MAKSYMALIZACJA
% 0 - MINIMALIZACJA
minMax = [1 1 ];

% WYBÓR ALGORYTMU
% 1 - VEGA
% 2 - HLGA
% 3 - NPGA
% 4 - NSGA
% 5 - MOGA
algorithmType = 1;

% WYBOR KRZYZOWANIA
% 1 - JEDNOPUNKTOWE
% 2 - WIELOPUNKTOWE
% 3 - JEDNORODNE
crossoverType = 2;

% TWORZENIE POPULACJI
[genotype,phenotype,bitsLen] = createPopulation(populationNum,variables,minRange,maxRange,digits);

% OBLICZANIE WARTOSCI FUNKCJI
[value,numberOfFunctions,realfun] = valueOfFunctions(phenotype,populationNum,variables,minMax);
% VALUE JEST WARTOŒCI¥ FUNKCJI PRZYSTOSOWANIA ( BEZ UJEMNYCH WARTOŒCI )
% REALFUN JEST PRAWDZIW¥ WARTOŒCI¥ FUNKCJI ( ZAWIERA UJEMNE WARTOŒCI )
fin = phenotype;

for iterations = 1:iterations
    iterations
    
    if algorithmType == 4
        [genotype2,phenotype2,fin] = NSGA(genotype,fin,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,realfun,minMax,crossoverType);
    elseif algorithmType ==3 
        [genotype2,phenotype2,fin] = NPGA(genotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,realfun,minMax,niche,crossoverType);
    elseif algorithmType ==1 
        [genotype2,phenotype2,fin] = VEGA(genotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,value,crossoverType);
    elseif algorithmType ==2 
        [genotype2,phenotype2,fin] = HLGA(genotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,value,crossoverType);
    elseif algorithmType ==5 
        [genotype2,phenotype2,fin] = Algorithm5(genotype,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,realfun,minMax,niche,crossoverType);
    elseif algorithmType ==6 
        [genotype2,phenotype2,fin] = NSGA1(genotype,value,populationNum,variables,bitsLen,Pc,Pm,minRange,maxRange,numberOfFunctions,realfun,minMax,crossoverType,niche);
    
    end
    % PHENOTYPE2 ZAWIERA FENOTYP PO SELEKCJI, PRZED KRZY¯OWANIEM I MUTACJ¥
    % FIN ZAWIERA FENOTYP PO KRZY¯OWANIU I MUTACJI
    
    [value,numberOfFunctions,realfun] = valueOfFunctions(fin,populationNum,variables,minMax);
    genotype=genotype2;
   
    [HV(iterations),golVAL,golIDX,delta(iterations),gol,fi]=WSKAZNIKI(value,numberOfFunctions,populationNum,minMax);
end

%[value,numberOfFunctions,realfun] = valueOfFunctions(phenotype2,populationNum,variables,minMax);
FFGA(populationNum,numberOfFunctions,realfun,minMax,phenotype2,algorithmType,golIDX,HV,delta,iterations);

for i = 1 : variables
    D=['x(',num2str(i),')=',num2str(phenotype2(i,golIDX))];
    disp(D)
end
for i = 1 : numberOfFunctions
    D=['f',num2str(i),'(X)=',num2str(realfun(i,golIDX))];
    disp(D)
end
