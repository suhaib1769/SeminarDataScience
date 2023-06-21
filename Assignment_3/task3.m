normalisation_method = 'min_max';
dataset = 'countries';

if strcmpi(normalisation_method, 'regular') && strcmpi(dataset, 'countries')
    run("load_similarity_matrix.m")
end

if strcmpi(normalisation_method, 'regular') && strcmpi(dataset, 'cars')
    run("load_cars_similarity_matrix.m")
end

if strcmpi(normalisation_method, 'min_max') && strcmpi(dataset, 'countries')
    run("load_similarity_matrix_min_max_norm.m")
end

if strcmpi(normalisation_method, 'min_max') && strcmpi(dataset, 'cars')
    run("load_cars_min_max_norm.m")
end

D = similarity_matrix;
% Given pairwise distance matrix D
n = size(D, 1);  % number of rows/data points

% Create a column vector of ones
e = ones(n, 1);

% Identity matrix
I_n = eye(n);
% Compute the Gram matrix
G = -0.5 * (I_n - 1/n * (e * e')) * D * (I_n - 1/n * (e * e'));
G_og = G;
G = 0.5 * (G + G');
% Compute eigenvalues and eigenvectors of G
[V, D2] = eig(G);

% Extract eigenvalues from diagonal matrix D
eigenvalues = flip(diag(D2));
eigenvalues(eigenvalues < 0) = 0;


% Select the desired dimension (d)
dims = [1, 2, 3];
for dimIndex=1:length(dims)
    dim = dims(dimIndex);
    % Get the coordinates of each point
    coordinates = zeros(num_countries, dim);
    for i=1:num_countries
        coordinates(i, :) = sqrt(eigenvalues(i)) * V(1:dim, i);
    end

    similarity_matrix2 = zeros(num_countries, num_countries);
    for i = 1:num_countries
        for j = 1:num_countries
            row1 = coordinates(i, :);
            row2 = coordinates(j, :);
            similarity_matrix2(i, j) = sqrt(sum((row1 - row2).^2));
            %similarity_matrix2(i, j) = 1 - dot(row1, row2) / (norm(row1) * norm(row2));
        end
    end
    % Calculate squared Euclidean distance
    stress = sum((similarity_matrix - similarity_matrix2).^2, 'all') / 2;
    disp(dim)
    disp(stress)
end

correct_implementation = mdscale(D, 3);
similarity_matrix_3 = zeros(num_countries, num_countries);
for i = 1:num_countries
    for j = 1:num_countries
        row1 = correct_implementation(i, :);
        row2 = correct_implementation(j, :);
        similarity_matrix_3(i, j) = sqrt(sum((row1 - row2).^2));
        %similarity_matrix2(i, j) = 1 - dot(row1, row2) / (norm(row1) * norm(row2));
    end
end
disp('correct implementation')
stress = sum((similarity_matrix - similarity_matrix_3).^2, 'all') / 2;
disp(stress)

% Combine country names with coordinates matrix
coordinates_with_countries = horzcat(countries, coordinates);


% Plot the coordinates on a 2D plot
plot(coordinates(1:15:end, 1), coordinates(1:15:end, 2), 'o');
xlabel('Dimension 1');
ylabel('Dimension 2');
title('2D Representation of Data Points');

% Add country names as text annotations
text(coordinates(1:15:end, 1), coordinates(1:15:end, 2), countries(1:15:end), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');