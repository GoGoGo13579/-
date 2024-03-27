function new_pop = update_position(pop, v)
%更新粒子位置的函数
%输入参数：pop-原始位置，v-速度方向
%输出参数：新解
[Popsize, N] = size(v);
for i = 1:Popsize
    for j = 1:N %第一个位置不动
        if v(i, j) ~= 0
            temp = pop(i, j);
            pop(i, j) = pop(i, v(i,j));
            pop(i, v(i,j)) = temp;
        end
    end
end
new_pop = pop;
end