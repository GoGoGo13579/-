% 创建图形窗口
figure;
% 绘制节点
nodes = [1, 2, 3, 4, 5, 6];
community = [1, 1, 2, 2, 3, 3];
colors = {'red', 'red', 'green', 'green', 'blue', 'blue'};
sizes = [20, 20, 30, 30, 20, 20];
% 遍历节点和社区，绘制节点
for i = 1:length(nodes)
    node = nodes(i);
    communityID = community(i);
    color = colors{communityID};
    size = sizes(i);
    % 绘制节点
    scatter(node, node, size, color, 'filled');
end
% 添加边
for i = 1:length(nodes)-1
    node1 = nodes(i);
    node2 = nodes(i+1);
    communityID1 = community(i);
    communityID2 = community(i+1);
    if communityID1 == communityID2
        % 如果两个节点属于同一个社区，则添加边
        plot([node1, node2], [node1, node2], 'k-');
    end
end
% 设置坐标轴
axis('equal');
xlabel('X轴');
ylabel('Y轴');
% 添加标题
title('社区划分可视化');
% 调整布局
layout('off');
% 显示图形
drawnow;