% Read the tab-delimited text file
data = readmatrix("imports-85.csv", 'OutputType', 'string');

countries = data(:, 2);
% Remove the third column
data(:, 2) = [];
data = str2double(data);
data = normalize(data);

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