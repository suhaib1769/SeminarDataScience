% Load the CSV file
data = readmatrix('cleaned_countries.csv', 'OutputType', 'string');

% Store the 'Country' column separately
countries = data(:, 1);

% Remove the 'Country' column from the data matrix
data(:, 1) = [];
data(:, 1) = [];
data = str2double(data);
% Find the minimum and maximum values along each column
min_vals = min(data);
max_vals = max(data);

% Scale the matrix to the range [0, 1]
data = (data - min_vals) ./ (max_vals - min_vals);
num_countries = size(data, 1);
similarity_matrix = zeros(num_countries, num_countries);

for i = 1:num_countries
    for j = 1:num_countries
        row1 = data(i, :);
        row2 = data(j, :);
        %similarity_matrix(i, j) = 1 - dot(row1, row2) / (norm(row1) * norm(row2));
        similarity_matrix(i, j) = sqrt(sum((row1 - row2).^2));
    end
end