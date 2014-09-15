function P_value = FisherExactTest_R( X,Y ) 
% if only one parameter is set, we assume it's a contigency table.
% if two parameters are set, we consider them as two vectors. 

% Fisher exact test is done by R language, in the form: fisher.test(x,y)
% Herein, the null hypothesis is that x and y is independent, the
% alternative hypothesis can be "less","great","two.sides". If the p_value
% is less than 0.05, it means that x and y is dependent.

callR('.REvalString','ftest <- function(Table){S=fisher.test(Table, alternative = "two.sided"); return(S$p.value); }');

if nargin == 1 % it is a table.
   P_value = callR('ftest',X);
elseif nargin == 2
   P_value = callR('ftest',ContingencyTable(X,Y) );
end

end
