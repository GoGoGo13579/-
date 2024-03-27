function pop_division = identifying_communities(pop,division_num)
[popsize,n] = size(pop);
pop_division = zeros(popsize,n);
for i = 1:popsize
    for j = 1:n
        for k = 1 : division_num
            
            while(1) %把位置空间做成了一个循环
                if(pop(i,j) < 0.5)%如果比下限还低，那么就接到最后一个社区
                    pop(i,j) = pop(i,j) + division_num;
                end
                if(pop(i,j) >= division_num + 0.5)%如果比上限还高，那么就接到第一个社区
                    pop(i,j) = mod(pop(i,j),division_num);
                end
                break;
            end 

            if(pop(i,j) >= k-0.5)&&(pop(i,j) < k+0.5)
                pop_division(i,j) = k;
                break;
            end
        end
    end
end
end