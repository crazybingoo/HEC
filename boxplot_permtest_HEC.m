function p_value = boxplot_permtest_HEC(DataL, DataR)
% BOXPLOT_PERMTEST_HEC  Draw boxplot for EZ vs NEZ and perform permutation test.
%
%   p_value = boxplot_permtest_HEC(DataL, DataR)
%
%   INPUT
%       DataL - matrix (#patients x #stages or #features) for EZs.
%       DataR - matrix (#patients x #stages or #features) for NEZs.
%
%   OUTPUT
%       p_value - permutation test p-value (based on mean difference).

    data1 = mean(DataL, 2);   % mean HEC of EZs across stages
    data2 = mean(DataR, 2);   % mean HEC of NEZs across stages
    X = [data1, data2];

    c2 = colorplus(317);
    c1 = colorplus(36);
    mycolor2 = [c1; c2];

    figure;
    box_figure = boxplot(X, 'color', [0 0 0], 'Symbol', 'o', 'Labels', {'EZs', 'NEZs'});
    set(box_figure, 'LineWidth', 1.2);

    boxobj = findobj(gca, 'Tag', 'Box');
    for i = 1:2
        patch(get(boxobj(i), 'XData'), get(boxobj(i), 'YData'), mycolor2(i,:), ...
              'FaceAlpha', 0.5, 'LineWidth', 1.1);
    end

    hold on;
    jitterAmount = 0.08;

    scatter(ones(size(data1)) + (rand(size(data1))-0.5)*jitterAmount, data1, ...
        30, 'filled', 'MarkerFaceColor', mycolor2(2,:));

    scatter(2*ones(size(data2)) + (rand(size(data2))-0.5)*jitterAmount, data2, ...
        30, 'filled', 'MarkerFaceColor', mycolor2(1,:));
    hold off;

    hold on;
    data_diff = data1 - data2;
    observed_mean = mean(data_diff);

    num_permutations = 10000;
    permuted_means = zeros(num_permutations, 1);
    for i = 1:num_permutations
        signs = randi([0,1], size(data_diff)) * 2 - 1;
        permuted_means(i) = mean(signs .* data_diff);
    end

    p_value = mean(abs(permuted_means) >= abs(observed_mean));

    % significance bar
    y_max = max([max(data1), max(data2)]);
    line_height = y_max + 0.2 * range([min(data1), y_max]);
    x_pos = [1, 2];
    plot(x_pos, [line_height, line_height], '-k', 'LineWidth', 0.5);

    hold on;
    vlen = 0.05 * (y_max - 0.2);
    plot([x_pos(1), x_pos(1)], [line_height, line_height - vlen], '-k', 'LineWidth', 0.5);
    plot([x_pos(2), x_pos(2)], [line_height, line_height - vlen], '-k', 'LineWidth', 0.5);
    hold off;

    if p_value < 0.0001
        text(mean(x_pos), line_height + 0.4, sprintf('**** p=%.2e', p_value), ...
            'HorizontalAlignment', 'center', 'FontSize', 15);
    elseif p_value < 0.001
        text(mean(x_pos), line_height + 0.02, '***', 'HorizontalAlignment', 'center', 'FontSize', 12);
    elseif p_value < 0.01
        text(mean(x_pos), line_height + 0.02, '**', 'HorizontalAlignment', 'center', 'FontSize', 12);
    elseif p_value < 0.05
        text(mean(x_pos), line_height + 0.02, '*', 'HorizontalAlignment', 'center', 'FontSize', 12);
    else
        text(mean(x_pos), line_height + 0.02, 'ns', 'HorizontalAlignment', 'center', 'FontSize', 12);
    end

    set(gca, 'FontSize', 15);
    set(gca, 'FontName', 'Times New Roman');
end
