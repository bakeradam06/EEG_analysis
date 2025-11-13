% analysis script, TNT CMC analysis
% started 10/31/25
% written by ab

% what this does:
% load data from main_TNT_CMC_analysis (the data wrangling script)
% run stats (basic regressions, LMM)

% last updated: 11/11/25

%% load txt dataset from data wrangling script

allData = readtable("allDataForAnalyze.txt");

%% explore data

figure
scatter(allData.Coh, allData.WMFTavgHand);
