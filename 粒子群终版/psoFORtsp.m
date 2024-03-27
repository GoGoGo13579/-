clear,clc
%%初始化
N = 6; %城市个数
dmat = [0.0 2.3 2.8 4.1 4.1 6.2 ;
     0.0 0.0 1.7 2.2 2.2 4.5 ;
     0.0 0.0 0.0 5.1 5.1 3.6 ;
     0.0 0.0 0.0 0.0 0.1 2.3 ;
     0.0 0.0 0.0 0.0 0.0 2.3 ;
     0.0 0.0 0.0 0.0 0.0 0.0
    ];
dmat = dmat + dmat'; %距离矩阵
Popsize =10; %种群大小
IterNum = 20; %最大迭代次数
c1 = 0.4;                   %个体学习因子
c2 = 0.075;                 %社会学习因子
w = 1;                      %惯性因子
pop = zeros(Popsize,N);     %粒子位置
v = zeros(Popsize,N);       %粒子速度
Iter = 1;                   %迭代次数计时
fitness = zeros(Popsize,1); %适应度函数值
Pbest = zeros(Popsize,N);   %个体极值路径
Pbest_fitness = zeros(Popsize,1);   %个体极值
Gbest = zeros(IterNum,N);            %群体极值路径
Gbest_fitness = zeros(IterNum,1);     %群体极值
%Length_ave = zeros(IterNum,1);
ws = 1;                                %惯性因子最大值
we = 0.5;                               %惯性因子最小值

%%产生初始位置与速度与极值
for i = 1:Popsize
    pop(:,1) = 1; 
    pop(i, 2:end) = randperm(N-1)+1; %将初始城市定为第一个城市
    v(i, :) = randperm(N);
end
%计算粒子适应度
fitness = calculate_fitness(pop, dmat);
%计算个体极值和群体极值
Pbest_fitness = fitness;
Pbest = pop;
[Gbest_fitness(1), min_index] = min(fitness);
Gbest(1,:) = pop(min_index,:);

%%迭代计算
while Iter < IterNum
    %更新迭代次数与惯性系数
    Iter = Iter + 1;
    w = ws - (ws-we)*(Iter/IterNum)^2; %计算惯性因子
    %更新种群速度
    %个体层面
    change1 = position_change(Pbest, pop);
    change1 = change_velocity(c1, change1);
    %群体层面
    change2 = position_change( repmat(Gbest(Iter-1,:),Popsize,1), pop );
    change2 = change_velocity(c2, change2);
    %原速度部分
    v = Ovelocity(w, v);
    %修正速度
    for i = 1:Popsize
        for j = 1:N
            if change1(i,j) ~= 0
                v(i,j) = change1(i, j);
            end

            if change2(i,j) ~= 0
                v(i,j) = change2(i, j);
            end
        end
    end
    %保证第一个位置不动
    v(v==1) = 0;
    v(:,1) = 0;

    %更新粒子位置
    pop = update_position(pop,v);
    %更新适应值
    fitness  = calculate_fitness(pop, dmat);
    %更新个体极值
    for i = 1:Popsize
        if fitness(i) < Pbest_fitness(i)
            Pbest_fitness(i) = fitness(i);
            Pbest(i,:) = pop(i,:);
        end
    end
    %更新群体极值
    [min_fitness, min_index] = min(fitness);
    if min_fitness < Gbest_fitness(Iter-1)
        Gbest_fitness(Iter) = min_fitness;
        Gbest(Iter,:) = pop(min_index,:);
    else
        Gbest_fitness(Iter) = Gbest_fitness(Iter-1);
        Gbest(Iter,:) = Gbest(Iter-1,:);
    end


end %大循环结尾

%%
plot(1:IterNum,Gbest_fitness,'r',LineWidth=1.25);
xlabel("迭代次数","FontSize",15)
ylabel("适应度值","FontSize",15)
title("收敛曲线","FontSize",15)

%%
disp("最优值")
disp(Gbest_fitness(end))
disp("最优解")
disp(Gbest(end,:))
    

