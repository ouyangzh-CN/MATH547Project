function [void0] = clustering(group,treeCluster,W,name_m1)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
scatter3(0,0,0,'k');
hold on
title(['Clustering when k=',num2str(group)]);
xlabel('slope of year'); 
ylabel('slope of age group');
zlabel('intersect in 1970 of 15 to 24 group');
idx_c = cluster(treeCluster,'maxclust',group);%给PCA后的点分类

X=(W(:, 2)-min(W(:, 2)))./(max(W(:, 2))-min(W(:, 2)));
Y=(W(:, 3)-min(W(:, 3)))./(max(W(:, 3))-min(W(:, 3)))-1;
Z=(W(:, 1)-min(W(:, 1)))./(max(W(:, 1))-min(W(:, 1)));%再用低阶系数plot
for i = 1:217
   switch(idx_c(i))%第i个点的类别
       case 1
           scatter3(X(i),Y(i),Z(i),'r');
       case 2
           scatter3(X(i),Y(i),Z(i),'g');
       case 3
           scatter3(X(i),Y(i),Z(i),'b');
       case 4
           scatter3(X(i),Y(i),Z(i),'y');
       case 5
           scatter3(X(i),Y(i),Z(i),'m');
       case 6
           scatter3(X(i),Y(i),Z(i),'c');
       case 7
           scatter3(X(i),Y(i),Z(i),'k');
       otherwise
   end
end
hold off

void0=0;
end