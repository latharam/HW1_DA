cndl = fopen('Canon_Doyle.txt');
jnat = fopen('Jane_Austin.txt');

samples_cd = textscan(cndl,'%s',10000);
samples_ja = textscan(cndl,'%s',10000);
stpwrd= fopen('english.stop');
Stop_words = textscan(stpwrd,'%s',1000);
stemmed_cd = text_preprocessing(samples_cd,Stop_words,10);
stemmed_ja = text_preprocessing(samples_ja,Stop_words,10);

[B,I,J] = unique(stemmed_cd,'rows');
%J give you repeated indexes, so the occurrences of J(ind)
%gives you the occurences of B(ind).
counts_cd = histc(J, 1:length(B));
mean_freq_cd= mean(counts_cd);
features_cd = B(1,counts_cd>mean_freq_cd);

[Bja,Ija,Jja] = unique(stemmed_ja,'rows');
%J give you repeated indexes, so the occurrences of J(ind)
%gives you the occurences of B(ind).
counts_ja = histc(Jja, 1:length(Bja));
mean_freq_ja= mean(counts_ja);
features_ja = B(1,counts_ja>mean_freq_ja);
features=[features_cd features_ja];


c1 = cvpartition(size(stemmed_cd,2),'holdout',0.2);
c2 = cvpartition(size(stemmed_ja,2),'holdout',0.2);
%Pfgivenc1 (i) = Good_Turing(features(1), 
cd_train = stemmed_cd(:,training(c1,1));
cd_test = stemmed_cd(:,test(c1,1));
%Pfgivenc1 = Good_Turing(features,stemmed_cd);
[Pfgivenc1,Pfgivenc2, occurances]  = estimator(features,cd_train,stemmed_ja,2);

Pf1 = size(training(c1,1))/(size(training(c1,1))+size(training(c2,1)));
Pf2 = 1-Pf1;
%detection



 fclose(stpwrd);
 
