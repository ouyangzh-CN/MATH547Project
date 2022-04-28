
clc,clear%raw = xlsread('IHME_GLOBAL_EDUCATIONAL_ATTAINMENT_1970_2015_Y2015M04D27.CSV');
load('raw.mat');
raw_ = raw;
raw(:,5) = zscore(raw(:,5));
X.loc = [];
X.age = [];
X.mean = [];
X.sex = [];
cnt = 0;
for i = 1:size(raw,1)
    loc = raw(i,1);
    year = raw(i,2);
    age = raw(i,3);
    sex = raw(i,4);
    mean = raw(i,5);
    year_ = year - 1969; %year
    flag = false;
    pos = find(X.loc == loc & X.age == age & X.sex == sex);
    if ~isempty(pos)
        X.mean(pos,year_) = mean;
        X.raw(pos,year_) = raw_(i,5);
    else
        cnt = cnt + 1;
        X.loc(cnt) = loc;
        X.age(cnt) = age;
        X.sex(cnt) = sex;
        X.mean(cnt,year_) = mean;
        X.raw(cnt,year_) = raw_(i,5);
    end
end

data = X;
save('data.mat','data');