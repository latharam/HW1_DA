%estimator_type - 0 - Maximum likelihood estimation, 1 Laplace estimation,
%2- Good turing estimation
%thresholdF  - the threshold freq after we switch to using smoothed values
%in GT estimator
estimator_type = 2;
max_kfold = 10;
no_samples = 1000;
no_stpwrds = 1000;
no_of_featuresby2 = 100;
thresholdF = 3;

cndl = fopen('Canon_Doyle.txt');
jnat = fopen('Jane_Austin.txt');

samples_cd = textscan(cndl,'%s',no_samples);
samples_ja = textscan(jnat,'%s',no_samples);
stpwrd= fopen('english.stop');
Stop_words = textscan(stpwrd,'%s');
stemmed_cd = text_preprocessing(samples_cd,Stop_words,1);
stemmed_ja = text_preprocessing(samples_ja,Stop_words,1);

for kfold = 2:1:max_kfold   % changing the number of folds
c1 = cvpartition(size(stemmed_cd,2),'kfold',kfold);
c2 = cvpartition(size(stemmed_ja,2),'kfold',kfold);

for fold = 1:1:kfold  %predict for each fold 
%Pfgivenc1 (i) = Good_Turing(features(1), 
cd_train = stemmed_cd(:,training(c1,fold));
cd_test = stemmed_cd(:,test(c1,fold));

ja_train = stemmed_ja(:,training(c2,fold));
ja_test = stemmed_ja(:,test(c2,fold));

[B,I,J] = unique(cd_train,'rows');
%J give you repeated indexes, so the occurrences of J(ind)
%gives you the occurences of B(ind).
counts_cd = histc(J, 1:length(B));
mean_freq_cd= mean(counts_cd);
%features_cd = B(1,counts_cd>((3/4)*mean_freq_cd));
[sorted_f, ind ]= sort(counts_cd,'descend');
features_cd = B(1,ind(1: no_of_featuresby2));

[Bja,Ija,Jja] = unique(stemmed_ja,'rows');
%J give you repeated indexes, so the occurrences of J(ind)
%gives you the occurences of B(ind).
counts_ja = histc(Jja, 1:length(Bja));
mean_freq_ja= mean(counts_ja);
[sorted_fja, indja ]= sort(counts_ja,'descend');
features_ja = Bja(1,indja(1: no_of_featuresby2));
%features_ja = Bja(1,counts_ja> ((3/4)*mean_freq_ja));
features=unique([features_cd features_ja]);
%Pfgivenc1 = Good_Turing(features,stemmed_cd);
[Pfgivenc1,Pfgivenc2, occurances]  = estimator(features,cd_train,ja_train,estimator_type,thresholdF);

PC1 = 0.5;
%PC1 = size(training(c1,1))/(size(training(c1,1))+size(training(c2,1)));
PC2 = 1-PC1;
%detection

test_set{1} = cd_test;
test_set{2} = ja_test;
for t = 1:1:2
D = ismember(features, test_set{t});
Pdgivenc1 = D.*Pfgivenc1 + (~D.*(ones(size(Pfgivenc1))- Pfgivenc1));
PC1givenD(fold)=sum(log(Pdgivenc1)) + log(PC1);
%PthatJA=prod(FinTest.*Pfgivenc2)*Pf2;

Pdgivenc2 = D.*Pfgivenc2 + (~D.*(ones(size(Pfgivenc2))- Pfgivenc2));
PC2givenD(fold)=sum(log(Pdgivenc2)) + log(PC2);

Decision(t,fold) = (PC1givenD(fold) > PC2givenD(fold) );

end

% D = ismember(features, cd_test);
% Pdgivenc1 = D.*Pfgivenc1 + (~D.*(ones(size(Pfgivenc1))- Pfgivenc1));
% PC1givenD(fold)=sum(log(Pdgivenc1)) + log(PC1);
% %PthatJA=prod(FinTest.*Pfgivenc2)*Pf2;
% 
% Pdgivenc2 = D.*Pfgivenc2 + (~D.*(ones(size(Pfgivenc2))- Pfgivenc2));
% PC2givenD(fold)=sum(log(Pdgivenc2)) + log(PC2);
% 
% Decision1 = (PC1givenD > PC2givenD);

end
Prediction = [Decision(1 , :),Decision(2 , : )];
ground_truth = [ones(1,kfold),zeros(1,kfold)];
class_labels = [ 0 ;  1];
[precision, recall] = Precision_recall(ground_truth,Prediction, class_labels);
avg_precision(kfold) = sum(precision)/size(precision,2);
avg_recall(kfold) = sum(recall)/size(recall,2);
end

figure
plot(avg_precision)
title('avg_precion vs no of folds ');
xlabel('no of sentences/folds');
ylabel('avg_precision');
figure
plot(avg_recall)
title('avg_recall vs no of folds ');
xlabel('no of sentences/folds');
ylabel('avg_recall');
fclose(stpwrd);
 
