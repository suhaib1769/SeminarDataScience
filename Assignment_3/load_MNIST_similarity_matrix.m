% Load the CSV file
data = readmatrix('optical+recognition+of+handwritten+digits\optdigits_train.csv', 'OutputType', 'string');
% Store the 'Country' column separately
targets = data(:, size(data, 2));
data(:, size(data, 2)) = [];

data = str2double(data);

num_targets = size(data, 1);

distances = pdist(data);
% Reshape the vector into a square matrix
similarity_matrix = squareform(distances);