% 载入数据

W=p22;
[U, S, ~] = svd(W);

X=U(:, 1);
Y=U(:, 2);
Z=U(:, 3);%PCA

% X=(W(:, 2)-min(W(:, 2)))./(max(W(:, 2))-min(W(:, 2)));
% Y=(W(:, 3)-min(W(:, 3)))./(max(W(:, 3))-min(W(:, 3)))-1;
% Z=(W(:, 1)-min(W(:, 1)))./(max(W(:, 1))-min(W(:, 1)));
Data = [X(:) Y(:) Z(:)];
 
% 计算前边点与后边点距离
disVector = pdist(Data,'cityblock');  % pdist之后的Y是一个行向量，15个元素分别代表X 的第1点与2-6点、第2点与3-6点,......这样的距离
 
% 转换成方阵
disMatrix = squareform(disVector);
 
% 确定层次聚类树 
treeCluster = linkage(disMatrix,'ward');
 
% 可视化聚类树
% dendrogram(treeCluster);
 
% 聚类下标
% idx = cluster(treeCluster,'maxclust',5); %划分聚类为5类
figure(9)
scatter3(0,0,0,'k');
hold on
title('Clustering by fitting parameters');
% xlabel('k'); 
% ylabel('b');
xlabel('p10/slope of year'); 
ylabel('p01/slope of age group');
zlabel('p00/intersect@1970@15to24');
idx_c = cluster(treeCluster,'maxclust',5);%给PCA后的点分类

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
   switch(idx_c(i))%name_m1按地区编号从小到大排序，拟合p22也是，因此名字是对应X(i),Y(i),Z(i)这组拟合参数的
       case 1
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','r','FontSize',8);
       case 2
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','g','FontSize',8);
       case 3
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','b','FontSize',8);
       case 4
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','y','FontSize',8);
       case 5
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','m','FontSize',8);
       case 6
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','c','FontSize',8);
       case 7
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','k','FontSize',8);
       otherwise
   end
end
hold off


%%
figure(3)
scatter3(0,0,0,'k');
% axis equal
hold on;
% title('Clustering by fitting parameters');
% xlabel('k'); 
% ylabel('b');
xlabel('p10/slope of year'); 
ylabel('p01/slope of age group');
zlabel('p00/intersect@1970@15to24');
% 同样的图，只是用洲标颜色
for i = 1:217
    if((6<=(i+2)&&(i+2)<=8)||(10<=(i+2)&&(i+2)<=20)||(33<=(i+2)&&(i+2)<=41)||(66<=(i+2)&&(i+2)<=69)||(149<=(i+2)&&(i+2)<=153)||(155<=(i+2)&&(i+2)<=157)||(160<=(i+2)&&(i+2)<=165)||(i+2)==77||(i+2)==85||(i+2)==140||(i+2)==142||(i+2)==143||(i+2)==145||(i+2)==146)
        idx(i)=1;
    elseif((22<=(i+2)&&(i+2)<=30)||(71<=(i+2)&&(i+2)<=72)) idx(i)=2;
    elseif((43<=(i+2)&&(i+2)<=63)||(74<=(i+2)&&(i+2)<=76)||(78<=(i+2)&&(i+2)<=84)||(86<=(i+2)&&(i+2)<=95)) idx(i)=3;
    elseif((97<=(i+2)&&(i+2)<=99)||(121<=(i+2)&&(i+2)<=123)||(i+2)==113||(i+2)==118||(i+2)==125||(i+2)==133||(i+2)==135||(i+2)==136) idx(i)=4;
    elseif((i+2)==101||(i+2)==102||(i+2)==119||(105<=(i+2)&&(i+2)<=112)||(114<=(i+2)&&(i+2)<=117)||(126<=(i+2)&&(i+2)<=132)) idx(i)=5;
    elseif((i+2)==139||(i+2)==141||(i+2)==147||(i+2)==148||(i+2)==154||(168<=(i+2)&&(i+2)<=173)||(175<=(i+2)&&(i+2)<=187)||(189<=(i+3)&&(i+2)<=191)||(193<=(i+3)&&(i+2)<=198)||(200<=(i+3)&&(i+2)<=218)||(i+3)==435||(i+3)==522)
            idx(i)=6;
    else idx(i)=7;
    end 
end
for i = 1:217
   switch(idx(i))
       case 1
           scatter3(X(i),Y(i),Z(i),'r');%asia
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','r','FontSize',8);
       case 2
           scatter3(X(i),Y(i),Z(i),'g');%oceania
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','g','FontSize',8);
       case 3
           scatter3(X(i),Y(i),Z(i),'b');%europe
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','b','FontSize',8);
       case 4
           scatter3(X(i),Y(i),Z(i),'y');%south am
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','y','FontSize',8);
       case 5
           scatter3(X(i),Y(i),Z(i),'m');%north am
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','m','FontSize',8);
       case 6
           scatter3(X(i),Y(i),Z(i),'c');%africa
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','c','FontSize',8);
       case 7
           scatter3(X(i),Y(i),Z(i),'k');%global
           text(X(i)+0.01,Y(i)+0.01,Z(i)+0.01,name_m1(i),'Color','k','FontSize',8);
       otherwise
   end
end
hold off

