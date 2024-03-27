function [x_max, y_max] = my_GA_plus(n, a, b, pc, pm, e)
%n--群体规模； a--搜索上限；  b--搜索下限
%pm-变异概率； pc-交叉概率；  e--计算精度

%% 计算编码长度m
alpha = (b-a)/e;
for i = 1:50
    if (alpha <= 2^i) && (alpha > 2^(i-1))
        m = i;
    end

end

%%随机产生初始种群
popusize = n;
chromlength = m;
j = 1;
popu = round(rand(popusize, chromlength));
itnum_max = 100;

%%
while j <= itnum_max
    py = chromlength;
    for i = 1:py  %二进制转十进制
        popu1(:, i) = 2^(py - 1) .* popu(:, i);
        py = py - 1; %虽然改变py的值，但是已经不会改变循环次数了
    end

    popu2 = sum(popu1,2);
    x = a + popu2*(b-a)/(2^m-1);
    yvalue = 2*x.^2 .*cos(3*x) + x.*sin(5*x) + 8;%计算适应度

    %对选择进行改进，兼顾全局与局部搜索，在后一半进行适应值标定选择复制

    if (j <= round(0.9*itnum_max)) %前一半正常全局搜索

        for i = 1:popusize  %小于0的函数值赋值为0，因为概率非负
            if yvalue(i) < 0
                yvalue(i) = 0;
            end
        end
        fitscore = yvalue/sum(yvalue);%计算被选择的概率
        fitscore = cumsum(fitscore);%概率的累计分布
        wh = sort(rand(popusize,1));%一次性把随机数生成够了,且由小到大排好
        wheel = 1; %轮赌次数计数器
        fitone = 1;
        while wheel <= popusize %赌轮选择
            if wh(wheel) <= fitscore(fitone)
                newpopu(wheel, :) = popu(fitone,:); %选中谁就把谁（二进制）放到新的里
                wheel = wheel + 1;
            else
                fitone = fitone + 1; %因为wh已经排好序，所以fitone不用重置
            end
        end
        popu = newpopu;
    else %后一半采用适应值标定，增加局部搜索能力
        ymin = min(yvalue);
        yvalue_biaoding = yvalue - ymin*ones(popusize, 1) + 0.1 ;
        fitscore = yvalue_biaoding/sum(yvalue_biaoding);%计算被选择的概率
        fitscore = cumsum(fitscore);%概率的累计分布
        wh = sort(rand(popusize,1));%一次性把随机数生成够了,且由小到大排好
        wheel = 1; %轮赌次数计数器
        fitone = 1;
        while wheel <= popusize %赌轮选择
            if wh(wheel) <= fitscore(fitone)
                newpopu(wheel, :) = popu(fitone,:); %选中谁就把谁（二进制）放到新的里
                wheel = wheel + 1;
            else
                fitone = fitone + 1; %因为wh已经排好序，所以fitone不用重置
            end
        end
        popu = newpopu;

    end

    %交叉

    for i = 1:2:popusize-1
        if rand < pc
            cpoint = round(rand*chromlength); %随机产生剪切位置
            newpopu(i, :) = [popu(i, 1:cpoint) popu(i+1, cpoint+1 : chromlength)];
            newpopu(i+1, :) = [popu(i+1, 1:cpoint) popu(i, cpoint+1 : chromlength)];
        else
            newpopu(i, :) = popu(i, :);
            newpopu(i+1, :) = popu(i+1, :);
        end

    end
    popu = newpopu;

    %变异

    for i = 1:popusize
        if rand < pm
            mpoint = round(rand*chromlength);
            if mpoint <= 0
                mpoint = 1;
            end
            newpopu(i, :) = popu(i, :);

            if newpopu(i, mpoint) == 0 %变异取反
                newpopu(i, mpoint) = 1;
            else
                newpopu(i, mpoint) = 0; 
            end  
        else
            newpopu(i, :) = popu(i, :);
        end
    end
    popu = newpopu;

    %找最大值

    [y(j), index] = max(yvalue);
    bestindividual = newpopu(index, :);
    py = chromlength;
    for i = 1:py  %二进制转十进制
        bestindividual(1, i) = 2.^(py-1) .* bestindividual(:, i);
        py = py - 1; %虽然改变py的值，但是已经不会改变循环次数了
    end
    r(j) = a + sum(bestindividual,2)*(b-a)/(2^m - 1);

    j = j + 1;
end %大循环终止

% fplot(@(x)2.*x.^2.*cos(3.*x)+x.*sin(5.*x)+8, [a,b])
% hold on 
% plot(r, y, 'r*') 
% % plot(r(1,1:j-1), y(1,1:j-1) ,'r*')
% % plot(r(j), y(j), 'ro')
% xlabel('x')
% ylabel('y')
% ylim([-30,60])
[ym, index] = max(y);
y_max = ym;
x_max = r(index);
% title("y = 2*x^2*cos3x + x*sin5x + 8")


end