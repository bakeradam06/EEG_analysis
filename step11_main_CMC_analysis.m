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

%% get grp summaries

grpingVars = ["session","Phase","BrainRegion","Muscle","Band","Condition"]; % note to self, needs to be string
summryBig = groupsummary(allData,grpingVars,'Mean','Coh'); % get summry accrding to above
% returns 768 rows, as 3*2*8*4*2*2 = 768

% smaller grouped dataset
grpingVars2 = ["session","Phase","BrainRegion","Muscle","Band"]; % removed condiiton for now
summry2= groupsummary(allData,grpingVars2,'Mean','Coh');
% 3*2*8*4*2 = 384 rows. Using these data would be avging NoVib and Vib together

%% begin plotting

groups = findgroups(summry2.BrainRegion, summry2.Muscle);
splitapply(@(x) plot(x), summry2.mean_Coh, groups) 

%% first lme model

% generate subsample of data
heightA = height(allData);
subsetIdx = logical(randi([0,1],heightA,1));

allData_subset = allData(subsetIdx,:);



%%
form = fitlme(allData, "WFMTavgTime ~ Coh + session + (Subject | session)");
lme = fitlme(allData, form)