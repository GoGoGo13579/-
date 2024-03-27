function fitness = calculate_modularity(pop_division,A)
G = graph(A);
k =degree(G);%节点的度
m = numedges(G);%网络的边数
[popsize,n] = size(pop_division);
fitness = zeros(popsize,1);
for num = 1:popsize
    Q = 0;%模块度
    for i = 1:n
        for j = 1:n
            if(i==j)
                continue;
            end
            if(pop_division(num,i) ~= pop_division(num,j))
                continue;
            end

            Q = Q + A(i,j) - k(i)*k(j)/(2*m);
        end
    end
    Q = Q/(2*m);
    fitness(num,1) = Q;
end

end