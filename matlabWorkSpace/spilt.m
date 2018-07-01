function [ ] = spilt(str,title,sheet,range)
%切割字符串到指定表格文件

str = deblank(str);
%正则表达式
S = regexp(str, '\/', 'split'); 
%写入文件
result = [{title};S']; 
xlswrite('dataTable.xlsx',result,sheet,range);          

end

