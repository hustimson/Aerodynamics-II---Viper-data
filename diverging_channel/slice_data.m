function [ output ] = slice_data(data, slice_col, slice_vals)
% function takes input data and returns a cell array with sme columns but
% only rows with values: slice_vals in column: slice_col
%
% example: all row where the x value is one of the elements in [0:1:10]
%
%
%
% data input format: [ x y u v p ]
%                    [ x y u v p ]
%                    [ x y u v p ]
%
% output format: cell array with format [x_col],[y_col],[u_col],[v_col],[p_col]



%% slicing data


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

end
