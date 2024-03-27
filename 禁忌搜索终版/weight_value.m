function [x_weight, x_value] = weight_value(new_x, weight, value)
[~,c] = size(new_x);
for i = 1:c
    x_weight(i) = weight*new_x(:, i);%重量
    x_value(i) = value*new_x(:, i);%价值
end

end