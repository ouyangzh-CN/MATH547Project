%% Load data from Excel
% clear
% clc
% close all
% 
% loc_m=xlsread('Age.xlsx','male','A2:A9983');
% year_m=xlsread('Age.xlsx','male','D2:D9983');
% mean_m=xlsread('Age.xlsx','male','K2:K9983');
% 
% loc_f=xlsread('Age.xlsx','female','A2:A9983');
% year_f=xlsread('Age.xlsx','female','D2:D9983');
% mean_f=xlsread('Age.xlsx','female','K2:K9983');
% 
% loc_b=xlsread('Age.xlsx','both','A2:A9983');
% year_b=xlsread('Age.xlsx','both','D2:D9983');
% mean_b=xlsread('Age.xlsx','both','K2:K9983');

%% 2-order Fitting 
clear
clc
load('Age.mat')

j=1;
for c=1:522
    % male
    idx1=find(loc_m==c);
    year_m1=year_m(idx1);
    mean_m1=mean_m(idx1);
%     year_m1=zscore(year_m0);
%     mean_m1=zscore(mean_m0);%???????
    if(~isempty(idx1))
        sf_m = fit(year_m1, mean_m1, 'poly2');
        p_m(j,1)=sf_m.p1; % x^2
        p_m(j,2)=sf_m.p2; % x
        p_m(j,3)=sf_m.p3; % constant
        y_m(:,j)=mean_m1; % real value
        j=j+1;
    end
end

j=1;
for c=1:522
   % female
    idx2=find(loc_f==c);
    year_f1=year_f(idx2);
    mean_f1=mean_f(idx2);
%     year_f1=zscore(year_f0);
%     mean_f1=zscore(mean_f0);%???????
    if(~isempty(idx2))
        sf_f = fit(year_f1, mean_f1, 'poly2');
        p_f(j,1)=sf_f.p1; % x^2
        p_f(j,2)=sf_f.p2; % x
        p_f(j,3)=sf_f.p3; % constant
        y_f(:,j)=mean_f1; % real value
        j=j+1;
    end
end

j=1;
for c=1:522
    % both
    idx3=find(loc_b==c);
    year_b1=year_b(idx3);
    mean_b1=mean_b(idx3);
%     year_b1=zscore(year_b0);
%     mean_b1=zscore(mean_b0);%???????
    if(~isempty(idx3))
        sf_b = fit(year_b1, mean_b1, 'poly2');
        p_b(j,1)=sf_b.p1; % x^2
        p_b(j,2)=sf_b.p2; % x
        p_b(j,3)=sf_b.p3; % constant
        y_b(:,j)=mean_b1; % real value
        j=j+1;
    end
end

%% Plot
clear
clc
load('Age_fit.mat')
t = year_b1;
t_pre = t(end)+1:t(end)+5;

figure('DefaultAxesFontSize',12)
subplot(2,2,1)
j=1;
for i = [4,93,99,161,217]
    f(:,j) = p_m(i,1).*t.^2 + p_m(i,2).*t + p_m(i,3);
    f_pre(:,j) = p_m(i,1).*t_pre.^2 + p_m(i,2).*t_pre + p_m(i,3);
    scatter(t, y_m(:,i))
    hold on
    scatter(t_pre, f_pre(:,j), '*')
    j=j+1;
end
s1 = plot(t, f(:,1));
s2 = plot(t, f(:,2));
s3 = plot(t, f(:,3));
s4 = plot(t, f(:,4));
s5 = plot(t, f(:,5));
legend([s1,s2,s3,s4,s5],'China','UK','Canada','India','Sudan')
xlabel('Year'); 
ylabel('Male Age Standardized Education Years Per Capita');
hold off

subplot(2,2,2)
j=1;
for i = [4,93,99,161,217]
    f(:,j) = p_f(i,1).*t.^2 + p_f(i,2).*t + p_f(i,3);
    f_pre(:,j) = p_f(i,1).*t_pre.^2 + p_f(i,2).*t_pre + p_f(i,3);
    scatter(t, y_f(:,i))
    hold on
    scatter(t_pre, f_pre(:,j), '*')
    j=j+1;
end
s1 = plot(t, f(:,1));
s2 = plot(t, f(:,2));
s3 = plot(t, f(:,3));
s4 = plot(t, f(:,4));
s5 = plot(t, f(:,5));
legend([s1,s2,s3,s4,s5],'China','UK','Canada','India','Sudan')
xlabel('Year'); 
ylabel('Female Age Standardized Education Years Per Capita');
hold off

subplot(2,2,3)
j=1;
for i = [4,93,99,161,217]
    f(:,j) = p_b(i,1).*t.^2 + p_b(i,2).*t + p_b(i,3);
    f_pre(:,j) = p_b(i,1).*t_pre.^2 + p_b(i,2).*t_pre + p_b(i,3);
    scatter(t, y_b(:,i))
    hold on
    scatter(t_pre, f_pre(:,j), '*')
    j=j+1;
end
s1 = plot(t, f(:,1));
s2 = plot(t, f(:,2));
s3 = plot(t, f(:,3));
s4 = plot(t, f(:,4));
s5 = plot(t, f(:,5));
legend([s1,s2,s3,s4,s5],'China','UK','Canada','India','Sudan')
xlabel('Year'); 
ylabel('Age Standardized Education Years Per Capita');
hold off

subplot(2,2,4)
j=1;
for i = [4,93,99,161,217]
    f(:,j) = (p_m(i,1).*t.^2 + p_m(i,2).*t + p_m(i,3))./(p_f(i,1).*t.^2 + p_f(i,2).*t + p_f(i,3));
    f_pre(:,j) = (p_m(i,1).*t_pre.^2 + p_m(i,2).*t_pre + p_m(i,3))./(p_f(i,1).*t_pre.^2 + p_f(i,2).*t_pre + p_f(i,3));
    scatter(t, y_m(:,i)./y_f(:,i))
    hold on
    scatter(t_pre, f_pre(:,j), '*')
    j=j+1;
end
s1 = plot(t, f(:,1));
s2 = plot(t, f(:,2));
s3 = plot(t, f(:,3));
s4 = plot(t, f(:,4));
s5 = plot(t, f(:,5));
legend([s1,s2,s3,s4,s5],'China','UK','Canada','India','Sudan')
xlabel('Year'); 
ylabel('Age Standardized Male-Female Education Ratio');
hold off


