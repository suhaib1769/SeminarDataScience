data = readtable('AirQualityUCI.csv', VariableNamingRule='preserve');
data = data(:,3:end);
data_matrix = table2array(data);
size(data_matrix)

%% 
% PCA with Coviariance matrix
% Step 1: Compute the center of the points (mean)
mu = mean(data_matrix);

% Step 2: Compute the centered points (subtract mean)
data_centered = data_matrix - mu;

% Step 3: Compute the covariance matrix
C = cov(data_centered);

% Step 4: Compute eigenvalues and eigenvectors of the covariance matrix
[V, D] = eig(C);

% Sort the eigenvalues in descending order and get the indices
[eigValues, order] = sort(diag(D), 'descend');

% Sort the eigenvectors based on the order of eigenvalues
eigVectors = V(:, order);

% Project the original data onto the PCA space
data_pca = data_centered * eigVectors;

% Display the eigenvalues and eigenvectors
disp('Eigenvalues:')
disp(diag(D))
disp('Eigenvectors:')
disp(V);

% Plot the first two principal components
figure;
scatter(data_pca(:, 1), data_pca(:, 2));
xlabel('PC1');

%%
% PCA with Gram matrix
% Step 1: Compute the center of the points
mu2 = mean(data_matrix);

% Step 2: Compute the centered points
data_centered2 = data_matrix - mu2;

% Step 3: Compute the Gram matrix
G = data_centered2 * data_centered2';

% Step 4: Compute eigenvalues and eigenvectors of the Gram matrix
[V, D] = eig(G);

% Sort the eigenvalues in descending order and get the indices
[eigValues, order] = sort(diag(D), 'descend');

% Sort the eigenvectors based on the order of eigenvalues
eigVectors = V(:, order);

% Step 5: Compute the basis vectors of the affine spaces
basis_vectors = data_centered' * eigVectors;
basis_vectors = basis_vectors ./ vecnorm(basis_vectors);

% Display the basis vectors
disp('Basis vectors:')
disp(basis_vectors)
