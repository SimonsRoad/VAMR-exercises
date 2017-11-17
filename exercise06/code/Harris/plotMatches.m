function plotMatches(matches, query_keypoints, database_keypoints, query_image, figure_number)

if exist('figure_number','var') && exist('query_image','var')
    figure(figure_number); clf;
        imshow(query_image);
        hold on;
        plot(query_keypoints(2,:), query_keypoints(1,:), 'rx', 'Linewidth', 2);
        title('query image');
end

[~, query_indices, match_indices] = find(matches);

x_from = query_keypoints(1, query_indices);
x_to = database_keypoints(1, match_indices);
y_from = query_keypoints(2, query_indices);
y_to = database_keypoints(2, match_indices);
plot([y_from; y_to], [x_from; x_to], 'g-', 'Linewidth', 3);

end

