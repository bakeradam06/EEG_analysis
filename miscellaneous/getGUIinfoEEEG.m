
%%% purpose of script: get all TNT sensThres & vib intensity values for Vib
%%% trials and put them in a spreadsheet to ensure that data entry and
%%% documentation is correct for these values in TNT_allData.xlsx. 

%%% written by AB 2024-07-03

clear all

% main path define
vibGUIPath = '/Users/DOB223/Library/CloudStorage/OneDrive-MedicalUniversityofSouthCarolina/Documents/lab/studies/1eeg/copyGUIfilesFromEEGlabComputer';

% session define
sessions = {'Pre','Post','FU'};

% Initialize an empty table with specified column headers
data = [];

% eegFile = dir(fullfile(mainPath,'*.eeg'));
matFileAll = dir(fullfile(vibGUIPath,'*.mat'));

skips = [65,66,67,72,73,74,76,77,78,79,80];

% loop through all mat files in dir and get vibAmp_trt, sensThres, pt id,
% and session
for p = 1:length(matFileAll)
    tempData = load(fullfile(vibGUIPath, matFileAll(p).name),'participantNum','sessionNum','sensThres','vibAmp_trt');
    
    if ismember(tempData.participantNum, skips)
        continue
        
    if isempty(tempData.participantNum)
        fprintf('blank participantNum at %d and timepoint %d/n',participantNum,sessionNum);
    end
    if isempty(tempData.sensThres)
        fprintf('blank sensThres at %d and timepoint %d/n',participantNum,sessionNum);
    end
    if isempty(tempData.vibAmp_trt)
        fprintf('blank vibAmp_trt at %d and timepoint %d/n',participantNum,sessionNum);
    end
    if isempty(tempData.sessionNum)
        fprintf('blank sessionNum at %d and timepoint %d/n',participantNum,sessionNum);
    end
    end 
    
    tempData = struct2table(tempData);
    data = [tempData; data]; 
    
    data = sortrows(data,["participantNum","sessionNum"],"ascend");
end


