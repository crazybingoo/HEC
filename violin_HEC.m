function violin_HEC(DataL, DataR, Name, ClassName, Condition)
% VIOLIN_HEC  Draw violin plots for HEC across patients (EZ vs NEZ).
%
%   violin_HEC(DataL, DataR, Name, ClassName, Condition)
%
%   INPUT
%       DataL     - #patients x #stages matrix for EZs.
%       DataR     - #patients x #stages matrix for NEZs.
%       Name      - cell array of patient labels, e.g. {'P1','P2',...}.
%       ClassName - {'EZs','NEZs'}.
%       Condition - cell array of significance labels for each patient.

    figure;
    ax = gca;

    c1 = colorplus(317);
    c2 = colorplus(36);
    CList = [1   0.388235294117647   0.278431372549020;
             0.545098039215686       0.537254901960784   0.537254901960784];

    width = 1.5;

    ax.NextPlot  = 'add';
    ax.Box       = 'off';
    ax.XGrid     = 'on';
    ax.YGrid     = 'on';
    ax.XTick     = 1:length(Name);
    ax.XTickLabel= Name;
    ax.FontName  = 'Times New Roman';
    ax.FontSize  = 15;
    ax.XLim      = [0, length(Name)] + 0.5;
    ax.YLabel.String   = 'HEC';
    ax.YLabel.FontName = 'Times New Roman';
    ax.YLabel.FontSize = 18;

    for i = 1:length(Name)
        [fL, yiL] = ksdensity(DataL(:, i));
        [fR, yiR] = ksdensity(DataR(:, i));

        fill(ax, (i - fL .* width), yiL, CList(1,:), 'EdgeColor', 'none', 'FaceAlpha', 0.5);
        fill(ax, (i + fR .* width), yiR, CList(2,:), 'EdgeColor', 'none', 'FaceAlpha', 0.5);

        qt25L = quantile(DataL(:, i), 0.25);
        qt75L = quantile(DataL(:, i), 0.75);
        plot(ax, [-1, 1, nan, -1, 1, nan, 0, 0].*0.05 + i - 0.08, ...
            [qt75L, qt75L, nan, qt25L, qt25L, nan, qt75L, qt25L], ...
            'LineWidth', 1, 'Color', 'k');

        qt25R = quantile(DataR(:, i), 0.25);
        qt75R = quantile(DataR(:, i), 0.75);
        plot(ax, [-1, 1, nan, -1, 1, nan, 0, 0].*0.05 + i + 0.08, ...
            [qt75R, qt75R, nan, qt25R, qt25R, nan, qt75R, qt25R], ...
            'LineWidth', 1, 'Color', 'k');

        medL = median(DataL(:, i));
        scatter(i - 0.08, medL, 20, 'filled', 'CData', [0,0,0]);
        medR = median(DataR(:, i));
        scatter(i + 0.08, medR, 20, 'filled', 'CData', [0,0,0]);

        text(ax, i, max([yiL(:); yiR(:)]), Condition{i}, ...
            'FontSize', 16, 'FontName', 'Times New Roman', ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'baseline');
    end

    fillHdl(1) = fill(ax, [-1,-2,-1], [0,0,1], CList(1,:), 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    fillHdl(2) = fill(ax, [-1,-2,-1], [0,0,1], CList(2,:), 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    lgdHdl = legend(fillHdl, ClassName, 'Location', 'best', 'Box','off');
    lgdHdl.ItemTokenSize = [20, 20];
end
