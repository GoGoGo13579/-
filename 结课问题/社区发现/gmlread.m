function AdjGraphMat = gmlread(fileName)
% ReadMe：
% 功能：此函数用于读取gml格式的网络数据文件
% 参数列表：只有一个传入参数，参数为文件名
% 返回参数为邻接矩阵

%% 读取文本，打开文件并创建文件句柄fid
fid = fopen(fileName);
%% 将文本的Ascii码内容存为stringAsc
stringAsc = fread(fid)';
%% 关闭文件句柄
fclose(fid);
%% 将Ascii码转化为字符串形式
string = char(stringAsc);
%% 正则表达式，解析json格式的gml图数据
%% 此文件数据是否为有向图
isDirect = ~isempty(regexp(string,'directed 1\n','once'));
%% ----------------------1.节点------------------------
%% 设置node节点的字段匹配模式
patternNode = 'node[^a-z].*?]';
[strStart,strStop] = regexp(string,patternNode);
%% 设定节点的结构体及其数据成员的属性
stringTmp = string(strStart(1):strStop(1));
if isempty(regexp(stringTmp,'label', 'once'))
    isLabel = 0;
    nodeList(1:length(strStart)) = struct('id',[]);
else
    isLabel = 1;
    nodeList(1:length(strStart)) = struct('id',[],'label',[]);
end
for i = 1 : length(strStart)
    stringTmp = string(strStart(i):strStop(i));
    [strStartTmp,strStopTmp] = regexp(stringTmp,'id [0-9]+\n');
    nodeList(i).id = str2double(stringTmp(strStartTmp+3:strStopTmp-1));
    if isLabel
        [strStartTmp,strStopTmp] = regexp(stringTmp,'label ".*"\n');
        nodeList(i).label = stringTmp(strStartTmp+7:strStopTmp-2);
    end
end
%% ----------------------2.边------------------------
%% 设置edge边的字段匹配模式
patternEdge = 'edge[^a-z].*?]';
[strStart,strStop] = regexp(string,patternEdge);
%% 设定边的结构体及其数据成员的属性
edgeList = zeros(length(strStart),2);
for i = 1 : length(strStart)
    stringTmp = string(strStart(i):strStop(i));
    [strStartTmp,strStopTmp] = regexp(stringTmp,'source [0-9]+\n');
    edgeList(i,1) = str2double(stringTmp(strStartTmp+7:strStopTmp-1));
    [strStartTmp,strStopTmp] = regexp(stringTmp,'target [0-9]+\n');
    edgeList(i,2) = str2double(stringTmp(strStartTmp+7:strStopTmp-1));
end
%% 构建邻接矩阵
AdjGraphMat = zeros(length(nodeList));
for i = 1 : length(edgeList)
    AdjGraphMat(edgeList(i,1)+1-nodeList(1).id,edgeList(i,2)+1-nodeList(1).id) = 1;
    if isDirect == 0
        AdjGraphMat(edgeList(i,2)+1-nodeList(1).id,edgeList(i,1)+1-nodeList(1).id) = 1;
    end
end
%% 稀疏矩阵写表
%xlswrite([fileName(1:end-4) '.xlsx'],edgeList)
%% 邻接矩阵写.mat
save([fileName(1:end-4) '.mat'],'AdjGraphMat','edgeList')
end
