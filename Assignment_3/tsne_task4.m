run("load_anage_similarity_matrix.m")
run("create_G.m")
% Compute t-SNE embeddings
embeddings = tsne(data);

% Plot the embeddings on a 2D plot
plot(embeddings(1:15:end, 1), embeddings(1:15:end, 2), 'o');
xlabel('Dimension 1');
ylabel('Dimension 2');
title('2D Representation of Data Points');

% Add country names as text annotations
text(embeddings(1:15:end, 1), embeddings(1:15:end, 2), countries(1:15:end), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');

% Extract the desired submatrices
embeddings_submatrix = embeddings(1:10, 1:2);
coordinates_submatrix = coordinates(1:10, 1:2);

% Concatenate submatrices horizontally
combined_matrix = [embeddings_submatrix, coordinates_submatrix];

% Display the combined matrix
disp(combined_matrix);