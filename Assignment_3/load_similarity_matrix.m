% Load the CSV file
data = readmatrix('cleaned_countries.csv', 'OutputType', 'string');

% Store the 'Country' column separately
countries = data(:, 1);

% Remove the 'Country' column from the data matrix
data(:, 1) = [];
data(:, 1) = [];

data = str2double(data);

num_columns = size(data, 2);  % Get the number of columns
for i = 1:num_columns
    column = data(:, i);  % Extract the current column
    % Scale the current column to the range [0, 1]
    normalized_column = normalize(column);
    
    % Assign the normalized column back to the corresponding column in the matrix
    data(:, i) = normalized_column;
end

num_countries = size(data, 1);
similarity_matrix = zeros(num_countries, num_countries);

for i = 1:num_countries
    for j = 1:num_countries
        row1 = data(i, :);
        row2 = data(j, :);
        %similarity_matrix(i, j) = 1 - dot(row1, row2) / (norm(row1) * norm(row2));
        similarity_matrix(i, j) = sum((row1 - row2).^2);
    end
end
