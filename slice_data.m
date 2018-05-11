function [ output ] = slice_data(data, slice_col, slice_vals)
% function takes input data and returns a cell array with same columns but
% only rows with values: slice_vals in column: slice_col
%
% because we don't want every point as it would clutter the analysis

% example: all row where the x value is one of the elements in [0:1:10]
%
%
% input/output format: cell array with format:
% {[x_col], [y_col], [u_col], [v_col], [p_col]}



n_vars = size(data);
n_vars = n_vars(1);
sliced_cell = cell(1,n_vars);

n_slices = length(slice_vals);


slice = zeros(length(data(:,1)),1);

%% Find the rows
% find indices of the rows which have a member of slice_vals in their slice_col

for element = slice_vals
	 %Finding the values in column X
	next_slice = data{slice_col}(:)==element;
	
	%creates a logical column vector with 1 at the indices of values that
	%satisfy the condition
	slice = slice + next_slice;
end

slice = logical(slice);


%% Extract the rows at indices found above
for i = 1:n_vars
	sliced_cell{i} = data{i}(slice);
end

%{
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
%}

output = sliced_cell
end
