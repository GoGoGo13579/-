function [fitness_after, route_after] = exchange(route, dmat)
citynum = length(route);
while 1
    location1 = ceil(rand()*citynum);
    location2 = ceil(rand()*citynum);
    if ((location2 ~= location1) && (location2 ~= route(1)) && (location1 ~= route(1))) %两个交换的位置不相等，且第一个位置不换
        route_after = route;
        %交换位置
        temp = route_after(location1);
        route_after(location1) = route_after(location2);
        route_after(location2) = temp; 
        %计算新解的适应值
        fitness_after = calculate_fitness(route_after, dmat);
        break;
    end
end
end