% Load the CSV file
data = readmatrix('iris\iris.csv', 'OutputType', 'string');

% Store the 'Country' column separately
targets = data(:, size(data, 2));

% Remove the 'Country' column from the data matrix
data(:, size(data, 2)) = [];

data = str2double(data);

num_columns = size(data, 2);  % Get the number of columns
for i = 1:num_columns
    column = data(:, i);  % Extract the current column
    
    % Find the minimum and maximum values of the current column
    min_val = min(column);
    max_val = max(column);
    % Scale the current column to the range [0, 1]
    normalized_column = (column - min_val) / (max_val - min_val);
    
    % Assign the normalized column back to the corresponding column in the matrix
    data(:, i) = normalized_column;
end

distances = pdist(data);
% Reshape the vector into a square matrix
similarity_matrix = squareform(distances);

num_targets = size(data, 1);
