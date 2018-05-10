clc
close all


theta = deg2rad(linspace(0,360,7));

[x, y, z] = pol2cart(theta, mesh(:,2),mesh(:,1));

plot3(x,y,z,'.');
%{
for i = 1:length(mesh)
	
	a = x(i,:);
	b = y(i,:);
	c = repmat(z(i),9);
	
	plot3(a,b,c,'-');
	hold on

end
%}