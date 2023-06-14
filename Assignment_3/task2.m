data = readtable('AirQualityUCI.csv', VariableNamingRule='preserve');
data = data(:,3:end);
data_matrix = table2array(data);

%%
% PCA with Gram matrix
% Snapshot PCA: Random selection of datapoints
% fraction of data points to keep
fraction = 0.5;

% total number of data points
n = size(data_matrix, 1);

% number of data points to keep
num_samples = round(n * fraction);

% randomize data points and get first num_samples
indices = randperm(n, num_samples);

% keep only selected data points
data_matrix = data_matrix(indices, :);

% Step 1: Compute the center of the points
mu2 = mean(data_matrix);

% Step 2: Compute the centered points
data_centered2 = data_matrix - mu2;
tic;

% Step 3: Compute the Gram matrix
G = data_centered2 * data_centered2';

% Step 4: Compute eigenvalues and eigenvectors of the Gram matrix
[V, D] = eig(G);

% Sort the eigenvalues in descending order and get the indices
[eigValues, order] = sort(diag(D), 'descend');

% Sort the eigenvectors based on the order of eigenvalues
eigVectors = V(:, order);

% Step 5: Compute the basis vectors of the affine spaces
basis_vectors = data_centered2' * eigVectors;
basis_vectors = basis_vectors ./ vecnorm(basis_vectors);

% Step 6: Project the original data onto the PCA space
data_pca = data_centered2 * basis_vectors;

% After transformed data is created:
info = whos('data_pca');
transformed_data_size_my = info.bytes;
elapsed_time = toc;
disp(['Elapsed Time: ' num2str(elapsed_time) ' seconds']);

% Display the basis vectors
disp('Basis vectors:')
% disp(basis_vectors)

%% Comparison of PCA with MATLAB's built-in pca function 
tic
data_matrix = table2array(data);

[coeff,score,latent,~,explained] = pca(data_matrix);

elapsed_time = toc;
disp(['Elapsed Time: ' num2str(elapsed_time) ' seconds']);
% Display the eigenvalues and eigenvectors
disp('Eigenvalues:')
% disp(latent)
% disp('Eigenvectors:')
% disp(coeff);
% After transformed data is created:
info = whos('score');
transformed_data_size_matlab = info.bytes;

%% Get storage data

disp(['Transformed data: My method = ' num2str(transformed_data_size_my) ', MATLAB = ' num2str(transformed_data_size_matlab)])

% whos;
