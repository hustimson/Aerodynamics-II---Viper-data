% Plotting Data from viper CFD simulations

%% Import data
file_path = 'Re1.dat.dat';

[variables, data] = extract_data(file_path);

%% Slice the data

%% DO something with the data
figure
hold on
set(gca,'XAxisLocation','origin')
daspect([1 0.5 1])
plot(values,upper_boundary,'k')
plot(values,lower_boundary,'k')

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


%%%%%%%% Should try streamslice function on full data set