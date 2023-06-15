% get dataset 1
data1 = readtable('AirQualityUCI.csv', VariableNamingRule='preserve');
data1 = data1(:,3:end);
data1_matrix = table2array(data1);
disp(size(data1_matrix));

%% PCA with Coviariance matrix
tic;
% Step 1: Compute the center of the points (mean)
mu = mean(data1_matrix);

% Step 2: Compute the centered points (subtract mean)
data_centered = data1_matrix - mu;

% Step 3: Compute the covariance matrix
[n, m] = size(data_centered); % n = number of observations, m = number of variables
normalization_factor = n - 1; % For unbiased estimate
C = (data_centered' * data_centered) ./ normalization_factor;

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

% Step 5: Extract eigenvalues from matrix D
eigenvalues = diag(D);

% Step 6: Calculate proportion of variance explained
variance_explained = eigenvalues / sum(eigenvalues);

% Step 7: Compute cumulative proportion of variance explained
cumulative_variance_explained = cumsum(variance_explained);

elapsed_time = toc;
disp(['Elapsed Time: ' num2str(elapsed_time) ' seconds']);

% Step 8: Plot the scree plot
figure
plot(1:numel(eigenvalues), variance_explained, 'bo-')
hold on
plot(1:numel(eigenvalues), cumulative_variance_explained, 'ro-')
xlabel('Principal Component')
ylabel('Proportion of Variance Explained')
title('Scree Plot')
legend('Variance Explained', 'Cumulative Variance Explained')
grid on

%% PCA with Gram matrix
tic;
% Step 1: Compute the center of the points
mu2 = mean(data1_matrix);

% Step 2: Compute the centered points
data_centered2 = data1_matrix - mu2;

% Step 3: Compute the Gram matrix
G = data_centered2' * data_centered2;

% Step 4: Compute eigenvalues and eigenvectors of the Gram matrix
[V2, D2] = eig(G);

% Sort the eigenvalues in descending order and get the indices
[eigValues2, order] = sort(diag(D2), 'descend');

% Sort the eigenvectors based on the order of eigenvalues
eigVectors2 = V2(:, order);

% Step 5: Compute the basis vectors of the affine spaces
basis_vectors = eigVectors2 * data_centered2';
basis_vectors = basis_vectors ./ vecnorm(basis_vectors);

% Display the basis vectors
disp('Basis vectors:')
disp(basis_vectors)

elapsed_time = toc;
disp(['Elapsed Time: ' num2str(elapsed_time) ' seconds']);

%% Comparison of PCA with MATLAB's built-in pca function 
tic
[coeff,score,latent,~,explained] = pca(data1_matrix);

% Display the eigenvalues and eigenvectors
disp('Eigenvalues:')
disp(latent)
disp('Eigenvectors:')
disp(coeff);

elapsed_time = toc;
disp(['Elapsed Time: ' num2str(elapsed_time) ' seconds']);

%% Get storage data
whos;
