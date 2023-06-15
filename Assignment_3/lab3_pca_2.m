% get dataset 
data1 = readtable('data.csv', VariableNamingRule='preserve');
data1(:,end) = [];
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
% normalization_factor = n - 1; % For unbiased estimate
% C = (data_centered' * data_centered) ./ normalization_factor;
C = (1/m)*(data_centered*data_centered');
% C = cov(data_centered);

% Step 4: Compute eigenvalues and eigenvectors of the covariance matrix
[V, D] = eig(C);

% Display the eigenvalues and eigenvectors
% disp('Covariance')
% disp('Eigenvalues:')
% disp(diag(D))
% disp('Eigenvectors:')
% disp(V);

elapsed_time = toc;
disp(['Elapsed Time: ' num2str(elapsed_time) ' seconds']);

% Extract eigenvalues from matrix D
eigenvalues = diag(D);

% Calculate proportion of variance explained
variance_explained = eigenvalues / sum(eigenvalues);

% Compute cumulative proportion of variance explained
cumulative_variance_explained = cumsum(variance_explained);

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

[d,ind] = sort(diag(D),'descend'); % sort eigenvalues in descending order
V = V(:,ind); % reorder columns of V (eigenvectors) accordingly

i = 5; % adjust this value to the desired number of dimensions
V_i = V(:, 1:i); % take the first i eigenvectors

% Project the centered data onto the new space
data_projected = data_centered'*V_i ; % transpose data_centered to match dimensions

figure
scatter(data_projected(:, 1), data_projected(:, 2), 'b', 'filled')
xlabel('Principal Component 1')
ylabel('Principal Component 2')
title('Projected Data Visualization')
grid on

%% PCA with Gram matrix
tic;
% Step 1: Compute the center of the points
mu2 = mean(data1_matrix);

% Step 2: Compute the centered points
data_centered2 = data1_matrix - mu2;
[n, m] = size(data_centered2); % n = number of observations, m = number of variables

% Step 3: Compute the Gram matrix
G = data_centered2' * data_centered2;
% Step 4: Compute eigenvalues and eigenvectors of the Gram matrix
[V2, D2] = eig(G);

% disp('Gram')
disp('Eigenvalues:')
disp(diag(D2))
% disp('Eigenvectors:')
% disp(V2);

elapsed_time = toc;
disp(['Elapsed Time: ' num2str(elapsed_time) ' seconds']);

% Extract eigenvalues from matrix D
eigenvalues = diag(D2);

% Calculate proportion of variance explained
variance_explained = eigenvalues / sum(eigenvalues);

% Compute cumulative proportion of variance explained
cumulative_variance_explained = cumsum(variance_explained);

% Plot the scree plot
figure
plot(1:numel(eigenvalues), variance_explained, 'bo-')
hold on
plot(1:numel(eigenvalues), cumulative_variance_explained, 'ro-')
xlabel('Principal Component')
ylabel('Proportion of Variance Explained')
title('Scree Plot - PCA with Gram matrix')
legend('Variance Explained', 'Cumulative Variance Explained')
grid on

% Step 5: Compute the basis vectors of the affine spaces
basis_vectors = data_centered2* V2;
basis_vectors = basis_vectors ./ vecnorm(basis_vectors);


[d2,ind2] = sort(diag(D2),'descend'); % sort eigenvalues in descending order
V2 = V2(:,ind2); % reorder columns of V2 (eigenvectors) accordingly

i = 5; % adjust this value to the desired number of dimensions
V2_i = basis_vectors(:, 1:i); % take the first i basis vectors

% Project the centered data onto the new space
data_projected2 = V2_i' * data_centered2; % transpose data_centered2 to match dimensions


%% Comparison of PCA with MATLAB's built-in pca function 
tic
% [coeff,score,latent,~,explained] = pca(data1_matrix);
[coeff,score,latent,~,explained] = pca(data1_matrix);

% sort in ascending order
[latent, order] = sort(latent, 'ascend'); % sort eigenvalues
coeff = coeff(:,order); % rearrange eigenvectors
explained = explained(order); % rearrange explained variance
score = score(:,order); % rearrange scores

elapsed_time = toc;
disp(['Elapsed Time: ' num2str(elapsed_time) ' seconds']);

% Step 6: Extract eigenvalues from matrix D
eigenvalues = (latent);

% Step 7: Calculate proportion of variance explained
variance_explained = eigenvalues / sum(eigenvalues);

% Step 8: Compute cumulative proportion of variance explained
cumulative_variance_explained = cumsum(variance_explained);

% Step 9: Plot the scree plot
figure
plot(1:numel(eigenvalues), variance_explained, 'bo-')
hold on
plot(1:numel(eigenvalues), cumulative_variance_explained, 'ro-')
xlabel('Principal Component')
ylabel('Proportion of Variance Explained')
title('Scree Plot - in built PCA')
legend('Variance Explained', 'Cumulative Variance Explained')
grid on

i = 5; % adjust this value to the desired number of dimensions
coeff_i = coeff(:, 1:i); % take the first i principal components

% Project the original data onto the new space
data_centered3 = data1_matrix - mean(data1_matrix); % center the original data
data_projected3 = coeff_i' * data_centered3'; % transpose data_centered3 to match dimensions

% Display the eigenvalues (or explained variances) for each method
disp('Eigenvalues for method 1:')
disp(diag(D))
disp('Eigenvalues for method 2:')
disp(diag(D2))
disp('Eigenvalues for method 3:')
disp(latent)

%% Get storage data
whos;