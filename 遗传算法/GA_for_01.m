clear,clc
%对于0—1背包问题的禁忌搜索方法求解
%%初始化参数
weight = [30, 60, 25, 8, 10, 40, 60];%重量
value  = [40, 40, 30, 5, 15, 35, 50];%价值
n = length(weight);  %背包物品数量
popusize = 40; %种群数量
max_weight = 120; %最大重量
max_iternum = 100; %最大迭代次数
pc = 0.9; %交叉概率
pv = 0.05; %变异概率
%% 初始化种群
popu = zeros(popusize, n);%种群
max_fitness = zeros(1,max_iternum);%记录每次迭代的最大适应值
max_index = zeros(max_iternum, n);%记录每次最优解
max_history = 0;%记录历史最优解
max_history_index = zeros(1,n);

for i = 1:popusize
    temp_popu = round(rand(1,n));
    while temp_popu*weight' > max_weight %如果超重就重新初始化
        temp_popu = round(rand(1, n));
    end
    popu(i,:) = temp_popu;
end

%% 迭代求解
for i = 1:max_iternum
    %单点交叉
    new_popu = popu;
    temp_popu = popu;
    for j = 1:2:popusize-1
        if(rand()<pc) %判断是否满足交叉概率
            pos = randi(n);%随机产生交叉位置
            temp_popu(j,:) = [popu(j,1:pos),popu(j+1,pos+1:end)];
            temp_popu(j+1,:) = [popu(j+1,1:pos),popu(j,pos+1:end)];
            if((temp_popu(j,:)*weight'<max_weight) &&(temp_popu(j+1,:)*weight'<max_weight))%如果超重就不交换了
                new_popu(j,:) = temp_popu(j,:);
                new_popu(j+1,:) = new_popu(j+1,:);
            end
        end
    end%交叉终止
    popu = new_popu;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %单点变异
    temp_popu = popu;
    new_popu = popu;
    for j = 1:popusize
        if rand() < pv
            pos = randi(n);%产生变异位置
            temp_popu(j,pos) = ~temp_popu(j,pos);
            if(temp_popu(j,:)*weight' < max_weight)%如果重量符合要求则更新解
               new_popu(j,:) = temp_popu(j,:); 
            end
        end
    end
    popu = new_popu;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %选择
    new_popu = popu;
    fitness = popu*value';
    fitscore = fitness/sum(fitness);%计算概率
    fitscore = cumsum(fitscore);
    sort_rand = sort(rand(popusize,1));
    index = 1;
    num = 1;
    while num <= popusize
        if(sort_rand(num) <= fitscore(index))
            new_popu(num,:) = popu(index,:);
            num = num + 1;
        else
            index = index + 1;
        end
    end
    popu = new_popu;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %记录最优值
    fitness = popu*value';
    [max,index] = sort(fitness,"descend");
    max_fitness(1,i) = max(1);
    max_index(i,:) = popu(index(1),:);
    if(max(1) > max_history)
        max_history = max(1);
        max_history_index = popu(index(1),:);
    end

end %大循环终止

disp("最优值为：");
disp(max_history);
disp("最优值对应的选择为：");
disp(max_history_index);
disp("所用重量为：")
disp(max_history_index*weight');

%%
plot(1:length(max_fitness),max_fitness,'ro-',MarkerFaceColor='b');
xlabel("迭代次数")
ylabel("每次迭代最优解")

