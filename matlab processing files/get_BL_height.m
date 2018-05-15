function [ height ] = get_BL_height( y, u )
% Find distance from the centre of the duct of BL edge
% take in column vectors y and u from a vertical slice

    %find greatest u velocity in the vertical slice
	max_velocity = max(u); 
	
	%slide in from the edge of the duct until the first value that is
	%at least 99% of the centre velocity
	m = 1;
	in_boundary_layer = true;
	while in_boundary_layer
		if u(m) > 0.99*max_velocity
			height = y(m);
			in_boundary_layer = false;
		end
		m = m+1;
	end
		

end

