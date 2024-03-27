%%
clc,clear
figure
x = 0.01:0.01:0.1;
y = 125*ones(1,length(x));
plot(x,y,'ro-',MarkerFaceColor='b');
xlabel("变异概率")
ylabel("最优值")

%%
figure
x = 0.5:0.05:0.9;
y = 125*ones(1,length(x));
plot(x,y,'ro-',MarkerFaceColor='b');
xlabel("交叉概率")
ylabel("最优值")