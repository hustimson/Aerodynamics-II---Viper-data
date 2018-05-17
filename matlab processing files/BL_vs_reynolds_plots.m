% Plotting BL thickness vs x for various reynolds numbers

section = 'Straight';

switch section
	case 'Converg'
		re1     = importdata([section,'N8Re_10E0 BL thickness.txt']);
		re10    = importdata([section,'N8Re_10E1 BL thickness.txt']);
		re100   = importdata([section,'N8Re_10E2 BL thickness.txt']);
		re1000  = importdata([section,'N8Re_10E3 BL thickness.txt']);
		re10000 = importdata([section,'N8Re_10E4 BL thickness.txt']);
		
		hold on
		plot(high_res_slice_vals,re1,    'DisplayName','Re = 10^0')
		plot(high_res_slice_vals,re10,   'DisplayName','Re = 10^1')
		plot(high_res_slice_vals,re100,  'DisplayName','Re = 10^2')
		plot(high_res_slice_vals,re1000, 'DisplayName','Re = 10^3')
		plot(high_res_slice_vals,re10000,'DisplayName','Re = 10^4')
		
		legend('show','location','northeast')
		title('Boundary Layer profiles, Converging duct');
		
	case 'Diverg'
		re1     = importdata([section,'N8Re_10E0 BL thickness.txt']);
		re10    = importdata([section,'N8Re_10E1 BL thickness.txt']);
		re100   = importdata([section,'N8Re_10E2 BL thickness.txt']);
		re1000  = importdata([section,'N8Re_10E3 BL thickness.txt']);
		re500   = importdata([section,'N8Re_5x10E2 BL thickness.txt']);
		
		hold on
		plot(high_res_slice_vals,re1,    'DisplayName','Re = 10^0')
		plot(high_res_slice_vals,re10,   'DisplayName','Re = 10^1')
		plot(high_res_slice_vals,re100,  'DisplayName','Re = 10^2')
		plot(high_res_slice_vals,re500,  'DisplayName','Re = 500')
		plot(high_res_slice_vals,re1000, 'DisplayName','Re = 10^3')

		legend('show','location','southeast')
		title('Boundary Layer profiles, Diverging duct');
		
	case 'Straight'	
		re1     = importdata([section,'N8Re_10E0 BL thickness.txt']);
		re10    = importdata([section,'N8Re_10E1 BL thickness.txt']);
		re100   = importdata([section,'N8Re_10E2 BL thickness.txt']);
		re500   = importdata([section,'N8Re_5x10E2 BL thickness.txt']);
		re1000  = importdata([section,'N8Re_10E3 BL thickness.txt']);
		
		hold on
		plot(high_res_slice_vals,re1,    'DisplayName', 'Re = 10^0')
		plot(high_res_slice_vals,re10,   'DisplayName', 'Re = 10^1')
		plot(high_res_slice_vals,re100,  'DisplayName', 'Re = 10^2')
		plot(high_res_slice_vals,re500,  'DisplayName', 'Re = 500')
		plot(high_res_slice_vals,re1000, 'DisplayName', 'Re = 10^3')

		legend('show','location','southeast')		
		title('Boundary Layer profiles, Straight duct');
end

xlabel('x location')
ylabel('Boundary layer thickness (\delta)')

saveas(gcf,['..\MATLAB plots\',section,'BL profile vs Re.png']);

