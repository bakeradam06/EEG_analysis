
% paths
basePath = pwd; % needs to be run from TNTanalysis folder 
excelPath = fullfile(basePath, 'step9excel');
addpath(fullfile(basePath, 'scripts'));
% Denote region pairs (n = 28)

% change these to grab from the data instead of using these labels. take
% from excel file (or mat).
pairsCccChar={'PML-S1L';'PML-M1L';'PML-SML';'S1L-M1L';'S1L-SML';'M1L-SML'; ... % ab changed 6th value on 10/25/24 to match step9layout20240820.mat file. it was duplicate M1L-S1L
    'PML-PMN';'PML-S1N';'PML-M1N';'PML-SMN'; ...
    'S1L-PMN';'S1L-S1N';'S1L-M1N';'S1L-SMN'; ...
    'M1L-PMN';'M1L-S1N';'M1L-M1N';'M1L-SMN'; ...
    'SML-PMN';'SML-S1N';'SML-M1N';'SML-SMN'; ...
    'PMN-S1N';'PMN-M1N';'PMN-SMN';'S1N-M1N';'S1N-SMN';'M1N-SMN'};
pairsCmcChar = {'PML','S1L','M1L','SML','PMN','S1N','M1N','SMN'};

%% get file names from path step9excel folder
excelFileNames = dir(fullfile(excelPath,'*.xlsm'));
excelFileNames = string(transpose(extractfield(excelFileNames,'name')));

% make list of all Pt ID's that will be analyzed
allPtID = [];
for L = 1:length(excelFileNames)
    tempID = extractBefore(excelFileNames(L),'_');
    allPtID = [allPtID;tempID];
end
clear tempID L

% get list of sheets from step9excel files
sheetsToRead = {'reason','APB beta NoVib','FDI beta NoVib','FDS beta NoVib','EDC beta NoVib',...
    'APB gamma NoVib','FDI gamma NoVib','FDS gamma NoVib','EDC gamma NoVib','APB beta Vib','FDI beta Vib',...
    'FDS beta Vib','EDC beta Vib','APB gamma Vib','FDI gamma Vib','FDS gamma Vib','EDC gamma Vib'};

%% import WMFT data
% ab updated 2024-10-23 to have new WMFT scores after blinded rater assessment
% cd('..')
allDataTNT = readtable("TNT_WMFT_compiled_scores_2024_02_14_AB SRD.xlsx");
subjID = table(allDataTNT.Subject);
subjID.Properties.VariableNames(1) = "subjID";
wolfTime = table(allDataTNT.x_avgColumnAF_);
wolfTime.Properties.VariableNames(1) = "avgWolfTimes";
timePoint = table(allDataTNT.OriginalVideoName);
timePoint.Properties.VariableNames(1) = "timePoint";
% merge to have one table containing all subjID, timePoint, wolf data
wolfData = horzcat(subjID,timePoint,wolfTime);

% finish changing the naming convention of the subjID
for sirius=1:length(wolfData.subjID)
    currentID = wolfData.subjID(sirius);
    if length(wolfData.subjID{sirius}) == 6
        wolfData.subjID{sirius} = regexprep(currentID,'TNT0+','TNT');
    end
end
% rename the timepoints i want. Account for all the variability in file
% names.
for scabbers=1:length(wolfData.timePoint)
    currentID = wolfData.timePoint{scabbers};
    if contains(wolfData.timePoint{scabbers},"Baseline")
        wolfData.timePoint{scabbers} = "Baseline";
    elseif contains(wolfData.timePoint{scabbers},"BASELINE")
        wolfData.timePoint{scabbers} = "Baseline";
    elseif contains(wolfData.timePoint{scabbers},"B1")
        wolfData.timePoint{scabbers} = "Baseline";
    elseif contains(wolfData.timePoint{scabbers},"Post")
        wolfData.timePoint{scabbers} = "Post";
    elseif contains(wolfData.timePoint{scabbers},"POST")
        wolfData.timePoint{scabbers} = "Post";
    elseif contains(wolfData.timePoint{scabbers},"post")
        wolfData.timePoint{scabbers} = "Post";
    elseif contains(wolfData.timePoint{scabbers},"FU")
        wolfData.timePoint{scabbers} = "FU";
    elseif contains(wolfData.timePoint{scabbers},"FollowUp")
        wolfData.timePoint{scabbers} = "FU";
    elseif contains(wolfData.timePoint{scabbers},"Follow-Up")
        wolfData.timePoint{scabbers} = "FU";
    end
end
timeLabels = {'Pre','Post','Follow up'};
timeLabels2 = ["Baseline","Post","FU"];
wolfData.timePoint = cellstr(wolfData.timePoint);
clear Pre Post FU timePoint wolfTime subjID currentID sirius scabbers


