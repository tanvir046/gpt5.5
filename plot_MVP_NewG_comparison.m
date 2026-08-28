%% =========================================================================
%  plot_MVP_NewG_comparison.m
%  Compares "No Load Shedding" vs "Load 1 Shedding" scenarios from
%  MVP_NewG simulation data.
%
%  FIGURE 1 (4x1): P_Gen1 | Q_Gen1 | freq1 | freq2
%  FIGURE 2 (4x1): freqPCC | VPCC   | PPCC  | QPCC
%
%  USAGE:
%   Option A (preferred) - multi-sheet Excel file:
%     Rename / resave MVP_NewG.csv as MVP_NewG.xlsx with two sheets:
%       Sheet 1 -> "No Load Shedding"
%       Sheet 2 -> "Load 1 Shedding"
%
%   Option B - two separate CSV files (edit paths below and uncomment
%     the "Option B" block, then comment out the "Option A" block).
% =========================================================================
clear; clc; close all;

%% -----------------------------------------------------------------------
%  PATHS  --  edit these
%% -----------------------------------------------------------------------
data_dir  = 'C:\Users\e0891832\OneDrive - Eaton\CICERO_TAS\CICERO_DATA_ANALYSIS\NewG\';

% --- Option A: multi-sheet XLSX -----------------------------------------
xlsx_file      = fullfile(data_dir, 'MVP_NewG.xlsx');
sheet_noLoad   = 'No Load Shedding';
sheet_load1    = 'Load 1 Shedding';

T_nl = readtable(xlsx_file, 'Sheet', sheet_noLoad,  'VariableNamingRule', 'preserve');
T_l1 = readtable(xlsx_file, 'Sheet', sheet_load1,   'VariableNamingRule', 'preserve');

% --- Option B: two separate CSV files (comment out Option A above) -------
% csv_noLoad = fullfile(data_dir, 'MVP_NewG_NoLoadShedding.csv');
% csv_load1  = fullfile(data_dir, 'MVP_NewG_Load1Shedding.csv');
% opts = detectImportOptions(csv_noLoad, 'VariableNamingRule', 'preserve');
% T_nl = readtable(csv_noLoad, opts);
% opts = detectImportOptions(csv_load1,  'VariableNamingRule', 'preserve');
% T_l1 = readtable(csv_load1,  opts);

%% -----------------------------------------------------------------------
%  Strip any leading/trailing whitespace from variable names
%  (CSV headers in this dataset contain a space after each comma)
%% -----------------------------------------------------------------------
T_nl.Properties.VariableNames = strtrim(T_nl.Properties.VariableNames);
T_l1.Properties.VariableNames = strtrim(T_l1.Properties.VariableNames);

%% -----------------------------------------------------------------------
%  Extract signals
%% -----------------------------------------------------------------------
t_nl = T_nl.Domain;    t_l1 = T_l1.Domain;

% Figure 1 signals
Pgen1_nl = T_nl.P_Gen1;   Pgen1_l1 = T_l1.P_Gen1;
Qgen1_nl = T_nl.Q_Gen1;   Qgen1_l1 = T_l1.Q_Gen1;
freq1_nl = T_nl.freq1;    freq1_l1 = T_l1.freq1;
freq2_nl = T_nl.freq2;    freq2_l1 = T_l1.freq2;

% Figure 2 signals
fPCC_nl  = T_nl.freqPCC;  fPCC_l1  = T_l1.freqPCC;
VPCC_nl  = T_nl.VPCC;     VPCC_l1  = T_l1.VPCC;
PPCC_nl  = T_nl.PPCC;     PPCC_l1  = T_l1.PPCC;
QPCC_nl  = T_nl.QPCC;     QPCC_l1  = T_l1.QPCC;

%% -----------------------------------------------------------------------
%  Global rendering: LaTeX interpreter for all text elements
%% -----------------------------------------------------------------------
set(groot, 'DefaultTextInterpreter',          'latex');
set(groot, 'DefaultAxesTickLabelInterpreter', 'latex');
set(groot, 'DefaultLegendInterpreter',        'latex');
set(groot, 'DefaultAxesFontSize',             11);

% Line style / colour scheme
lw   = 1.6;
c_nl = [0.0000, 0.4470, 0.7410];   % blue  -- No Load Shedding
c_l1 = [0.8500, 0.3250, 0.0980];   % red   -- Load 1 Shedding
ls_nl = '-';
ls_l1 = '--';

leg_nl = 'No Load Shedding';
leg_l1 = 'Load 1 Shedding';

%% =======================================================================
%  FIGURE 1 -- Generator signals: P_gen1, Q_gen1, freq1, freq2
%% =======================================================================
fig1 = figure('Name', 'Generator Signals', ...
              'Color', 'w', ...
              'Position', [80, 60, 820, 960]);

% --- Subplot 1/4 : Active power of Generator 1 --------------------------
ax1 = subplot(4,1,1);
plot(t_nl, Pgen1_nl, ls_nl, 'Color', c_nl, 'LineWidth', lw); hold on;
plot(t_l1, Pgen1_l1, ls_l1, 'Color', c_l1, 'LineWidth', lw);
ylabel('$P_{\mathrm{gen1}}$ (p.u.)', 'FontSize', 12);
legend(leg_nl, leg_l1, 'Location', 'best', 'FontSize', 10);
title('Generator 1 --- Active Power');
grid on; box on;
set(gca, 'XTickLabel', []);

