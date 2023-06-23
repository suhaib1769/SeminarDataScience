%% Load data
% Specify the directory where the images are stored
imgDir = 'ImageData'; % Replace with your path

% Get a list of all jpg files in the image directory
imgFiles = dir(fullfile(imgDir, '*.jpg'));

% Preallocate a matrix to hold all of the image data
numImages = length(imgFiles);
imgSize = size(imread(fullfile(imgDir, imgFiles(1).name)));
X = zeros(prod(imgSize), numImages);

% Loop over the images and store them in the matrix
for i = 1:numImages
    img = imread(fullfile(imgDir, imgFiles(i).name));
    X(:, i) = img(:);
end

X= X';

%% Snapshot PCA: Random selection of datapoints
fraction = 0.5;
tic;

data_matrix = X;

% Randomize data points
n = size(data_matrix, 1);
num_samples = round(n * fraction);
indices = randperm(n, num_samples);

% Keep only selected data points
data_matrix_snapshot = data_matrix(indices, :);
% data_matrix_snapshot = data_matrix;

% Compute PCA
mu2 = mean(data_matrix_snapshot);
data_centered2 = data_matrix_snapshot - mu2;
% Step 3: Compute the Gram matrix
G = data_centered2 * data_centered2';
% G = 1/m*G;

% Step 4: Compute eigenvalues and eigenvectors of the Gram matrix
[V2, D2] = eig(G);

% disp('Gram')
% disp('Eigenvalues:')
% disp(diag(D2))
% disp('Eigenvectors:')
% disp(V2);

[d2,ind2] = sort(diag(D2),'descend'); % sort eigenvalues in descending order
V2 = V2(:,ind2); % reorder columns of V2 (eigenvectors) accordingly
% Extract eigenvalues from matrix D
eigenvalues = diag(V2);

% Calculate proportion of variance explained
variance_explained = eigenvalues / sum(eigenvalues);

% Compute cumulative proportion of variance explained
cumulative_variance_explained = cumsum(variance_explained);

% Step 5: Compute the basis vectors of the affine spaces
basis_vectors = V2 * data_centered2;
basis_vectors = basis_vectors ./ vecnorm(basis_vectors);

i = 13; 
V2_i = basis_vectors(:, 1:i); % take the first i basis vectors

% Project the centered data onto the new space
data_projected2 = data_centered2' * V2_i; % transpose data_centered2 to match dimensions
elapsed_time = toc;

%% MATLAB built-in PCA
tic;
[coeff, score, ~, tsquared, explained] = pca(X);
time_matlab = toc;

%% Nystrom method
% Define the data

tic;
mu = mean(X);

% Center the data
X_centered = X - mu;

% Randomize data points
fraction = 0.001;
n = size(X_centered, 2);
l = round(n * fraction);
% indices = randperm(n, l);
% indices = sort(indices);

% Keep only selected data points
S = 1:l;

% Compute the columns of the Covariance matrix
[n, m] = size(X_centered);
C1 = X_centered(:, S);
C_hat = (1/(n-1))*(X_centered'*C1);

% Partition the computed columns into a square l x l matrix A and a (n - l) x l matrix B
A = C_hat(1:l, 1:l);
B = C_hat(l+1:end, :);

% Compute the eigenvalues and eigenvectors of A
[U_A, Lambda_A] = eig(A);

% Extract eigenvalues from matrix D
eigenvalues = diag(Lambda_A);


% Ensure the eigenvalues and corresponding eigenvectors are ordered by descending eigenvalue
[Lambda_A, sortIdx] = sort(diag(Lambda_A), 'descend');
U_A = U_A(:, sortIdx);

dia_lambda = diag(Lambda_A);
% Compute the approximate PCA modes
U_hat = [U_A; B * U_A / dia_lambda];


% Calculate proportion of variance explained
variance_explained = eigenvalues / sum(eigenvalues);

% Compute cumulative proportion of variance explained
cumulative_variance_explained = cumsum(variance_explained);
time_nystrom = toc;

% % Plot the scree plot
% figure
% plot(1:numel(eigenvalues), variance_explained, 'bo-')
% hold on
% plot(1:numel(eigenvalues), cumulative_variance_explained, 'ro-')
% xlabel('Principal Component')
% ylabel('Proportion of Variance Explained')
% title('Scree Plot - PCA with covariance matrix')
% legend('Variance Explained', 'Cumulative Variance Explained')
% grid on

%% Compare results

k = 9;
% Compute and compare reconstruction errors
reconstructed_matlab_k = score(:, 1:k) * coeff(:, 1:k)' + mu;
% Project the data onto the PCA modes
projected_X_k = X * U_hat(:, 1:k);
% Reconstruct the data from the projected data
reconstructed_nystrom_k = projected_X_k * U_hat(:, 1:k)';
error_matlab = sum(sum((X - reconstructed_matlab_k).^2));
error_nystrom = sum(sum((X - reconstructed_nystrom_k).^2));

% Visualize the first reconstructed image
first_reconstructed_img = reconstructed_nystrom_k(3, :);

% Reshape the image data back to its original size
first_reconstructed_img = reshape(first_reconstructed_img, imgSize);

% Display the image
imshow(first_reconstructed_img);

% Visualize the first reconstructed image
sec_reconstructed_img = reconstructed_nystrom_k(5, :);

% Reshape the image data back to its original size
sec_reconstructed_img = reshape(sec_reconstructed_img, imgSize);

% Display the image
imshow(sec_reconstructed_img);

% Extract the diagonal elements, which are the eigenvalues
lambda_values = diag(dia_lambda);

% Compute the cumulative sum of the eigenvalues
cumulative_lambda = cumsum(lambda_values);

% Compute the total sum of the eigenvalues
total_lambda = sum(lambda_values);

% Compute the explained variance
explained_nystrom = lambda_values / total_lambda * 100; % Convert to percentage

% Compare computation times
fprintf('Computation time (MATLAB PCA): %f seconds\n', time_matlab);
fprintf('Computation time (Nystrom method): %f seconds\n', time_nystrom);
fprintf('Computation time (Snapshot PCA): %f seconds\n', elapsed_time);

% Compare reconstruction errors
fprintf('Reconstruction error (MATLAB PCA): %f\n', error_matlab);
fprintf('Reconstruction error (Nystrom method): %f\n', error_nystrom);
% fprintf('Reconstruction error (Snapshot PCA): %f\n', reconstruction_error);

% Compare explained variance for the first few components
fprintf('Explained variance (MATLAB PCA): %s\n', num2str(explained(1:9)'));
fprintf('Explained variance (Nystrom method): %s\n', num2str(explained_nystrom(1:l)'));
% fprintf('Explained variance (Snapshot PCA): %s\n', num2str(explained_variance_snapshot(1:1)'));
whos('G', 'data_matrix', 'score', 'coeff', 'X_centered', 'C1', 'C_hat', 'A', 'B', 'U_A', 'U_hat')
