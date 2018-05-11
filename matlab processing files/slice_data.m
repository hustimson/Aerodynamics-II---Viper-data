function [ output ] = slice_data(data, slice_col, slice_vals)
% function takes input data and returns a cell array with same columns but
% only rows with values: slice_vals in column: slice_col
%
% because we don't want every point as it would clutter the analysis

% example: all row where the x value is one of the elements in [0:1:10]
%
%
% input/output format: cell array with format:
%{[x_col], [y_col], [u_col], [v_col], [p_col]} % at slice_val 1
%{[x_col], [y_col], [u_col], [v_col], [p_col]} % at slice_val 2


n_vars = size(data);
n_vars = n_vars(2);
n_slices = length(slice_vals);

sliced_cell = cell(n_slices,n_vars);


for i = 1:n_slices
	slice_val = slice_vals(i);
	
	% find indices of the rows which have a member of slice_vals in their slice_col
	slice = data{slice_col}(:)== slice_val;
	%creates a logical column vector with 1 at the indices of values that
	%satisfy the condition
	
	
	%loop through and add column for each variable 
	for j = 1:n_vars
		sliced_cell{i,j} = data{j}(slice);
	end
end


output = sliced_cell;
end
