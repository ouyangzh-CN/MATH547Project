X = xlsread('IHME_GLOBAL_EDUCATIONAL_ATTAINMENT_1970_2015_Y2015M04D27.CSV');
%X_ = zscore(X);
[row,col] = size(X);
X = (X - min(X) + 1)./(max(X) - min(X) + 1);

XX = [X_(:,2:5),randn(row,1)];
[lambda,psi,T,stats,F] = factoran(XX,2);
%[lambda,psi,T,stats,F] = factoran(X_(:,2:5),1);
lambda