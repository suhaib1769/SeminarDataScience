run("task3.m")
% Compute t-SNE embeddings
coordinates = tsne(data);

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