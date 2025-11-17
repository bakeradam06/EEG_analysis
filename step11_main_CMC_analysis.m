% analysis script, TNT CMC analysis
% started 10/31/25
% written by ab

% what this does:
% load data from main_TNT_CMC_analysis (the data wrangling script)
% run stats (basic regressions, LMM)

% last updated: 11/17/25

%% load txt dataset from data wrangling script

allData = readtable("allDataForAnalyzeTNT.txt");

%% clean up missing data rows
% this will happen bc no CMC data yet. 
% this will change when data are added

allData(isnan(allData.pinchIncludeTrial), :) = [];

%% initial plotting

grpingVars = ["session","Phase","BrainRegion","Muscle","Band","Condition"]; %note to self, needs to be string
summryBig = groupsummary(allData, grpingVars,'Mean','Coh'); % get summry accrding to above
% returns 768 rows, as 3*2*8*4*2*2 = 768

%% first lme model

form = fitlme(allData, "WFMTavgTime ~ Coh + session + (Subject | session)");
lme = fitlme(allData, form)