function [headers_array, data] = extract_data(filepath)
% Takes a *.dat file output by flow analysis tool Viper
% and returns the data in a usable cell array format
%
%format of data output: {[x],[y],[u],[v],[p]} 

fileID = fopen(filepath);

%% Get the headers out
headers_array = cell(3,1);

for i = 1:3
	line = fgetl(fileID);
	headers_array{i} = line;
end

%Extracting variable names %%%%%%%%%%%%%%%%% make this happen
%variables = headers_array{2};
%quote_indices = variables=='"';

variables = [ "X", "Y","U", "V","P"];
num_vars = length(variables);

%% Processing the data
var_index = 1;
big_array = cell(1, num_vars);

start_index = 1;

while var_index <= num_vars 
	%read in the next line of code and turn into a column vector
	line = fgetl(fileID);
	line = textscan(line,'%f');
	line = cell2mat(line);
	
	
	line_length = length(line);
	end_index = start_index + line_length - 1;
	
	%insert new values at the bottom of the relevant column
	big_array{var_index}(start_index:end_index,1) = line;
	
	start_index = end_index;
	
	%Check for the end of a variable block
	if length(line) < 10
		var_index = var_index + 1;
		start_index = 1;
	end
end

%write final output
headers_array = variables;
data = big_array;

end