clear,clc
citynum = 6; %城市个数
dmat = [0.0 2.3 2.8 4.1 4.1 6.2 ;
        0.0 0.0 1.7 2.2 2.2 4.5 ;
        0.0 0.0 0.0 5.1 5.1 3.6 ;
        0.0 0.0 0.0 0.0 0.1 2.3 ;
        0.0 0.0 0.0 0.0 0.0 2.3 ;
        0.0 0.0 0.0 0.0 0.0 0.0
    ];
dmat = dmat + dmat'; %距离矩阵
t0 = 100; %初始温度
tf = 0.01;%最终温度
alpha = 0.6;%控制温度系数
iter = 6;%内循环次数
route = ones(1,citynum);
route(1, 2:end) = randperm(citynum-1)+1;%初始路径，第一个城市固定为1
fitness = calculate_fitness(route, dmat);
route_best = route;
fitness_best = calculate_fitness(route_best,dmat);
index = 1;

%%循环求解
t = t0;
while t >= tf %大循环模拟降温
    for i = 1:iter %内循环搜索
        [fitness_after, route_after] = exchange(route, dmat);%计算新解与其适应度
        %判断是否更新解
        if fitness_after < fitness %如果解更好无条件接受新解
            route = route_after;
            fitness = fitness_after;
            
        elseif exp((fitness-fitness_after)/t) > rand(1) %解变差了，但是也有一定概率接受
            route = route_after;
            fitness = fitness_after;
        end

        if fitness < fitness_best
            fitness_best = fitness;
            route_best = route;
        end
    end%内循环截至
    f(index) = fitness_best;
    tt(index) = t;
    index = index + 1;
    t = t*alpha;

end

%%
disp("最优值")
disp(fitness_best)
disp("最优解")
disp(route_best)
plot(tt,f,'ro-',MarkerFaceColor='b');
xlabel("温度")
ylabel("该温度下最优解")
title("内循环次数为60")
grid on
set(gca,'XDir','reverse');








