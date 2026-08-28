% plot_freq_load1shed.m
% Reads and plots freq_load1shed.txt from the provided folder.

clear; clc;

dataFolder = 'C:\Users\e0891832\OneDrive - Eaton\CICERO_TAS';
filename = fullfile(dataFolder, 'freq_load1shed.txt');

if ~isfile(filename)
    error('File not found: %s\nPlace it in the current folder or update filename.', filename);
end

opts = detectImportOptions(filename, 'Delimiter', ',');
opts.VariableNamingRule = 'preserve';
raw = readmatrix(filename, opts);

if isempty(raw)
    error('No numeric data found in %s.', filename);
end

% Remove rows that are entirely NaN (common when headers exist).
raw = raw(~all(isnan(raw), 2), :);

if isempty(raw)
    error('No valid numeric rows found in %s.', filename);
end

% If only one column exists, use sample index for x-axis.
if size(raw, 2) == 1
    y = raw(:, 1);
    t = (0:numel(y)-1).';
    xLabelText = 'Sample Index';
else
    % Use first column as time and second as data.
    t = raw(:, 1);
    y = raw(:, 2);
    xLabelText = 'Time (s)';
end

% Remove NaN points before plotting.
valid = ~(isnan(t) | isnan(y));
t = t(valid);
y = y(valid);

figure('Color', 'w');
plot(t, y, 'b-', 'LineWidth', 1.5);
grid on;
xlabel(xLabelText);
ylabel('Frequency (Hz)');
title('freq\_load1shed Time Series');

fprintf('Loaded %d samples from %s\n', numel(y), filename);
