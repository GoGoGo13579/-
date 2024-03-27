function fitness = calculate_fitness(pop,f,g)
    [popsize,n] = size(pop);
    lam = [10^10,10^10,10^10,10^12];%惩罚因子
    for i = 1:popsize
        fitness(i,1) = f(pop(i,1),pop(i,2),pop(i,3),pop(i,4));
        my_constraint = g(pop(i,1),pop(i,2),pop(i,3),pop(i,4));
        for j = 1:n
            if(my_constraint(j) > 0)
                fitness(i,1) = fitness(i) + lam(j)*abs(my_constraint(j)); %如果不满足约束就给一个大惩罚
            else
                fitness(i,1) =fitness(i) + 0;
            end
        end
    end


end %函数结尾