function fitness = calculate_fitness(pop,dmat)
%计算粒子适应度
[Popsize, N] = size(pop);
fitness = zeros(Popsize,1);
for i = 1:Popsize
    for j = 1:N-1
        fitness(i) = fitness(i) + dmat(pop(i, j), pop(i, j+1));%就是把距离叠加一下
    end
    fitness(i) = fitness(i) + dmat(pop(i,end), pop(i,1));%终点到起点的距离
end

end