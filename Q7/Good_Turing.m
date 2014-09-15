% oc = load('occurances.mat');
%  occurances = oc.occurances( : );
%  threshold = 10;
 function [Pfgivenc1] = Good_Turing (occurances, threshold) 
 %Nr1 = zeros(size(occurances));
 %Nr = zeros(size(occurances));
 Pfc1 = zeros(size(occurances));
[sorted_occurances, ind_occurances] = sort(occurances);
        for i = 1:1:size(occurances,2)
            Nr(i) = sum(occurances == occurances(i));
        end
        for j = 1:1:size(sorted_occurances,2)
            if(j ==1)
                lower = 1;
                 r = occurances(ind_occurances(j));
                for k = 1:1:size(sorted_occurances,2);
                     if(sorted_occurances(k) > r)
                         upperl = k;
                         %k = size(sorted_occurances,2);
                         break;
                     end
                 end
                
            else
                if(j==size(sorted_occurances,2))
                    r = occurances(1,ind_occurances(j));
                 lower = 1;
                 for k = size(sorted_occurances,2):-1:1;
                     if(sorted_occurances(k) < r)
                         lower = k;
                         break;
                     end
                 end
                  %  upper = 2*r - lower;
                    upperl = (size(occurances,2));
                  
                else
                 r = occurances(ind_occurances(j));
                 
                 for k = size(sorted_occurances,2):-1:1;
                     if(sorted_occurances(k) < r)
                         lower = k;
                         break;
                     end
                 end
                 for k = 1:1:size(sorted_occurances,2);
                     if(sorted_occurances(k) > r)
                         upperl = k;
                         break;
                     end
                 end
                % Zr(j) = Nr(ind_occurances(j))/(0.5*(sorted_occurances(upper) - sorted_occurances(lower)));
                end
            end  
             %Zr(j) = Nr(1,ind_occurances(j))/(0.5*(sorted_occurances(upper,1) - sorted_occurances(lower,1)));
             Zr(j) = Nr(ind_occurances(j))/(0.5*(sorted_occurances(1,upperl) - sorted_occurances(1,lower)));
       
        end
       % Sr = fit(Zr, occurances(ind_occurances(j),1),'poly2');
        Sr = fit(Zr', sorted_occurances','poly1')
        b = Sr.p1;
        total_occurances = sum(occurances);
       for i = 1:1: size(occurances,2)
        Nr1(i) = sum(occurances == occurances(i)+1);
        if ( occurances(i) < threshold)
        Pfc1(i) = ((occurances(i)+1)/total_occurances)*(Nr1(i)/Nr(i));    
        else
        Pfc1(i) = occurances(i)* (1+ (1/occurances(i)))^(b -1);
        end
        Pfgivenc1 = Pfc1 ./ sum (Pfc1);
        end
       