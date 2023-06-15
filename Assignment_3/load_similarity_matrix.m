% Load the CSV file
data = readmatrix('cleaned_countries.csv', 'OutputType', 'string');

% Store the 'Country' column separately
countries = data(:, 1);

% Remove the 'Country' column from the data matrix
data(:, 1) = [];
data(:, 1) = [];
data = normalize(str2double(data));
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
