clear,clc
%对于0—1背包问题的禁忌搜索方法求解
%%初始化参数
weight = [30, 60, 25, 8, 10, 40, 60];%重量
value  = [40, 40, 30, 5, 15, 35, 50];%价值
n = length(weight);  %背包物品数量
num_newsolution = 5;
max_weight = 120; %最大重量
max_iternum = 200; %最大迭代次数
tabulist_length = 4; %禁忌表长度
tabulist = zeros(1,tabulist_length); %禁忌元素为改变的元素的位置
abv_index = 1; %每次最优解的索引
hbv_index = 1;%历史最优解索引
hbx_index = 1; %历史最优解横坐标索引

%%获取一个初始解
while(1)
    x0 = round(rand(n ,1));
    if weight*x0 <= max_weight %如果超重则重新产生
        break
    end
end

all_best_value(abv_index) = value*x0;%每次最优解
abv_index = abv_index + 1;
history_best_value(hbv_index) = value*x0; %历史最优解
hbv_index = hbv_index + 1;
history_best_x(:,hbx_index) = x0;%历史最优解的横坐标
hbx_index  = hbx_index + 1;
%循环求解最优值
for j = 1:max_iternum 
    [new_x, chang_localtion] = neiborhood_solution(x0, num_newsolution);%获取邻域解
    [x_weight, x_value]  = weight_value(new_x, weight, value);%获得相应的
    %去除超重的解
    num = 1;
    for i = 1:num_newsolution 
        if x_weight(i) <= max_weight
            temp_weight(num) = x_weight(i); 
            temp_value(num) = x_value(i);
            temp_x(:,num) = new_x(:, i);
            temp_localtion(num) = chang_localtion(i); 
            num = num + 1;
        end
    end
    x_weight = temp_weight;
    x_value = temp_value;
    nuw_x = temp_x;
    chang_localtion = temp_localtion;

    %判断最优解是否在禁忌表里并且更新禁忌表
    
    [value_sort, index] = sort(x_value,"descend");
    if value_sort(1) > history_best_value(hbv_index-1) %比历史最大的还大，可以破格录取
        history_best_value(hbv_index) = value_sort(1);
        history_best_x(:,hbx_index) = new_x(:,index(1));
        hbv_index = hbv_index + 1;
        hbx_index = hbx_index + 1;
        %如果变换在禁忌表里就不做变化
        %如果不在禁忌表里就加里去
        if ( sum(tabulist == chang_localtion(index(1))) == 1 ) %在禁忌表里
    
        else %不在禁忌表里
            circshift(tabulist,1);
            tabulist(1) = chang_localtion(index(1));
        end
        x0 = new_x(:, index(1));
        all_best_value(abv_index) = x_value(index(1));
        abv_index = abv_index + 1;
    else
        for i = 1:length(x_value)
        if ( sum(tabulist == chang_localtion(index(i))) == 1 ) %如果在禁忌表里，就查看下一个
            continue;
        else
            %不在禁忌表里的最好的，记录下来
            x0 = new_x(:, index(i));
            all_best_value(abv_index) = x_value(index(i));
            abv_index = abv_index + 1;
            %更新禁忌表
            circshift(tabulist,1);
            tabulist(1) = chang_localtion(index(i));
            break;
        end
        end
    end 
end %大循环结尾

%% 
disp("最优值")
disp(history_best_value(end))
disp("最优解" )
disp(history_best_x(:,end))

plot(1:length(all_best_value),all_best_value,'ro-',MarkerFaceColor='b')
xlabel("迭代次数",FontSize=12)
ylabel("每次迭代最大值","FontSize",12)
