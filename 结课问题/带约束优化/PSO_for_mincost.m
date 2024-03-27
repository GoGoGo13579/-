%使用粒子群算法求解压力管设计问题
clc ,clear
%% 初始化
n = 4; %自变量维数
popsize = 2000; %种群大小
iter = 2;     %当前迭代次数
iternum = 200; %最大迭代次数
c1 = 0.15;                   %个体学习因子
c2 = 0.15;                 %社会学习因子
w = 1;                      %惯性因子
pop = zeros(popsize,4);     %粒子位置
v = zeros(popsize,4);       %粒子速度
fitness = zeros(popsize,1); %适应度函数值
Pbest = zeros(popsize,4);   %个体极值自变量值
Pbest_fitness = zeros(popsize,1);   %个体极值
Gbest = zeros(iternum,4);            %群体最小值对应的自变量值
Gbest_fitness = zeros(iternum,1);     %群体极值
ws = 1.2;      %惯性因子最大值
we = 0.4;    %惯性因子最小值

f = @(x1,x2,x3,x4)0.6224*x1*x3*x4 + 1.7781*x2*(x3^2) + 3.1661*(x1^2)*x4 + 19.84*(x1^2)*x3;
g = @(x1,x2,x3,x4)[-x1 + 0.0193*x3;
                     -x2 + 0.00954*x3;
                     -pi*(x3^2)*x4 - (4*pi/3)*(x3^3) + 1296000;
                     x4 - 240];%约束
pop_limit = [0,99;0,99;10,200;10,200];%自变量的限制
v_limit = [-5,5;-5,5;-10,10;-1,100];

%% 初始化种群适应度与速度
%初始化种群
for i = 1:popsize
    temp = rand(1,n);
    for j = 1:n
        temp(1,j) = temp(1,j)*(pop_limit(j,2)-pop_limit(j,1)) + pop_limit(j,1);
    end
    pop(i,:) = temp;
end
%计算适应度
fitness = calculate_fitness(pop,f,g);
% for i = 1:popsize
%     fitness(i) = f(pop(i,1),pop(i,2),pop(i,3),pop(i,4));
% end 
%计算个体与全局最优
Pbest = pop;
Pbest_fitness = fitness;
[min_fitness,index] = min(fitness);
Gbest_fitness(1,1) = min_fitness;
Gbest(1,:)  = pop(index,:);

%% 迭代计算 
while iter <= iternum
    w = ws - (ws-we)*(iter/iternum)^2;
    %计算并修正粒子速度
    for i = 1:popsize
        v(i,:) = w*v(i,:) + c1*rand()*(Pbest(i,:)- pop(i,:)) + c2*rand()*(Gbest(iter-1,:) - pop(i,:));
        for j = 1:n
            if(v(i,j)>v_limit(j,2))
                v(i,j) = v_limit(j,2);
            elseif(v(i,j)<v_limit(j,1))
                v(i,j) = v_limit(j,1);
            end
        end
    end

    %更新并修正位置
    pop = pop + v;
    for i = 1:popsize
        for j = 1:n
            if(pop(i,j) > pop_limit(j,2))
                pop(i,j) = pop_limit(j,2);
            elseif(pop(i,j) < pop_limit(j,1))
                pop(i,j) = pop_limit(j,1);
            end
        end
    end

    %计算带有惩罚值的适应度
    %tic
    fitness = calculate_fitness(pop,f,g);
    %toc
    %% 
    %% 
    for i = 1:popsize
        if(Pbest_fitness(i)>fitness(i))
            Pbest_fitness(i) = fitness(i);
            Pbest(i,:) = pop(i,:);
        end
    end

    [min_fitness,index] = min(fitness);
    if(Gbest_fitness(iter-1,1) > min_fitness)
        Gbest_fitness(iter,1) = min_fitness;
        Gbest(iter,:)  = pop(index,:);
    else
        Gbest_fitness(iter,1) = Gbest_fitness(iter-1,1);
        Gbest(iter,:) = Gbest(iter-1,:);
    end

    iter = iter + 1;


end %大循环结尾

disp("最优值：")
disp(f(Gbest(end,1),Gbest(end,2),Gbest(end,3),Gbest(end,4)));
disp("最优解：")
disp(Gbest(end,:));
disp("约束情况为：")
disp(g(Gbest(end,1),Gbest(end,2),Gbest(end,3),Gbest(end,4)))

%%
plot(1:length(Gbest_fitness),Gbest_fitness,'ro-',MarkerFaceColor='b',MarkerSize=4)
xlabel('迭代次数')
ylabel('最优值')
title("迭代收敛曲线")






