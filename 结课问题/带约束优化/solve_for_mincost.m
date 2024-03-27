clc,clear
x1 = optimvar('x1',LowerBound=0,UpperBound=99);
x2 = optimvar('x2',LowerBound=0,UpperBound=99);
x3 = optimvar('x3',LowerBound=10,UpperBound=200);
x4 = optimvar('x4',LowerBound=10,UpperBound=200);
prob = optimproblem;
prob.Objective = 0.6224*x1*x3*x4 + 1.7781*x2*x3^2 + 3.1661*x1^2*x4 + 19.84*x1^2*x3 ;
prob.Constraints.cons1 = -x1 + 0.0193*x3 <= 0;
prob.Constraints.cons2 = -x2 + 0.00954*x3 <= 0;
prob.Constraints.cons3 = -pi*x3^2*x4 - (4*pi/3)*x3^3 + 1296000 <= 0;
prob.Constraints.cons4 = x4 - 240 <= 0;
x0.x1 = 0;
x0.x2 = 0;
x0.x3 = 10;
x0.x4 = 20;
sol = solve(prob,x0);

f = @(x1,x2,x3,x4)0.6224*x1*x3*x4 + 1.7781*x2*(x3^2) + 3.1661*(x1^2)*x4 + 19.84*(x1^2)*x3;
g = @(x1,x2,x3,x4)[-x1 + 0.0193*x3;
                     -x2 + 0.00954*x3;
                     -pi*(x3^2)*x4 - (4*pi/3)*(x3^3) + 1296000;
                     x4 - 240];%约束
disp("最优解为：")
disp([sol.x1,sol.x2,sol.x3,sol.x4])
disp("最优值为：")
disp(f(sol.x1,sol.x2,sol.x3,sol.x4))
disp("约束情况为：")
disp(g(sol.x1,sol.x2,sol.x3,sol.x4))