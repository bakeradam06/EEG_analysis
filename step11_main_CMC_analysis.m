% analysis script, TNT CMC analysis
% started 10/31/25
% written by ab

% what is done here:
% load data from main_TNT_CMC_analysis (the data wrangling script)
% run statsitical analysis
% develop interpretations accoridngly

% last updated: 10/31/25

%% load txt dataset from data wrangling script above

allCMC = readtable("cmcDataTNT2.txt");


%% explore data

plot(allCMC.Coh)