%% CMC import
%% start loop to compile data
for y = 1:length(excelFileNames)
    % name current excel file
    currentExcelFile = excelFileNames(y);
    % take pt ID from current excel file
    currentPt = string(extractBefore(currentExcelFile,'_'));
    % print ID to cmd window
    disp(['currently processing'  currentPt]);

    % % apb
    dataCMCBetaNV_APB(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','APB beta NoVib')};
    % dataCMCBetaV_APB(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','APB beta Vib')};
    dataCMCGammaNV_APB(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','APB gamma NoVib')};
    % dataCMCGammaV_APB(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','APB gamma Vib')};

    % % fdi
    dataCMCBetaNV_FDI(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDI beta NoVib')};
    % dataCMCBetaV_FDI(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDI beta Vib')};
    dataCMCGammaNV_FDI(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDI gamma NoVib')};
    % dataCMCGammaV_FDI(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDI gamma Vib')};

    % % fds
    dataCMCBetaNV_FDS(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDS beta NoVib')};
    % dataCMCBetaV_FDS(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDS beta Vib')};
    dataCMCGammaNV_FDS(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDS gamma NoVib')};
    % dataCMCGammaV_FDS(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDS gamma Vib')};

    % % edc
    dataCMCBetaNV_EDC(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','EDC beta NoVib')};
    % dataCMCBetaV_EDC(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','EDC beta Vib')};
    dataCMCGammaNV_EDC(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','EDC gamma NoVib')};
    % dataCMCGammaV_EDC(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','EDC gamma Vib')};
    
    %% Extract filename column for NoVib trials
    filenameColNV = dataCMCBetaNV_APB{y}.Var1;
    % Find indices of "Post" and "FU" within NoVib filenames
    postIdxNV = find(contains(filenameColNV, 'Post', 'IgnoreCase', true), 1);
    fuIdxNV   = find(contains(filenameColNV, 'FU', 'IgnoreCase', true), 1);

    % Find # of trials for NV based on session (Pre Post or FU)
    % need to do this bc it is not 60 in some cases, like if there were >2 runs
    preTrialsAvailableNV  = postIdxNV - 4; % Adjust for first 3 non-trial rows
    postTrialsAvailableNV = fuIdxNV - postIdxNV;
    fuTrialsAvailableNV   = size(dataCMCBetaNV_APB{y}, 1) - fuIdxNV + 1;

    %% now do the same for Vib
    filenameColV = dataCMCBetaV_APB{y}.Var1;
    % Find indices of "Post" and "FU" within Vib filenames
    postIdxV = find(contains(filenameColV, 'Post', 'IgnoreCase', true), 1);
    fuIdxV   = find(contains(filenameColV, 'FU', 'IgnoreCase', true), 1);

    preTrialsAvailableV  = postIdxV - 4; % Adjust for first 3 non-trial rows
    postTrialsAvailableV = fuIdxV - postIdxV;
    fuTrialsAvailableV   = size(dataCCCAlphaV{y}, 1) - fuIdxV + 1;
   
    %% exclusions - NV CMC 
    exclusion2NVcmc = dataCMCBetaNV_APB{y}(4:end,5:6);
    exclusion2NVcmc.Properties.VariableNames(1) = "pinchIncludeTrial";
    exclusion2NVcmc.Properties.VariableNames(2) = "openIncludeTrial";

    % % Vib CMC
    % exclusion2Vcmc = dataCMCBetaV_APB{y}(4:end,5:6);
    % exclusion2Vcmc.Properties.VariableNames(1) = "pinchIncludeTrial";
    % exclusion2Vcmc.Properties.VariableNames(2) = "openIncludeTrial";

     %% subfunction for beta CMC - APB
    [cmcBetaPreNegTwoToZero_APB, cmcBetaPreZeroToTwo_APB, ...
        cmcBetaPostNegTwoToZero_APB, cmcBetaPostZeroToTwo_APB, ...
        cmcBetaFUNegTwoToZero_APB, cmcBetaFUZeroToTwo_APB, ...
        lastRowNV_APB] = ...
        sub_getCMC_APB_Beta(dataCMCBetaNV_APB, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        postIdxNV, pairsCmcChar, y);
    %% beta CMC - FDI
    [cmcBetaPreNegTwoToZero_FDI, cmcBetaPreZeroToTwo_FDI, ...
        cmcBetaPostNegTwoToZero_FDI, cmcBetaPostZeroToTwo_FDI, ...
        cmcBetaFUNegTwoToZero_FDI, cmcBetaFUZeroToTwo_FDI, ...
        lastRowNV_FDI] = ...
        sub_getCMC_FDI_Beta(dataCMCBetaNV_FDI, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        postIdxNV, pairsCmcChar, y);
    %% beta CMC - FDS
    [cmcBetaPreNegTwoToZero_FDS, cmcBetaPreZeroToTwo_FDS, ...
        cmcBetaPostNegTwoToZero_FDS, cmcBetaPostZeroToTwo_FDS, ...
        cmcBetaFUNegTwoToZero_FDS, cmcBetaFUZeroToTwo_FDS, ...
        lastRowNV_FDS] = ...
        sub_getCMC_FDS_Beta(dataCMCBetaNV_FDS, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        postIdxNV, pairsCmcChar, y);
    %% beta CMC - EDC
    [cmcBetaPreNegTwoToZero_EDC, cmcBetaPreZeroToTwo_EDC, ...
        cmcBetaPostNegTwoToZero_EDC, cmcBetaPostZeroToTwo_EDC, ...
        cmcBetaFUNegTwoToZero_EDC, cmcBetaFUZeroToTwo_EDC, ...
        lastRowNV_EDC] = ...
        sub_getCMC_EDC_Beta(dataCMCBetaNV_EDC, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        postIdxNV, pairsCmcChar, y);

    %% start combining together Pre Post FU, then append exclusions
    
    % Preparation phase (-2 to 0 before pinch cue)
    cmcBetaPrepNV_APB = vertcat(cmcBetaPreNegTwoToZero_APB,cmcBetaPostNegTwoToZero_APB,cmcBetaFUNegTwoToZero_APB);
    cmcBetaPrepNV_FDI = vertcat(cmcBetaPreNegTwoToZero_FDI,cmcBetaPostNegTwoToZero_FDI,cmcBetaFUNegTwoToZero_FDI);
    cmcBetaPrepNV_FDS = vertcat(cmcBetaPreNegTwoToZero_FDS,cmcBetaPostNegTwoToZero_FDS,cmcBetaFUNegTwoToZero_FDS);
    cmcBetaPrepNV_EDC = vertcat(cmcBetaPreNegTwoToZero_EDC,cmcBetaPostNegTwoToZero_EDC,cmcBetaFUNegTwoToZero_EDC);

    % Execution phase (0 to 2 s after pinch cue)
    cmcBetaExeNV_APB = vertcat(cmcBetaPreZeroToTwo_APB,cmcBetaPostZeroToTwo_APB,cmcBetaFUZeroToTwo_APB);
    cmcBetaExeNV_FDI = vertcat(cmcBetaPreZeroToTwo_FDI,cmcBetaPostZeroToTwo_FDI,cmcBetaFUZeroToTwo_FDI);
    cmcBetaExeNV_FDS = vertcat(cmcBetaPreZeroToTwo_FDS,cmcBetaPostZeroToTwo_FDS,cmcBetaFUZeroToTwo_FDS);
    cmcBetaExeNV_EDC = vertcat(cmcBetaPreZeroToTwo_EDC,cmcBetaPostZeroToTwo_EDC,cmcBetaFUZeroToTwo_EDC);

    % add exclusions - Prep
    cmcBetaPrepNV_APB = horzcat(cmcBetaPrepNV_APB,exclusion2NVcmc);
    cmcBetaPrepNV_FDI = horzcat(cmcBetaPrepNV_FDI,exclusion2NVcmc);
    cmcBetaPrepNV_FDS = horzcat(cmcBetaPrepNV_FDS,exclusion2NVcmc);
    cmcBetaPrepNV_EDC = horzcat(cmcBetaPrepNV_EDC,exclusion2NVcmc);
    
    % add exclusions - Exe
    cmcBetaExeNV_APB = horzcat(cmcBetaExeNV_APB,exclusion2NVcmc);
    cmcBetaExeNV_FDI = horzcat(cmcBetaExeNV_FDI,exclusion2NVcmc);
    cmcBetaExeNV_FDS = horzcat(cmcBetaExeNV_FDS,exclusion2NVcmc);
    cmcBetaExeNV_EDC = horzcat(cmcBetaExeNV_EDC,exclusion2NVcmc);

    %% lets clear some vars
    clear cmcBetaFUNegTwoToZero_APB cmcBetaFUNegTwoToZero_EDC cmcBetaFUNegTwoToZero_FDI cmcBetaFUNegTwoToZero_FDS cmcBetaFUZeroToTwo_APB cmcBetaFUZeroToTwo_EDC...
        cmcBetaFUZeroToTwo_FDI cmcBetaFUZeroToTwo_FDS cmcBetaPostNegTwoToZero_APB cmcBetaPostNegTwoToZero_EDC cmcBetaPostNegTwoToZero_FDI cmcBetaPostNegTwoToZero_FDS ... 
        cmcBetaPostZeroToTwo_APB cmcBetaPostZeroToTwo_EDC cmcBetaPostZeroToTwo_FDI cmcBetaPostZeroToTwo_FDS cmcBetaPreNegTwoToZero_APB cmcBetaPreNegTwoToZero_EDC cmcBetaPreNegTwoToZero_FDI... 
        cmcBetaPreNegTwoToZero_FDS cmcBetaPreZeroToTwo_APB cmcBetaPreZeroToTwo_EDC cmcBetaPreZeroToTwo_FDI cmcBetaPreZeroToTwo_FDS exclusion2NVcmc allDataTNT ...
        wolfData



    
end