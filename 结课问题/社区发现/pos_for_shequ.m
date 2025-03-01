clear,clc
%% 获取数据与初始化
A = gmlread("karate.gml");
G = graph(A);
division_num = 3;%划分社区个数
%plot(G);
n = length(A); %自变量维数
popsize = 40000; %种群大小
iter = 2;     %当前迭代次数
iternum = 100; %最大迭代次数
c1 = 0.1;                   %个体学习因子
c2 = 0.15;                 %社会学习因子
w = 1;                      %惯性因子
pop = zeros(popsize,n);     %粒子位置
pop_division = zeros(popsize,n); %粒子所对应划分
v = zeros(popsize,n);       %粒子速度
fitness = zeros(popsize,1); %适应度函数值
Pbest = zeros(popsize,n);   %个体极值自变量值
Pbest_fitness = zeros(popsize,1);   %个体极值
Gbest = zeros(iternum,n);            %群体最小值对应的自变量值
Gbest_fitness = zeros(iternum,1);     %群体极值
%Gbest_division = zeros(iternum,n);
ws = 1;      %惯性因子最大值
we = 0.6;    %惯性因子最小值
v_limit = [-1,1]*2;

%% 种群初始化 采用标准粒子群改进编码
for i = 1:popsize
    for j = 1 : n
        pop(i,j) = rand()*division_num + 0.5;
    end
end
pop_division = identifying_communities(pop,division_num);%将位置空间转化为社区编号
fitness = calculate_modularity(pop_division,A);
Pbest_fitness = fitness;
Pbest = pop_division;
[max_fitness,index] = max(fitness);
Gbest_fitness(1,1) = max_fitness;
Gbest(1,:) = pop_division(index);
%Gbest_division(1,:) = pop_division(index,:);

while iter <= iternum
    %计算速度
    w = ws - (ws-we)*(iter/iternum)^2;
    for i = 1:popsize
        v(i,:) = w*v(i,:) + c1*rand()*(Pbest(i,:)- pop(i,:)) + c2*rand()*(Gbest(iter-1,:) - pop(i,:));
        for j = 1:n
            if(v(i,j)>v_limit(2))
                v(i,j) = v_limit(2);
            elseif(v(i,j)<v_limit(1))
                v(i,j) = v_limit(1);
            end
        end
    end
    %更新位置
    pop = pop + v;
    pop_division = identifying_communities(pop,division_num);
    pop = pop_division;
    fitness = calculate_modularity(pop_division,A);
    %更新个体最优解
    for i = 1:popsize
        if(Pbest_fitness(i) < fitness(i))
            Pbest_fitness(i) = fitness(i);
            Pbest(i,:) = pop_division(i,:);
        end
    end
    %更新全局最优解
    [max_fitness,index] = max(fitness);
    if(max_fitness > Gbest_fitness(iter - 1,1))
        Gbest_fitness(iter,1) = max_fitness;
        Gbest(iter,:) = pop_division(index,:);
        %Gbest_division(iter,:) = pop_division(index,:);
    else
        Gbest_fitness(iter,1) = Gbest_fitness(iter-1,1);
        Gbest(iter,:) = Gbest(iter-1,:);
        %Gbest_division(iter,:) = Gbest_division(iter-1,:);
    end
    %更新循环条件
    iter = iter + 1;
end

disp("最优值为：")
disp(Gbest_fitness(end))
disp("最优划分为：")
disp(Gbest(end,:))

%%
% 使用黄色、红色和蓝色节点颜色绘制经PSO优化后的最终社区结构
G = graph(A);
class_best= Gbest(end,:);
p = plot(G,'Layout','force',NodeLabel=class_best,LineWidth=1.25);
nodeColor = ones(1,length(class_best));
nodeColor(best_class == 1) = 1;
nodeColor(best_class == 2) = 2;
nodeColor(best_class == 3) = 3;
p.NodeCData = nodeColor;
colormap([0 1 0.2; 1 0 0; 0 0 1]); % 黄色、红色和蓝色
p.NodeColor ="flat";
p.MarkerSize = 8;
title("社区划分结果")

%%
plot(1:length(Gbest_fitness),Gbest_fitness,'ro-',MarkerFaceColor='b',MarkerSize=4)
xlabel("迭代次数")
ylabel("模块度")
title("收敛曲线")




