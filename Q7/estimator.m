function [Pfgivenc1, Pfgivenc2, occurances]  = estimator(features,stemmed_cd,stemmed_ja,estimator_type, thresholdF)

[B,I,J] = unique(stemmed_cd,'rows');
%J give you repeated indexes, so the occurrences of J(ind)
%gives you the occurences of B(ind).
counts_cd = histc(J, 1:length(B));
occurances = zeros(size(features));
for j = 1 : 1: size(features,2)
    for i = 1 : 1: size(B,2)
       if(strcmp(B{i},features{j}))
          occurances(j) = counts_cd(i);
          break;
       end
    end
end

total_occurances = sum(occurances);

[Bja,Ija,Jja] = unique(stemmed_ja,'rows');
%J give you repeated indexes, so the occurrences of J(ind)
%gives you the occurences of B(ind).

counts_ja = histc(Jja, 1:length(Bja));
occurances_ja = zeros(size(features));

for j = 1 : 1: size(features,2)
    for i = 1 : 1: size(Bja,2)
       if(strcmp(Bja{i},features{j}))
          occurances_ja(j) = counts_ja(i);
          break;
       end
    end
end

total_occurances_ja = sum(occurances_ja);
switch estimator_type 
    
    case 0 %Maximum likelihood estimator
        Pfgivenc2 = (occurances_ja)/(total_occurances_ja);
        Pfgivenc1 = (occurances )/(total_occurances);
    case 1 %Laplace estimator
        Pfc2 = (occurances_ja + ones(size(occurances_ja)))./(total_occurances_ja+size(features{2},2));
        Pfc1 = (occurances + ones(size(occurances)))./(total_occurances+size(features{1},2));
        Pfgivenc1 = Pfc1 ./ sum (Pfc1);
        Pfgivenc2 = Pfc2 ./ sum (Pfc2);
    case 2 %Good-TUring estimator
%J give you repeated indexes, so the occurrences of J(ind)
%gives you the occurences of B(ind).
            Pfgivenc1 = Good_Turing(occurances, thresholdF);
            Pfgivenc2 = Good_Turing(occurances_ja, thresholdF);
        
    end