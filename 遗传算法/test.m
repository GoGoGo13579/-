clear,clc
%[x1, y1] = my_GA(10, 0, 5, 0.9, 0.01, 0.0001);
for i=1:500
    [x1(i), y1(i)] = my_GA_plus(30, 0, 5, 0.9, 0.01, 0.0001);
    [x2(i), y2(i)] = my_GA_plus(30, 0, 5, 0.85, 0.01, 0.0001);
    [x3(i), y3(i)] = my_GA_plus(30, 0, 5, 0.8, 0.01, 0.0001);
    [x4(i), y4(i)] = my_GA_plus(30, 0, 5, 0.75, 0.01, 0.0001);
    [x5(i), y5(i)] = my_GA_plus(30, 0, 5, 0.7, 0.01, 0.0001);
    [x6(i), y6(i)] = my_GA_plus(30, 0, 5, 0.65, 0.01, 0.0001);
    [x7(i), y7(i)] = my_GA_plus(30, 0, 5, 0.6, 0.01, 0.0001);
    [x8(i), y8(i)] = my_GA_plus(30, 0, 5, 0.55, 0.01, 0.0001);
    [x9(i), y9(i)] = my_GA_plus(30, 0, 5, 0.5, 0.01, 0.0001);
end

%%
figure
x = 0.5:0.05:0.9;
y = [mean(y9), mean(y8), mean(y7), mean(y6), mean(y5), mean(y4), mean(y3), mean(y2), mean(y1)];
plot(x,y,'ro-',MarkerFaceColor='b');
xlabel("交叉概率")
ylabel("最优值")

%%
for i=1:500
    [x0(i), y0(i)] = my_GA_plus(30, 0, 5, 0.9, 0.1, 0.0001);
    [x1(i), y1(i)] = my_GA_plus(30, 0, 5, 0.9, 0.09, 0.0001);
    [x2(i), y2(i)] = my_GA_plus(30, 0, 5, 0.9, 0.08, 0.0001);
    [x3(i), y3(i)] = my_GA_plus(30, 0, 5, 0.9, 0.07, 0.0001);
    [x4(i), y4(i)] = my_GA_plus(30, 0, 5, 0.9, 0.06, 0.0001);
    [x5(i), y5(i)] = my_GA_plus(30, 0, 5, 0.9, 0.05, 0.0001);
    [x6(i), y6(i)] = my_GA_plus(30, 0, 5, 0.9, 0.04, 0.0001);
    [x7(i), y7(i)] = my_GA_plus(30, 0, 5, 0.9, 0.03, 0.0001);
    [x8(i), y8(i)] = my_GA_plus(30, 0, 5, 0.9, 0.02, 0.0001);
    [x9(i), y9(i)] = my_GA_plus(30, 0, 5, 0.9, 0.01, 0.0001);
end

%%
figure
x = 0.01:0.01:0.1;
y = [mean(y9), mean(y8), mean(y7), mean(y6), mean(y5), mean(y4), mean(y3), mean(y2), mean(y1), mean(y0)];
plot(x,y,'ro-',MarkerFaceColor='b');
xlabel("变异概率")
ylabel("最优值")
