function new_v = Ovelocity(w, v)
%以概率w保留原速度序列
[Popsize, N] = size(v);
for i = 1:Popsize
    for j = 1:N
        if rand > w
            v(i,j) = 0;
        end
    end
end
new_v = v;
end