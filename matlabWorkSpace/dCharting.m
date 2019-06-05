function [] = dCharting(sheet1,data1,data2,data3,sheet2,data4)
%绘制两个重叠的图表
%从数据表中读取数据并绘制三维图形
z1 = xlsread('dataTable.xlsx',sheet1,data1);
x = xlsread('dataTable.xlsx',sheet1,data2);
y = xlsread('dataTable.xlsx',sheet1,data3);

z2 = xlsread('dataTable.xlsx',sheet2,data4);

%确定网格坐标（x和y方向的步长均取0.1）
[X,Y] = meshgrid(min(x):0.1:max(x),min(y):0.1:max(y)); 
%在网格点位置插值求Z，注意：不同的插值方法得到的曲线光滑度不同
Z1 = griddata(x,y,z1,X,Y,'v4');
Z2 = griddata(x,y,z2,X,Y,'v4');

%绘制曲面
figure(1)
surf(X,Y,Z1);
shading flat;
colormap hsv;
freezeColors;
hold on
%第二个曲面
surf(X,Y,Z2);
shading interp;
colormap pink;
hold off
end