% --- Subplot 2/4 : Reactive power of Generator 1 ------------------------
ax2 = subplot(4,1,2);
plot(t_nl, Qgen1_nl, ls_nl, 'Color', c_nl, 'LineWidth', lw); hold on;
plot(t_l1, Qgen1_l1, ls_l1, 'Color', c_l1, 'LineWidth', lw);
ylabel('$Q_{\mathrm{gen1}}$ (p.u.)', 'FontSize', 12);
legend(leg_nl, leg_l1, 'Location', 'best', 'FontSize', 10);
title('Generator 1 --- Reactive Power');
grid on; box on;
set(gca, 'XTickLabel', []);

% --- Subplot 3/4 : Frequency at Generator 1 terminal -------------------
ax3 = subplot(4,1,3);
plot(t_nl, freq1_nl, ls_nl, 'Color', c_nl, 'LineWidth', lw); hold on;
plot(t_l1, freq1_l1, ls_l1, 'Color', c_l1, 'LineWidth', lw);
ylabel('$f_{1}$ (Hz)', 'FontSize', 12);
legend(leg_nl, leg_l1, 'Location', 'best', 'FontSize', 10);
title('Generator 1 --- Terminal Frequency');
grid on; box on;
set(gca, 'XTickLabel', []);

% --- Subplot 4/4 : Frequency at Generator 2 terminal -------------------
ax4 = subplot(4,1,4);
plot(t_nl, freq2_nl, ls_nl, 'Color', c_nl, 'LineWidth', lw); hold on;
plot(t_l1, freq2_l1, ls_l1, 'Color', c_l1, 'LineWidth', lw);
xlabel('Time (s)', 'FontSize', 12);
ylabel('$f_{2}$ (Hz)', 'FontSize', 12);
legend(leg_nl, leg_l1, 'Location', 'best', 'FontSize', 10);
title('Generator 2 --- Terminal Frequency');
grid on; box on;

% Align all axes and add super-title
linkaxes([ax1 ax2 ax3 ax4], 'x');
sgtitle('Generator Signals: No Load Shedding vs.\ Load 1 Shedding', ...
        'FontSize', 14, 'FontWeight', 'bold');

%% =======================================================================
%  FIGURE 2 -- PCC signals: freqPCC, VPCC, PPCC, QPCC
%% =======================================================================
fig2 = figure('Name', 'PCC Signals', ...
              'Color', 'w', ...
              'Position', [940, 60, 820, 960]);

% --- Subplot 1/4 : PCC Frequency ----------------------------------------
ax5 = subplot(4,1,1);
plot(t_nl, fPCC_nl, ls_nl, 'Color', c_nl, 'LineWidth', lw); hold on;
plot(t_l1, fPCC_l1, ls_l1, 'Color', c_l1, 'LineWidth', lw);
ylabel('$f_{\mathrm{PCC}}$ (Hz)', 'FontSize', 12);
legend(leg_nl, leg_l1, 'Location', 'best', 'FontSize', 10);
title('PCC --- Frequency');
grid on; box on;
set(gca, 'XTickLabel', []);

% --- Subplot 2/4 : PCC Voltage ------------------------------------------
ax6 = subplot(4,1,2);
plot(t_nl, VPCC_nl, ls_nl, 'Color', c_nl, 'LineWidth', lw); hold on;
plot(t_l1, VPCC_l1, ls_l1, 'Color', c_l1, 'LineWidth', lw);
ylabel('$V_{\mathrm{PCC}}$ (p.u.)', 'FontSize', 12);
legend(leg_nl, leg_l1, 'Location', 'best', 'FontSize', 10);
title('PCC --- Voltage Magnitude');
grid on; box on;
set(gca, 'XTickLabel', []);

% --- Subplot 3/4 : PCC Active Power -------------------------------------
ax7 = subplot(4,1,3);
plot(t_nl, PPCC_nl, ls_nl, 'Color', c_nl, 'LineWidth', lw); hold on;
plot(t_l1, PPCC_l1, ls_l1, 'Color', c_l1, 'LineWidth', lw);
ylabel('$P_{\mathrm{PCC}}$ (p.u.)', 'FontSize', 12);
legend(leg_nl, leg_l1, 'Location', 'best', 'FontSize', 10);
title('PCC --- Active Power');
grid on; box on;
set(gca, 'XTickLabel', []);

% --- Subplot 4/4 : PCC Reactive Power -----------------------------------
ax8 = subplot(4,1,4);
plot(t_nl, QPCC_nl, ls_nl, 'Color', c_nl, 'LineWidth', lw); hold on;
plot(t_l1, QPCC_l1, ls_l1, 'Color', c_l1, 'LineWidth', lw);
xlabel('Time (s)', 'FontSize', 12);
ylabel('$Q_{\mathrm{PCC}}$ (p.u.)', 'FontSize', 12);
legend(leg_nl, leg_l1, 'Location', 'best', 'FontSize', 10);
title('PCC --- Reactive Power');
grid on; box on;

linkaxes([ax5 ax6 ax7 ax8], 'x');
sgtitle('PCC Signals: No Load Shedding vs.\ Load 1 Shedding', ...
        'FontSize', 14, 'FontWeight', 'bold');
