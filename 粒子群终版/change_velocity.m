function new_change = change_velocity(c1, change)
%以概率c1保持序列
[Popsize, N] = size(change);
for i = 1:Popsize
    for j = 1:N
        if rand > c1
            change(i, j) = 0;
        end
    end
end
new_change = change;

end