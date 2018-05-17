% Processing Data from viper CFD simulations
close all; clc


%%%%%%%%%%%%%%%%%%%%% to do next:
%    - Higher resolution BL profile: done
%    - centerline pressure in stacked subplot
%    - full pressure plot (using delaunay triangles or whatever): imposs

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

n_high_res = 80;
[high_res_x_slice, high_res_slice_vals] = slice_data(data, 1, {[0 10], n_high_res});

%% Flow-wise quantity extraction
%%%%%%%%%%%%%%%% high res section

figure
hold on
set(gca,'XAxisLocation','origin')
set(gca,'Visible','off')


lower_BL = zeros(n_high_res,1);
lower_BL = lower_BL;

upper_wall = zeros(n_high_res,1);
lower_wall = upper_wall;

streamwise_pressure = upper_wall;

for h = 1:n_high_res
	x_slice = high_res_x_slice(h,:);
	[ x, y, u, v, p ] = cell_2_vector(x_slice);
	
	%Get wall arrays
	upper_wall(h) = max(y);
	lower_wall(h) = min(y);
	
	%Get BL arrays
	lower_BL(h) = get_BL_height(y,u);
	upper_BL(h) = -lower_BL(h);

	%Get centreline pressure
	streamwise_pressure(h) = p(round(end/2));
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
smoothing_edge = round(n_high_res*0.1);
plot(high_res_slice_vals, lower_BL,'m')
plot(high_res_slice_vals, upper_BL,'m')

%write bl thickness to file
BL_thickness = upper_wall - upper_BL';
file_ID = fopen([file_string, ' BL thickness.txt'],'w');
fprintf(file_ID,'%f\r\n', BL_thickness);
fclose(file_ID);





%% Span-wise analysis 
%Loop through each slice
for j = 1:n_slices-1
	x_slice = sliced_data(j,:);
	
	[ x, y, u, v, p ] = cell_2_vector(x_slice);
	
	%Plotting velocity profile
 	plot(x+u/4,y,'r')
	plot(x,y ,'b')
	quiver(x,y,u/4,zeros(size(u)),'b','MaxHeadSize',0.1,'AutoScale', 'off')
		

end

pressure_fig = figure;

plot(high_res_slice_vals, streamwise_pressure);
title('streamwise pressure')
xlabel('x')
ylabel('y')




fclose all;
