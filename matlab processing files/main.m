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
	file_path = '..\output .dat files\converging\E4\ConvergN8Re_10E4.dat';
	[variables, data] = extract_data(file_path);
	file_string = 'ConvergN8Re_10E4.dat';
end



%% Slice the data
%Because I don't wanna be working with 13000 row vectors
slice_vals = 0:1:10;
n_slices = length(slice_vals);
slice_col = 1; %slice by x values
sliced_data = slice_data(data, slice_col, slice_vals);

n_high_res = 100
high_res_x_slice = slice_data(data, 1, {[1 13369], 5})

%% Flow-wise quantity extraction
%%%%%%%%%%%%%%%% high res section
%{
for h = i:n_high_res
	disp(high_res_x_slice(h,:))
% 	plot(high_res_x_slice(h,1),high_res_x_slice(h,2));
% 	hold on
end
%}



%%%%%%%%%%%% low res section
upper_wall = zeros(n_slices,1);
lower_wall = upper_wall;

upper_BL = upper_wall;
lower_BL = upper_wall;


for i = 1:n_slices
	x_slice = sliced_data(i,:);
	
	x = cell2mat(x_slice(1));
	y = cell2mat(x_slice(2));
	u = cell2mat(x_slice(3));
	v = cell2mat(x_slice(4));
	p = cell2mat(x_slice(5));
	
	upper_wall(i) = max(y);
	lower_wall(i) = min(y);
	
	%find greatest u velocity less than 0.2 away from duct centre
	centre_velocity = u(floor(end/2));%max(u(abs(y)<0.05)); 
	
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
set(gca,'Visible','off')

%daspect([1 0.5 1])
plot(slice_vals,upper_wall,'k')
plot(slice_vals,lower_wall,'k')
[y_corner, x_corner] = max(upper_wall); 
fill([slice_vals, abs(11-x_corner)],[lower_wall; -y_corner],[0.5 0.5 0.5]);
fill([slice_vals, abs(11-x_corner)],[upper_wall;  y_corner],[0.5 0.5 0.5]);
text(4,y_corner-0.1,file_string, 'Interpreter', 'none')

plot(slice_vals, upper_BL,'m')
plot(slice_vals, lower_BL,'m')


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