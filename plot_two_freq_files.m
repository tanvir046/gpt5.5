% plot_two_freq_files.m
% Load two frequency time-series files (same format) and plot together.

clear; clc;

% Update these as needed.
dataFolder = 'C:\Users\e0891832\OneDrive - Eaton\CICERO_TAS';
file1 = 'freq_load1shed.txt';
file2 = 'freq_load2shed.txt';

label1 = 'Load 1 Shed';
label2 = 'Load 2 Shed';

path1 = fullfile(dataFolder, file1);
path2 = fullfile(dataFolder, file2);

[t1, y1] = loadFreqSeries(path1);
[t2, y2] = loadFreqSeries(path2);

figure('Color', 'w');
plot(t1, y1, 'b-', 'LineWidth', 1.6); hold on;
plot(t2, y2, 'r--', 'LineWidth', 1.6);
grid on;

xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Frequency Comparison: Two Cases');
legend(label1, label2, 'Location', 'best');

fprintf('Loaded %d samples from %s\n', numel(y1), path1);
fprintf('Loaded %d samples from %s\n', numel(y2), path2);

function [t, y] = loadFreqSeries(filename)
    if ~isfile(filename)
        error('File not found: %s', filename);
    end

    opts = detectImportOptions(filename, 'Delimiter', ',');
    opts.VariableNamingRule = 'preserve';
    raw = readmatrix(filename, opts);

    if isempty(raw)
        error('No numeric data found in %s', filename);
    end

    % Drop rows that are all NaN (for header or empty rows).
    raw = raw(~all(isnan(raw), 2), :);

    if isempty(raw)
        error('No valid numeric rows found in %s', filename);
    end

    if size(raw, 2) < 2
        error('Expected at least 2 columns (time, frequency) in %s', filename);
    end

    t = raw(:, 1);
    y = raw(:, 2);

    valid = ~(isnan(t) | isnan(y));
    t = t(valid);
    y = y(valid);

    if isempty(t)
        error('No valid time/frequency pairs in %s', filename);
    end
end
