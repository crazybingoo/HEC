function [AUC, bestThresh, sensitivity, specificity, precision, accuracy] = ...
    evaluate_HEC_ROC(DataL, DataR)
% EVALUATE_HEC_ROC  Compute ROC curve and classification metrics for HEC values.
%
%   [AUC, bestThresh, sensitivity, specificity, precision, accuracy] = ...
%       evaluate_HEC_ROC(DataL, DataR)
%
%   INPUT
%       DataL  - Matrix of HEC values for EZs (e.g., 10 x 10).
%       DataR  - Matrix of HEC values for NEZs (e.g., 10 x 10).
%
%   OUTPUT
%       AUC         - Area under the ROC curve.
%       bestThresh  - Optimal decision threshold (maximizing Youden index).
%       sensitivity - True positive rate (TPR) at bestThresh.
%       specificity - True negative rate (TNR) at bestThresh.
%       precision   - Positive predictive value (PPV) at bestThresh.
%       accuracy    - Overall classification accuracy at bestThresh.
%
%   DESCRIPTION
%       This function:
%         1) Flattens HEC matrices for EZs (label = 1) and NEZs (label = 0);
%         2) Constructs score and label vectors for binary classification;
%         3) Uses perfcurve (Statistics and Machine Learning Toolbox) to
%            compute the ROC curve and AUC;
%         4) Finds the optimal threshold based on the maximum Youden index;
%         5) Computes sensitivity, specificity, precision, and accuracy at
%            the optimal threshold;
%         6) Plots the ROC curve.
%
%   REQUIREMENTS
%       - MATLAB Statistics and Machine Learning Toolbox (for perfcurve).
%
%   EXAMPLE
%       % DataL: HEC values for EZ contacts (e.g., 10x10)
%       % DataR: HEC values for NEZ contacts (e.g., 10x10)
%       [AUC, bestThresh, sens, spec, prec, acc] = evaluate_HEC_ROC(DataL, DataR);

    %% 1. Flatten data (EZ vs NEZ)

    % DataL: HEC values for EZs
    % DataR: HEC values for NEZs
    hec_ez  = DataL(:);   % column vector, label = 1
    hec_nez = DataR(:);   % column vector, label = 0

    % If NaNs may exist (missing channels), remove them
    mask_ez  = ~isnan(hec_ez);
    mask_nez = ~isnan(hec_nez);

    hec_ez  = hec_ez(mask_ez);
    hec_nez = hec_nez(mask_nez);

    %% 2. Construct score and label vectors

    scores = [hec_ez; hec_nez];          % continuous scores: HEC values
    labels = [ones(size(hec_ez)); ...    % label = 1 for EZ
              zeros(size(hec_nez))];     % label = 0 for NEZ

    %% 3. Compute ROC curve and AUC

    % Requires Statistics and Machine Learning Toolbox
    [fpRate, tpRate, thresholds, AUC] = perfcurve(labels, scores, 1);

    fprintf('AUC = %.3f\n', AUC);

    %% 4. Find optimal threshold using maximum Youden index

    youden = tpRate - fpRate;
    [~, bestIdx] = max(youden);

    bestThresh = thresholds(bestIdx);
    bestTPR    = tpRate(bestIdx);   % sensitivity
    bestFPR    = fpRate(bestIdx);   % 1 - specificity

    sensitivity = bestTPR;
    specificity = 1 - bestFPR;

    fprintf('Best threshold = %.4f\n', bestThresh);
    fprintf('Sensitivity = %.3f, Specificity = %.3f\n', sensitivity, specificity);

    %% 5. Compute classification metrics at the optimal threshold

    % Predicted label: HEC >= threshold -> EZ (1)
    pred = scores >= bestThresh;

    TP = sum(pred == 1 & labels == 1);
    FP = sum(pred == 1 & labels == 0);
    TN = sum(pred == 0 & labels == 0);
    FN = sum(pred == 0 & labels == 1);

    sensitivity = TP / (TP + FN);          % true positive rate (TPR)
    specificity = TN / (TN + FP);          % true negative rate (TNR)
    precision   = TP / (TP + FP);          % positive predictive value (PPV)
    accuracy    = (TP + TN) / numel(labels);

    fprintf('At best threshold:\n');
    fprintf('  Sensitivity = %.3f\n', sensitivity);
    fprintf('  Specificity = %.3f\n', specificity);
    fprintf('  Precision   = %.3f\n', precision);
    fprintf('  Accuracy    = %.3f\n', accuracy);

    %% 6. Plot ROC curve

    figure;
    plot(fpRate, tpRate, 'LineWidth', 2); hold on;
    plot([0 1], [0 1], '--');  % diagonal line for reference
    xlabel('False positive rate');
    ylabel('True positive rate');
    title(sprintf('ROC curve for HEC (AUC = %.3f)', AUC));
    grid off;
    set(gca, 'FontSize', 15);
    set(gca, 'FontName', 'Times New Roman');

end
