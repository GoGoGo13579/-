function [y, index] = neiborhood_solution(x, num_solution)
%由x产生一定数量邻域解
l_x = length(x);
y = zeros(length(x), num_solution); %每一列是一个新解
chang_location = zeros(1, num_solution);%记录改变的位置

%获取哪些位置发生改变
num = 2;
chang_location(1) = randi(l_x);%产生一个1~解的长度之间的随机整数
while(num <= num_solution)
    chang_location(num) = randi(l_x);%产生一个1~解的长度之间的随机整数
    for i = 1:num-1 %不让包含重复
        if chang_location(1, num) == chang_location(1, i)
            continue;
        end     
    end
    num = num + 1;
end

for i = 1:num_solution %获取邻域解
    new_x = x;
    if new_x(chang_location(1, i)) == 1
        new_x(chang_location(1, i)) = 0;
    else
         new_x(chang_location(1, i)) = 1;
    end

    y(:,i) = new_x;
end

index = chang_location;%返回哪一位改变，方便禁忌判断

end