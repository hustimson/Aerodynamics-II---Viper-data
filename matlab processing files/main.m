% Processing Data from viper CFD simulations
close all; clc


%% Import data
choose = 0;
if choose
	[file_name, file_path] = uigetfile('..\output .dat files\.dat');
	file_path = [file_path, file_name];
	[variables, data] = extract_data(file_path);
	file_string = file_name(1:end-4);

else
	file_path = '..\output .dat files\converging\E4\ConvergN8Re_10E4.dat';
	[variables, data] = extract_data(file_path);
	file_string = 'ConvergN8Re_10E4.dat';
end



%% Slice the data
slice_vals = 0:1:10;
n_slices = length(slice_vals);
slice_col = 1; %slice by x values
sliced_data = slice_data(data, slice_col, slice_vals);


%% Flow-wise quantity extraction

upper_boundary = zeros(n_slices,1);
lower_boundary = upper_boundary;

upper_BL = upper_boundary;
lower_BL = upper_boundary;


for i = 1:n_slices
	this_slice = sliced_data(i,:);
	
	x = cell2mat(this_slice(1));
	y = cell2mat(this_slice(2));
	u = cell2mat(this_slice(3));
	v = cell2mat(this_slice(4));
	p = cell2mat(this_slice(5));
	
	upper_boundary(i) = max(y);
	lower_boundary(i) = min(y);
	
	%find greatest u velocity less than 0.2 away from duct centre
	centre_velocity = max(u(abs(y)<0.05)); 
	
	%slide in from the edge of the duct until the first value that is
	%at least 99% of the centre velocity
	m = 1;
	in_boundary_layer = true;
	while in_boundary_layer
		if u(m) > 0.99*centre_velocity
			upper_BL(i) = -y(m);
			lower_BL(i) = y(m); %assuming symmetry 
			in_boundary_layer = false;
		end
		m = m+1;
	end
		
end


figure
hold on
set(gca,'XAxisLocation','origin')
title(file_string, 'Interpreter', 'none')
%daspect([1 0.5 1])
plot(slice_vals,upper_boundary,'k')
plot(slice_vals,lower_boundary,'k')

plot(slice_vals, upper_BL,'m')
plot(slice_vals, lower_BL,'m')


%% Span-wise analysis 
%Loop through each slice
for j = 1:n_slices
	this_slice = sliced_data(j,:);
	
	x = cell2mat(this_slice(1));
	y = cell2mat(this_slice(2));
	u = cell2mat(this_slice(3));
	v = cell2mat(this_slice(4));
	p = cell2mat(this_slice(5));
	
	
	%Plotting velocity profile
% 	quiver(x,y,u/4,zeros(size(u)),'b','MaxHeadSize',0.1,'AutoScale', 'off')
% 	plot(x+u/4,y,'r')
% 	plot(x,y ,'b')
end

%}
%%%%%%%% Should try streamslice function on full data set