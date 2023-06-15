% get dataset 
data1 = readtable('google_review_ratings.csv', VariableNamingRule='preserve');
data1(:,end) = [];
data1(:,1) = [];
data1_matrix = table2array(data1);
disp(size(data1_matrix));

%% Snapshot PCA: Random selection of datapoints
fraction = 0.5;
tic;

% Randomize data points
n = size(data_matrix, 1);
num_samples = round(n * fraction);
indices = randperm(n, num_samples);

% Keep only selected data points
data_matrix_snapshot = data_matrix(indices, :);

% Compute PCA
mu2 = mean(data_matrix_snapshot);
data_centered2 = data_matrix_snapshot - mu2;
G = data_centered2' * data_centered2;
[V, D] = eig(G);
[eigValues, order] = sort(diag(D), 'descend');
eigVectors = V(:, order);
basis_vectors = eigVectors* data_centered2';
basis_vectors = basis_vectors ./ vecnorm(basis_vectors);
data_pca_snapshot = data_centered2 * basis_vectors;

% Compute metrics for Snapshot PCA
elapsed_time_snapshot = toc;
reconstructed_data = data_pca_snapshot * basis_vectors';
reconstruction_error_snapshot = norm(data_centered2 - reconstructed_data, 'fro') / norm(data_centered2, 'fro');
total_variance_snapshot = sum(var(data_centered2));
explained_variance_snapshot = sum(eigValues(1:2)) / total_variance_snapshot;

%% Nyström method
fraction = 0.5;
tic;

% Randomize data points
n = size(data_matrix, 2);
num_landmarks = round(n * fraction);
indices = randperm(n, num_landmarks);

% Keep only selected data points
data_subset = data_centered2(:, indices);
normalization_factor = num_landmarks - 1;
C = (data_subset' * data_subset) ./ normalization_factor;
[V2, D2] = eig(C);
[eigValues_landmarks, order] = sort(diag(D2), 'descend');
eigVectors_landmarks = V2(:, order);
data_pca_landmarks = data_centered2(:, indices) * eigVectors_landmarks;

% Compute metrics for Nyström method
elapsed_time_nystrom = toc;
reconstructed_data_landmarks = data_pca_landmarks;
reconstruction_error_landmarks = norm(data_centered2(:, indices) - reconstructed_data_landmarks, 'fro') / norm(data_centered2(:, indices), 'fro');
total_variance_landmarks = sum(var(data_centered2(:, indices)));
explained_variance_landmarks = sum(eigValues_landmarks(1:2)) / total_variance_landmarks;

%% MATLAB built-in PCA
tic;
[coeff, score, latent] = pca(data_matrix);
elapsed_time_matlab = toc;

%% Comparison
disp('====== Time Comparison ======');
disp(['Time taken by MATLAB PCA: ', num2str(elapsed_time_matlab)]);
disp(['Time taken by Snapshot PCA: ', num2str(elapsed_time_snapshot)]);
disp(['Time taken by Nyström method: ', num2str(elapsed_time_nystrom)]);

% Memory of eigenvectors
info_matlab_coeff = whos('coeff');
info_snapshot_eigVectors = whos('eigVectors');
info_nystrom_eigVectors_landmarks = whos('eigVectors_landmarks');
disp(['Memory of eigenvectors (MATLAB PCA): ', num2str(info_matlab_coeff.bytes)]);
disp(['Memory of eigenvectors (Snapshot PCA): ', num2str(info_snapshot_eigVectors.bytes)]);
disp(['Memory of eigenvectors (Nyström method): ', num2str(info_nystrom_eigVectors_landmarks.bytes)]);

% Memory of eigenvalues
info_matlab_latent = whos('latent');
info_snapshot_eigValues = whos('eigValues');
info_nystrom_eigValues_landmarks = whos('eigValues_landmarks');
disp(['Memory of eigenvalues (MATLAB PCA): ', num2str(info_matlab_latent.bytes)]);
disp(['Memory of eigenvalues (Snapshot PCA): ', num2str(info_snapshot_eigValues.bytes)]);
disp(['Memory of eigenvalues (Nyström method): ', num2str(info_nystrom_eigValues_landmarks.bytes)]);

% Memory of covariance or Gram matrix
info_snapshot_G = whos('G');
info_nystrom_C = whos('C');
disp(['Memory of Gram matrix (Snapshot PCA): ', num2str(info_snapshot_G.bytes)]);
disp(['Memory of Covariance matrix (Nyström method): ', num2str(info_nystrom_C.bytes)]);


% Reconstruction Error and Explained Variance
disp('====== Reconstruction Error Comparison ======');
disp(['Reconstruction error (MATLAB PCA): ', 'Not computed in this script']); % Update if computed
disp(['Reconstruction error (Snapshot PCA): ', num2str(reconstruction_error_snapshot)]);
disp(['Reconstruction error (Nyström method): ', num2str(reconstruction_error_landmarks)]);

disp('====== Variance Explained Comparison ======');
disp(['Variance explained (MATLAB PCA): ', 'Not computed in this script']); % Update if computed
disp(['Variance explained (Snapshot PCA): ', num2str(explained_variance_snapshot)]);
disp(['Variance explained (Nyström method): ', num2str(explained_variance_landmarks)]);
