function [] = charting(sheet,data2,data3,sheet2,data4)

%从数据表中读取数据并绘制三维图形
z = xlsread('dataTable.xlsx',sheet2,data4);
x = xlsread('dataTable.xlsx',sheet,data2);
y = xlsread('dataTable.xlsx',sheet,data3);

%确定网格坐标（x和y方向的步长均取0.1）
[X,Y]=meshgrid(min(x):0.1:max(x),min(y):0.1:max(y)); 
%在网格点位置插值求Z
Z=griddata(x,y,z,X,Y,'v4');
%绘制曲面
figure(1)
surf(X,Y,Z);
shading interp;
colormap hsv;

end

