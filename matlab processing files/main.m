% Processing Data from viper CFD simulations

%% Import data
file_path = '..\output .dat files\diverging\Re1.dat';

[variables, data] = extract_data(file_path);

%% Slice the data
slice_vals = 0:1:10;
n_slices = length(slice_vals);
slice_col = 1; %slice by x values
sliced_data = slice_data(data, slice_col, slice_vals);


%% DO something with the data

upper_boundary = zeros(n_slices,1);
lower_boundary = upper_boundary;

for i = 1:n_slices
	this_slice = sliced_data(i,:);
	
	
	upper_boundary(i) = max(this_slice{2});
	lower_boundary(i) = min(this_slice{2});
end


figure
hold on
set(gca,'XAxisLocation','origin')
%daspect([1 0.5 1])
plot(slice_vals,upper_boundary,'k')
plot(slice_vals,lower_boundary,'k')


%{
%Loop through each slice
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

%}
%%%%%%%% Should try streamslice function on full data set