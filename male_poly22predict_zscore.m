clear
% 
% loc_m=xlsread('male.xlsx','A2:A59893');
% age_m=xlsread('male.xlsx','E2:E59893');
% year_m=xlsread('male.xlsx','D2:D59893');
% mean_m=xlsread('male.xlsx','K2:K59893');

load("male.mat");

name_m0=zeros(217,1);
name_m1=string(name_m0);

j=1;
for c=1:522
    idx1=find(loc_m==c);%从1开始找编号为c的地区，形成有序版
    year_m0=year_m(idx1);
    age_m0=age_m(idx1);
    mean_m0=mean_m(idx1);%调用该地区的信息

    
%     year_m1=year_m0/1000;%尺度缩放
%     age_m1=age_m0/100;
%     mean_m1=mean_m0;
    year_m1=zscore(year_m0);%zscore
    age_m1=zscore(age_m0);
    mean_m1=zscore(mean_m0);

    

    if(~isempty(idx1))%有这个编号的地区
        year_mean(j)=mean(year_m0);
        age_mean(j)=mean(age_m0);
        mean_mean(j)=mean(mean_m0);
        year_std(j)=std(year_m0);
        age_std(j)=std(age_m0);
        mean_std(j)=std(mean_m0);%有序版，循环外储存

        sf22 = fit([year_m1, age_m1],mean_m1,'poly22');%拟合
        p22(j,1)=sf22.p00;
        p22(j,2)=sf22.p10;
        p22(j,3)=sf22.p01;
        p22(j,4)=sf22.p20;
        p22(j,5)=sf22.p11;
        p22(j,6)=sf22.p02;
        name_m1(j)=name_m(idx1(1));%有序版
        j=j+1;
    end
end

%%
idxp(1)=find(name_m1=='United Kingdom');%国家编号有序版
idxp(2)=find(name_m1=='Canada');
idxp(3)=find(name_m1=='China');
idxp(4)=find(name_m1=='India');
idxp(5)=find(name_m1=='Sudan');
loc_pred=strings(1,5);
loc_pred(1)='United Kingdom';
loc_pred(2)='Canada';
loc_pred(3)='China';
loc_pred(4)='India';
loc_pred(5)='Sudan';

age_predi1=149;
age_predi2=154;
year_i=1970:2015;
year_6=[1970:2015 1970:2015 1970:2015 1970:2015 1970:2015 1970:2015];
year=zscore(year_6);

figure(15)
hold on

xlabel('Years'); 
ylabel('Mean of years of schooling');
title('Predict by 2*2 Polyfit');

for t=1:5
    age_pred1=(age_predi1-age_mean(idxp(t)))/age_std(idxp(t));
    age_pred2=(age_predi2-age_mean(idxp(t)))/age_std(idxp(t));
    mean_pred1(t,:) = p22(idxp(t),1) + p22(idxp(t),2)*year(1:46) + p22(idxp(t),3)*age_pred1 + p22(idxp(t),4)*year(1:46).^2 + p22(idxp(t),5).*year(1:46).*age_pred1 + p22(idxp(t),6)*age_pred1^2;
    mean_pred2(t,:) = p22(idxp(t),1) + p22(idxp(t),2)*year(1:46) + p22(idxp(t),3)*age_pred2 + p22(idxp(t),4)*year(1:46).^2 + p22(idxp(t),5).*year(1:46).*age_pred2 + p22(idxp(t),6)*age_pred2^2;
    

    idxmt1(t,:)=find(name_m==loc_pred(t)&age_m==age_predi1);%原始数据里t国家在age1上46年数据的位置，检验正确
    idxmt2(t,:)=find(name_m==loc_pred(t)&age_m==age_predi2);

%     mean_meanage1(t)=mean(mean_m(idxmt1(t,:)));% t国家在age1上46年的平均值
%     mean_meanage2(t)=mean(mean_m(idxmt2(t,:)));
%     mean_stdage1(t)=std(mean_m(idxmt1(t,:)));% t国家在age1上46年的方差
%     mean_stdage2(t)=std(mean_m(idxmt2(t,:)));

    mean_predi1(t,:)=mean_pred1(t,:)*mean_std(idxp(t))+mean_mean(idxp(t));
    mean_predi2(t,:)=mean_pred2(t,:)*mean_std(idxp(t))+mean_mean(idxp(t));
    plot(year_i,mean_predi1(t,:),'k-');
    plot(year_i,mean_predi2(t,:),'k-');

    mean_org1(t,:)=mean_m(idxmt1(t,:));
    mean_org2(t,:)=mean_m(idxmt2(t,:));
    plot(year_i,mean_org1(t,:),'or');
    plot(year_i,mean_org2(t,:),'or');
end

hold off