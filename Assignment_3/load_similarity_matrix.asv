% Load the CSV file
data = readmatrix('cleaned_countries.csv', 'OutputType', 'string');

% Store the 'Country' column separately
countries = data(:, 1);

% Remove the 'Country' column from the data matrix
data(:, 1) = [];

% Perform one-hot encoding on the 'Region' column
regions = data(:, 1);
unique_regions = unique(regions); % Get unique regions

% Create a binary matrix for one-hot encoding
one_hot_matrix = zeros(size(regions, 1), numel(unique_regions));

% Assign binary indicators for each region
for i = 1:numel(unique_regions)
    one_hot_matrix(:, i) = strcmp(regions, unique_regions(i));
end

% Calculate similarities (using cosine similarity)
country_data = [one_hot_matrix data(:, 2:end)];
num_countries = size(country_data, 1);
similarity_matrix = zeros(num_countries, num_countries);

for i = 1:num_countries
    for j = 1:num_countries
        row1 = str2double(country_data(i, :));
        row2 = str2double(country_data(j, :));
        similarity_matrix(i, j) = sqrt(sum((row1 - row2).^2));
    end
end
