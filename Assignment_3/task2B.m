% Load data
data = readtable('AirQualityUCI.csv', VariableNamingRule='preserve');
data = data(:,3:end);
data_matrix = table2array(data);

% PCA with Covariance matrix
% Step 1: Compute the center of the points (mean)
mu = mean(data_matrix);

% Step 2: Compute the centered points (subtract mean)
data_centered = data_matrix - mu;

% Step 3: Compute the covariance matrix
tic; % start timing
C = cov(data_centered);

% Step 4: Compute eigenvalues and eigenvectors of the covariance matrix
[V, D] = eig(C);

% Sort the eigenvalues in descending order and get the indices
[eigValues_full, order] = sort(diag(D), 'descend');

% Sort the eigenvectors based on the order of eigenvalues
eigVectors_full = V(:, order);
time_full = toc; % end timing

% Project the original data onto the PCA space
data_pca_full = data_centered * eigVectors_full;

% Fraction of total variance for the first two PCs
variance_explained_full = sum(eigValues_full(1:2))/sum(eigValues_full);


% PCA with Covariance matrix using a subset of the data (landmarks)
% Step 3: Select landmarks
fraction = 0.5;  % fraction of landmarks to keep

% total number of columns
n = size(data_matrix, 2);

% number of landmarks to keep
num_landmarks = round(n * fraction);

% indices of landmarks to keep
indices = randperm(n, num_landmarks);

% Compute the corresponding columns of the covariance matrix
tic; % start timing
C = cov(data_centered(:, indices));

% Step 4: Compute eigenvalues and eigenvectors of the covariance matrix
[V, D] = eig(C);

% Sort the eigenvalues in descending order and get the indices
[eigValues_landmarks, order] = sort(diag(D), 'descend');

% Sort the eigenvectors based on the order of eigenvalues
eigVectors_landmarks = V(:, order);
time_landmarks = toc; % end timing

% Project the original data onto the PCA space
data_pca_landmarks = data_centered(:, indices) * eigVectors_landmarks;

% Fraction of total variance for the first two PCs
variance_explained_landmarks = sum(eigValues_landmarks(1:2))/sum(eigValues_landmarks);

% Display the results
fprintf('Full data: time = %.2f s, variance explained by first two PCs = %.2f\n', time_full, variance_explained_full);
fprintf('Landmarks: time = %.2f s, variance explained by first two PCs = %.2f\n', time_landmarks, variance_explained_landmarks);
