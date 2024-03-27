function change = position_change(Pbest, pop)
%获取速度中个体最优分量
%返回值是一个交换序列，pop按照change改变可以变为最好解
%输入参数：Pbest-个体最有，pop-种群
[Popsize, N] = size(Pbest);
change = zeros(Popsize,N);
for i = 1:Popsize
    for j = 1:N
        change(i,j) = find(pop(i, :) == Pbest(i,j));
        temp = pop(i,j);
        pop(i,j) = pop(i, change(i,j));
        pop(i, change(i,j)) = temp;
    end
end
end