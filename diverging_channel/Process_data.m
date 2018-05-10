clear all;
close all;
clc;
%% Import data
file_path = 'Re1.dat.dat';

[variables, data] = extract_data(file_path);

n_vars = length(variables);

%% Slice the data
% because we don't want every point as it would clutter the analysis

values = 0:1:10; %Values we want
n_slices = length(values);
column = 1; %Column we want them out of

slice = zeros(length(data(:,1)),1);

%do an x slice
for element = values
	next_slice = data(:,column)==element; %Finding the values in column X
	slice = slice + next_slice;
end
slice = logical(slice);
X = data(slice,1);
Y = data(slice,2);
U = data(slice,3);
V = data(slice,4);
P = data(slice,5);


upper_boundary = zeros(n_slices,1);
lower_boundary = upper_boundary;
vertical_slices = cell(n_slices,1);

% Separate and store vertical slices nicely

for i = 1:n_slices
	value = values(i);
	x_logical = X == value;
	%Extract boundary points
	upper_boundary(i) = max(Y(x_logical));
	lower_boundary(i) = min(Y(x_logical));
	
	
	%store each vertical slice in a cell array
	vertical_slice = zeros(1,n_vars);
	
	vertical_slice(1:length(X(x_logical)),1) = X(x_logical);
	vertical_slice(1:length(Y(x_logical)),2) = Y(x_logical);
	vertical_slice(1:length(U(x_logical)),3) = U(x_logical);
	vertical_slice(1:length(V(x_logical)),4) = V(x_logical);
	vertical_slice(1:length(P(x_logical)),5) = P(x_logical);
	
	vertical_slices{i} = vertical_slice;
	
	
end


%% DO something with the data
figure
hold on
set(gca,'XAxisLocation','origin')
daspect([1 0.5 1])
plot(values,upper_boundary,'k')
plot(values,lower_boundary,'k')


for j = 1:n_slices
	this_slice = vertical_slices{j};
	x = this_slice(:,1);
	y = this_slice(:,2);
	u = this_slice(:,3);
	v = this_slice(:,4);
	p = this_slice(:,5);
	
	quiver(x,y,u/4,v,'b','MaxHeadSize',0.1,'AutoScale', 'off')
	
	plot(x+u/4,y,'r')
	plot(x,y ,'b')
	hold on
end


%%%%%%%% Should try streamslice function on full data set

