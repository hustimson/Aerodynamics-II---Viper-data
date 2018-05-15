% Processing Data from viper CFD simulations
close all; clc


%%%%%%%%%%%%%%%%%%%%% to do next:
%    - Higher resolution BL profile
%    - centerline pressure in stacked subplot
%    - full pressure plot (using delaunay triangles or whatever)

%% Import data


%allow user to choose a .dat file to analyse, or for ease of debug, use a
%pre-entered file

choose = 1;
if choose
	[file_name, file_path] = uigetfile('..\output .dat files\.dat');
	file_path = [file_path, file_name];
	[variables, data] = extract_data(file_path);
	file_string = file_name(1:end-4);

else
	file_path = '..\output .dat files\converging\E2\ConvergN8Re_10E2.dat';
	[variables, data] = extract_data(file_path);
	file_string = 'ConvergN8Re_10E2.dat';
end



%% Slice the data
%Because I don't wanna be working with 13000 row vectors
slice_vals = 0:1:10;
n_slices = length(slice_vals);
slice_col = 1; %slice by x values
sliced_data = slice_data(data, slice_col, slice_vals);

n_high_res = 100;
[high_res_x_slice, high_res_slice_vals] = slice_data(data, 1, {[0 10], n_high_res});

%% Flow-wise quantity extraction
%%%%%%%%%%%%%%%% high res section

figure
hold on
set(gca,'XAxisLocation','origin')
set(gca,'Visible','off')


upper_BL = zeros(n_high_res,1);
lower_BL = upper_BL;

upper_wall = zeros(n_high_res,1);
lower_wall = upper_wall;

for h = 1:n_high_res
	x_slice = high_res_x_slice(h,:);
	
	x = cell2mat(x_slice(1));
	y = cell2mat(x_slice(2));
	u = cell2mat(x_slice(3));
	v = cell2mat(x_slice(4));
	p = cell2mat(x_slice(5));
	
	upper_wall(h) = max(y);
	lower_wall(h) = min(y);
	
	upper_BL(h) = get_BL_height(y,u);
	lower_BL(h) = -upper_BL(h);
end

%plot wall lines
plot(high_res_slice_vals, upper_wall, 'k')
plot(high_res_slice_vals, lower_wall, 'k')

%fill in wall sections
[y_corner, y_corner_index] = max(upper_wall);
if y_corner == 0.5
	x_corner = 0;
else
	x_corner = 10;
end
fill([high_res_slice_vals, abs(10-x_corner)],[lower_wall; -y_corner],[0.5 0.5 0.5]);
fill([high_res_slice_vals, abs(10-x_corner)],[upper_wall;  y_corner],[0.5 0.5 0.5]);

% Print name of file being analysed on the plot
text(4,y_corner-0.1,file_string, 'Interpreter', 'none')

%plot the boundary layer profiles
plot(high_res_slice_vals, smoothdata(upper_BL),'m')
plot(high_res_slice_vals, smoothdata(lower_BL),'m')


%% Span-wise analysis 
%Loop through each slice
for j = 1:n_slices-1
	x_slice = sliced_data(j,:);
	
	
	x = cell2mat(x_slice(1));
	y = cell2mat(x_slice(2));
	u = cell2mat(x_slice(3));
	v = cell2mat(x_slice(4));
	p = cell2mat(x_slice(5));
	
	
	%Plotting velocity profile
 	plot(x+u/4,y,'r')
	plot(x,y ,'b')
	quiver(x,y,u/4,zeros(size(u)),'b','MaxHeadSize',0.1,'AutoScale', 'off')
		
	% 2 axis slicing section
	%{
	% re slice in the y direction
	n_y_slices = 30;
	y_slices = slice_data(x_slice,2,{[1,length(x_slice{1})], n_y_slices});

	
	
	for k = 1:n_y_slices-1
		y_slice = y_slices(k,:);
		
		x = cell2mat(y_slice(1));
		y = cell2mat(y_slice(2));
		u = cell2mat(y_slice(3));
		v = cell2mat(y_slice(4));
		p = cell2mat(y_slice(5));
		
		%Plotting velocity profile
		quiver(x,y,u/4,zeros(size(u)),'b','MaxHeadSize',0.1,'AutoScale', 'off')
		
	end
	%}
	
end


%% pressure plotting


% figure
% image(data{1},data{2},data{5})



%}
%%%%%%%% Should try streamslice function on full data set