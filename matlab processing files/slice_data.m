function [ output,slice_vals ] = slice_data(data, slice_col, slice_vals)
% function takes input data and returns a cell array with same columns but
% only rows with values: slice_vals in column: slice_col
%
% because we don't want every point as it would clutter the analysis
%
% if slice_vals is a vector, find exact values
% otherwise slice_vals should be a cell where the first element is the
% range of values the slice desired, and the second element is the number of
% points desired in the range


%
% example: all row where the x value is one of the elements in [0:1:10]
%
%
% input/output format: cell array with format:
%{[x_col], [y_col], [u_col], [v_col], [p_col]} % at slice_val 1
%{[x_col], [y_col], [u_col], [v_col], [p_col]} % at slice_val 2


n_vars = size(data);
n_vars = n_vars(2);



% case where exact values are desired (integers basically)
if  isa(slice_vals, 'double')
	
	n_slices = length(slice_vals);
	sliced_cell = cell(n_slices,n_vars);
	
	for i = 1:n_slices
		slice_val = slice_vals(i);
		
		% find indices of the rows which have a member of slice_vals in their slice_col
		slice_logical = data{slice_col}(:) == slice_val;
		%creates a logical column vector with 1 at the indices of values that
		%satisfy the condition
		
		
		%loop through and add column for each variable
		for j = 1:n_vars
			sliced_cell{i,j} = data{j}(slice_logical);
		end
	end
	
%case where we are just picking values with a linear spacing 	
else
	if isa(slice_vals, 'cell')
		
	n_slices = slice_vals{2};
	
	
	% find unique values in the desired slice column
	unique_vals = [];
	for z = 1:length(data{1})
		if not(ismember(data{slice_col}(z),unique_vals))
			unique_vals = [unique_vals, data{slice_col}(z)];
		end
	end
	
	
	% Work out the values at which to take the slice
	[~, bottom_index] = min(abs(unique_vals - slice_vals{1}(1)));
	[~, top_index]    = min(abs(unique_vals - slice_vals{1}(2)));
	
	bottom = unique_vals(bottom_index);
	top = unique_vals(top_index);
	
	new_points = linspace(bottom,top,n_slices);
	
	% work out exact points that do exist to be fed into the exact part of the function
	closest_points = zeros(size(new_points));
	for i = 1:length(closest_points)
		target_point = new_points(i);
		[~, closest_point_index] = min(abs(unique_vals - target_point));
		closest_points(i) = unique_vals(closest_point_index);
	end
	
	% re call the function with exact vals
	sliced_cell = slice_data(data, slice_col, closest_points);
	slice_vals  = closest_points;
	end
end

output = sliced_cell;
end
