% NAIVE BAYES CLASSIFIER
%distr
%fold


clear
tic
disp('--- start ---')

distr='normal';
%distr='kernel';

% read data
%White_Wine = dataset('xlsfile', 'White_Wine.xlsx');
iris_table = readtable('iris_data.txt');
%X = double(White_Wine(:,1:11));
%Y = double(White_Wine(:,12));

X = double(iris_table{ :,{'sepal_length','sepal_width','petal_length','petal_width'}});
Y = iris_table{:,{'class'}};
% Create a cvpartition object that defined the folds

kfold=5;
c = cvpartition(Y,'kfold',kfold);
for fold = 1:1:kfold
% Create a training set
x = X(training(c,fold),:);
y = Y(training(c,fold));
% test set
u=X(test(c,fold),:);
v=Y(test(c,fold),:);

yu=unique(y);
nc=length(yu); % number of classes
ni=size(x,2); % independent variables
ns=length(v); % test set

% compute class probability
for i=1:nc
    %fy(i)=sum(double(y==yu(i)))/length(y);
    fy(i)=sum(strcmp(y,yu(i)))/length(y);
end

switch distr
    
    case 'normal'
        
        % normal distribution
        % parameters from training set
        for i=1:nc
            %xi=x((y==yu(i)),:);
             xi=x((strcmp(y,yu(i))),:);
             mu(i,:)=mean(xi,1);
            sigma(i,:)=std(xi,1);
        end
        % probability for test set
        for j=1:ns
            fu=normcdf(ones(nc,1)*u(j,:),mu,sigma);
            P(j,:)=fy.*prod(fu,2)';
        end

    case 'kernel'

        % kernel distribution
        % probability of test set estimated from training set
        for i=1:nc
            for k=1:ni
                %xi=x(y==yu(i),k);
                xi=x(strcmp(y,yu(i)),k);
                ui=u(:,k);
                fuStruct(i,k).f=ksdensity(xi,ui);
            end
        end
        % re-structure
        for i=1:ns
            for j=1:nc
                for k=1:ni
                    fu(j,k)=fuStruct(j,k).f(i);
                end
            end
            P(i,:)=fy.*prod(fu,2)';
        end

    otherwise
        
        disp('invalid distribution stated')
        return

end

% get predicted output for test set
[pv0,id]=max(P,[],2);
for i=1:length(id)
    pv(i,1)=yu(id(i));
end

% compare predicted output with actual output from test data
confMat=myconfusionmat(v,pv);
disp('confusion matrix for this fold:')
disp(confMat)

%conf=sum(pv==v)/length(pv);
conf(fold)=sum(strcmp(pv,v))/length(pv);
disp(['accuracy of this fold = ',num2str(conf(fold)*100),'%'])
end
no_of_bins = 10;
figure
hist(iris_table{:,{'sepal_length'}},no_of_bins);
figure
hist(iris_table{:,{'sepal_width'}},no_of_bins);
figure
hist(iris_table{:,{'petal_length'}},no_of_bins);
figure

isSW_gaussian = chi2gof(iris_table{:,{'sepal_width'}});
isSL_gaussian = chi2gof(iris_table{:,{'sepal_length'}});
isPW_gaussian = chi2gof(iris_table{:,{'petal_width'}});
isPL_gaussian = chi2gof(iris_table{:,{'petal_length'}});

if(isSW_gaussian == 1 )
    disp('sepal width is not gaussian')
else
    disp('sepal width is gaussian')
end
if(isSL_gaussian == 1 )
    disp('sepal length is not gaussian')
else
    disp('sepal length is gaussian')
end
if(isPW_gaussian == 1 )
    disp('petal width is not gaussian')
else
    disp('petal width is gaussian')
end
if(isPL_gaussian == 1 )
    disp('petal length is not gaussian')
else
    disp('petal length is gaussian')
end

hist(iris_table{:,{'petal_width'}},no_of_bins);

for class = 1:1:3
    
[ Sig_slsw,PValue_slsw,ContigenMatrix_slsw ] = FisherExactTest( iris_table{50*(class-1)+1:50*class,{'sepal_width'}},iris_table{50*(class-1)+1:50*class,{'sepal_length'}} );
[ Sig_slpl,PValue_slpl,ContigenMatrix_slpl ] = FisherExactTest( iris_table{50*(class-1)+1:50*class,{'petal_length'}},iris_table{50*(class-1)+1:50*class,{'sepal_length'}} );
[ Sig_pwpl,PValue_pwpl,ContigenMatrix_pwpl ] = FisherExactTest( iris_table{50*(class-1)+1:50*class,{'petal_width'}},iris_table{50*(class-1)+1:50*class,{'petal_length'}} );
[ Sig_pwsw,PValue_pwsw,ContigenMatrix_pwsw ] = FisherExactTest( iris_table{50*(class-1)+1:50*class,{'petal_width'}},iris_table{50*(class-1)+1:50*class,{'sepal_width'}} );
[ Sig_swpl,PValue_swpl,ContigenMatrix_swpl ] = FisherExactTest( iris_table{50*(class-1)+1:50*class,{'sepal_width'}},iris_table{50*(class-1)+1:50*class,{'petal_length'}} );
[ Sig_pwsl,PValue_pwsl,ContigenMatrix_pwsl ] = FisherExactTest( iris_table{50*(class-1)+1:50*class,{'petal_width'}},iris_table{50*(class-1)+1:50*class,{'sepal_length'}} );


if(Sig_slsw == 1 )
    disp('sepal length and sepal width are not independant within class -')
    disp(class)
end

if(Sig_slpl == 1 )
    disp('sepal length and petal length are not independant within class-' )
    disp(class)
else
    disp('sepal length and petal length are independant within class -')
    disp(class)
end

if(Sig_pwpl == 1 )
    disp('petal width and petal length are not independant within class -')
    disp(class)
else
     disp('petal width and petal length are independant within class -')
    disp(class)
end
if(Sig_pwsw == 1 )
    disp('petal width and sepal width are not independant within class -')
    disp(class)
else
     disp('petal width and petal length are independant within class -')
    disp(class)
end
if(Sig_swpl == 1 )
    disp('sepal width and petal length are not independant within class -')
    disp(class)
else
    disp('sepal width and petal length are independant within class -')
    disp(class)

end
if(Sig_pwsl == 1 )
    disp('petal width and sepal length are not independant within class-')
    disp(class)
end
end
toc