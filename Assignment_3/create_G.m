D = similarity_matrix;
n = size(D, 1);  % Get the size of D

% Create the n x n identity matrix In
In = eye(n);

% Create the vector e of ones
e = ones(n, 1);

% Calculate the intermediate matrices
A = In - (1/n) * (e * e');
B = D;

% Calculate G using the formula
G = -0.5 * A * B * A;

% Compute eigenvalues and eigenvectors of G
[V, D] = eig(G);

% Extract eigenvalues from diagonal matrix D
eigenvalues = diag(D);

% Display eigenvalues
disp('Eigenvalues:');
disp(eigenvalues);

% Display eigenvectors
disp('Eigenvectors:');
disp(V);

% Select the desired dimension (d)
d = 2;

% Get the coordinates of each point
coordinates = sqrt(D) * V(:, 1:d);

% Display the coordinates of each point
disp('Coordinates:');
disp(coordinates);
% Combine country names with coordinates matrix
coordinates_with_countries = horzcat(countries, coordinates);

% Display the combined matrix
disp('Coordinates with Countries:');
disp(coordinates_with_countries);

% Plot the coordinates on a 2D plot
plot(coordinates(:, 1), coordinates(:, 2), 'o');
xlabel('Dimension 1');
ylabel('Dimension 2');
title('2D Representation of Data Points');

% Add country names as text annotations
text(coordinates(:, 1), coordinates(:, 2), countries, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');

similarity_matrix2 = zeros(num_countries, num_countries);
for i = 1:num_countries
    for j = 1:num_countries
        row1 = coordinates(i, :);
        row2 = coordinates(j, :);
        similarity_matrix2(i, j) = sqrt(sum((row1 - row2).^2));
    end
end
% Calculate squared Euclidean distance
diff = sum((similarity_matrix - similarity_matrix2).^2, 'all');
disp(diff)