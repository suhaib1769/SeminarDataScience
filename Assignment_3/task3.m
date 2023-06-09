dataset = 'mnist';

if strcmpi(dataset, 'mnist')
    run("load_MNIST_similarity_matrix.m")
end

if strcmpi(dataset, 'iris')
    run("load_similarity_matrix_iris.m")
end

D = similarity_matrix;
tic;
% Calculate the centering matrix H
n = size(D, 1);
H = eye(n) - (1/n) * ones(n);

% Compute the Gram matrix G
G = -0.5 * H * D * H;

[eigenvectors, eigenvalues] = eig(G);
eigenvalues = diag(eigenvalues);
eigenvalues_time = toc;
% Select the desired dimension (d)
dims = [1, 2, 3, 4];
for dimIndex=1:length(dims)
    tic;
    dimension = dims(dimIndex); % Number of dimensions
    eigenvalues_dimension = eigenvalues(1:dimension);
    eigenvectors_dimension = eigenvectors(:, 1:dimension);
    coordinates = eigenvectors_dimension * diag(sqrt(eigenvalues_dimension));
    coordinates_time = toc;
    % Calculate squared Euclidean distance
    distances = pdist(coordinates);
    % Reshape the vector into a square matrix
    distance_matrix = squareform(distances);

    % Calculate the squared differences
    differences = distance_matrix - D;
    stress = sum(sum(differences.^2));

    disp(['For ', num2str(dimension), ' dimensions:'])
    disp(['Stress: ', num2str(stress)])
    disp(['Run-time: ', num2str(eigenvalues_time + coordinates_time)])
    disp('----------------------')
end
tic;
% matlab_implementation = mdscale(D, 2, 'Criterion', 'sstress');
% matlab_implementation_run_time = toc;
% disp('For matlab implementation on 2 dimensions')
% distances = pdist(matlab_implementation);
% % Reshape the vector into a square matrix
% distance_matrix_correct = squareform(distances);
% 
% % Calculate the squared differences
% differences = distance_matrix_correct - D;
% stress = sum(sum(differences.^2));
% disp(['Stress: ', num2str(stress)])
% disp(['Run-time: ', num2str(matlab_implementation_run_time)])

% Combine country names with coordinates matrix
coordinates_with_targets = horzcat(targets, coordinates);

unique_targets = unique(targets);
num_unique_targets = numel(unique_targets);
color_map = lines(num_unique_targets);

% Plot the points with colors
for i = 1:numel(unique_targets)
    country_indices = strcmp(targets, unique_targets{i});
    scatter(coordinates(country_indices, 1), coordinates(country_indices, 2), [], color_map(i, :), 'filled');
    hold on;
end

hold off;

% Set colorbar to show the legend
colormap(color_map);
c = colorbar('Ticks', linspace(0, 1, num_unique_targets), 'TickLabels', unique_targets);
c.Label.String = 'targets';

% Plot the points with colors in 3D
figure;
for i = 1:numel(unique_targets)
    country_indices = strcmp(targets, unique_targets{i});
    scatter3(coordinates(country_indices, 1), coordinates(country_indices, 2), coordinates(country_indices, 3), [], color_map(i, :), 'filled');
    hold on;
end

hold off;

% Set colorbar to show the legend
colormap(color_map);
c = colorbar('Ticks', linspace(0, 1, num_unique_targets), 'TickLabels', unique_targets);
c.Label.String = 'targets';
