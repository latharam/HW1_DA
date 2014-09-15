%ControlCentor
% Example 1:
XVector = [0 0 0 0 1 1 0 1 1 1];
YVector = [0 0 0 0 0 0 1 1 1 1];

% Input : the data of two variables X,Y as XVector and YVector
% Output: "Sig" returns 1 if X and Y significantly associate otherwise 0
%         "PValue" returns the computed p-value
%         "ContigenMatrix" returns the m*n contingency table

[ Sig,PValue,ContigenMatrix ] = FisherExactTest( XVector,YVector )

% In this algorithm, m*n contingency table is given as input data.
[ Sig,PValue ] = FisherExactTest( ContigenMatrix )


% Example 2: 
XVector = [0 2 0 2 3 1 0 2 1 1 1 2 3 4 4 2 3 1];
YVector = [0 1 3 2 1 0 0 1 2 1 0 1 1 4 3 0 1 4];

[ Sig,PValue,ContigenMatrix ] = FisherExactTest( XVector,YVector )

% In this algorithm, m*n contingency table is given as input data.
[ Sig,PValue ] = FisherExactTest( ContigenMatrix )
