function [ x, y, u, v, p ] = cell_2_vector( cell )
% Take in cell from a slice and break it out into usable vectors

x = cell2mat(cell(1));
y = cell2mat(cell(2));
u = cell2mat(cell(3));
v = cell2mat(cell(4));
p = cell2mat(cell(5));

end

