
% paths
basePath = pwd; % needs to be run from TNTanalysis folder 
% /Users/DOB223/Library/CloudStorage/OneDrive-MedicalUniversityofSouthCarolina/Documents/lab/studies/1eeg/TNTanalysis

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

%% get clinical data (calls subfunction)

[clinicalData] = sub_getClinicalData();

%% start big table for later

allCMC = table();

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% CMC import %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% start loop to compile data
for y = 1:length(excelFileNames)
    % name current excel file
    currentExcelFile = excelFileNames(y);
    % take pt ID from current excel file
    currentPt = string(extractBefore(currentExcelFile,'_'));
    % print ID to cmd window
    disp(['currently processing'  currentPt]);

    % apb
    dataCMCBetaNV_APB(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','APB beta NoVib')};
    dataCMCBetaV_APB(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','APB beta Vib')};
    dataCMCGammaNV_APB(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','APB gamma NoVib')};
    dataCMCGammaV_APB(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','APB gamma Vib')};

    % fdi
    dataCMCBetaNV_FDI(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDI beta NoVib')};
    dataCMCBetaV_FDI(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDI beta Vib')};
    dataCMCGammaNV_FDI(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDI gamma NoVib')};
    dataCMCGammaV_FDI(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDI gamma Vib')};

    % fds
    dataCMCBetaNV_FDS(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDS beta NoVib')};
    dataCMCBetaV_FDS(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDS beta Vib')};
    dataCMCGammaNV_FDS(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDS gamma NoVib')};
    dataCMCGammaV_FDS(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','FDS gamma Vib')};

    % edc
    dataCMCBetaNV_EDC(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','EDC beta NoVib')};
    dataCMCBetaV_EDC(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','EDC beta Vib')};
    dataCMCGammaNV_EDC(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','EDC gamma NoVib')};
    dataCMCGammaV_EDC(y) = {readtable(fullfile('step9excel',excelFileNames(y)),'Sheet','EDC gamma Vib')};
    
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

    %% now same for Vib
    filenameColV = dataCMCBetaV_APB{y}.Var1;
    % Find indices of "Post" and "FU" within Vib filenames
    postIdxV = find(contains(filenameColV, 'Post', 'IgnoreCase', true), 1);
    fuIdxV   = find(contains(filenameColV, 'FU', 'IgnoreCase', true), 1);

    preTrialsAvailableV  = postIdxV - 4; % Adjust for first 3 non-trial rows
    postTrialsAvailableV = fuIdxV - postIdxV;
    fuTrialsAvailableV   = size(dataCMCBetaV_APB{y}, 1) - fuIdxV + 1;
   
    %% exclusions - NV CMC 
    exclusion2NVcmc = dataCMCBetaNV_APB{y}(4:end,5:6);
    exclusion2NVcmc.Properties.VariableNames(1) = "pinchIncludeTrial";
    exclusion2NVcmc.Properties.VariableNames(2) = "openIncludeTrial";

    % % Vib CMC
    exclusion2Vcmc = dataCMCBetaV_APB{y}(4:end,5:6);
    exclusion2Vcmc.Properties.VariableNames(1) = "pinchIncludeTrial";
    exclusion2Vcmc.Properties.VariableNames(2) = "openIncludeTrial";

     %% subfunctions for import
     %% for beta CMC - APB
     [cmcBetaPreNegTwoToZero_APB, cmcBetaPreZeroToTwo_APB, ...
         cmcBetaPostNegTwoToZero_APB, cmcBetaPostZeroToTwo_APB, ...
         cmcBetaFUNegTwoToZero_APB, cmcBetaFUZeroToTwo_APB, ...
         cmcBetaPreVibNegTwoToZero_APB, cmcBetaPreVibZeroToTwo_APB, ...
         cmcBetaPostVibNegTwoToZero_APB, cmcBetaPostVibZeroToTwo_APB, ...
         cmcBetaFUVibNegTwoToZero_APB, cmcBetaFUVibZeroToTwo_APB, ...
         lastRowNV_APB, lastRowV_APB] = ...
         sub_getCMC_APB_Beta(dataCMCBetaNV_APB, dataCMCBetaV_APB, ...
         preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
         preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
         postIdxNV, postIdxV, pairsCmcChar, y);
    %% beta CMC - FDI
    [cmcBetaPreNegTwoToZero_FDI, cmcBetaPreZeroToTwo_FDI, ...
        cmcBetaPostNegTwoToZero_FDI, cmcBetaPostZeroToTwo_FDI, ...
        cmcBetaFUNegTwoToZero_FDI, cmcBetaFUZeroToTwo_FDI, ...
        cmcBetaPreVibNegTwoToZero_FDI, cmcBetaPreVibZeroToTwo_FDI, ...
        cmcBetaPostVibNegTwoToZero_FDI, cmcBetaPostVibZeroToTwo_FDI, ...
        cmcBetaFUVibNegTwoToZero_FDI, cmcBetaFUVibZeroToTwo_FDI, ...
        lastRowNV_FDI, lastRowV_FDI] = ...
        sub_getCMC_FDI_Beta(dataCMCBetaNV_FDI, dataCMCBetaV_FDI, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
        postIdxNV, postIdxV, pairsCmcChar, y);
    %% beta CMC - FDS
    [cmcBetaPreNegTwoToZero_FDS, cmcBetaPreZeroToTwo_FDS, ...
        cmcBetaPostNegTwoToZero_FDS, cmcBetaPostZeroToTwo_FDS, ...
        cmcBetaFUNegTwoToZero_FDS, cmcBetaFUZeroToTwo_FDS, ...
        cmcBetaPreVibNegTwoToZero_FDS, cmcBetaPreVibZeroToTwo_FDS, ...
        cmcBetaPostVibNegTwoToZero_FDS, cmcBetaPostVibZeroToTwo_FDS, ...
        cmcBetaFUVibNegTwoToZero_FDS, cmcBetaFUVibZeroToTwo_FDS, ...
        lastRowNV_FDS, lastRowV_FDS] = ...
        sub_getCMC_FDS_Beta(dataCMCBetaNV_FDS, dataCMCBetaV_FDS, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
        postIdxNV, postIdxV, pairsCmcChar, y);
    %% beta CMC - EDC
    [cmcBetaPreNegTwoToZero_EDC, cmcBetaPreZeroToTwo_EDC, ...
        cmcBetaPostNegTwoToZero_EDC, cmcBetaPostZeroToTwo_EDC, ...
        cmcBetaFUNegTwoToZero_EDC, cmcBetaFUZeroToTwo_EDC, ...
        cmcBetaPreVibNegTwoToZero_EDC, cmcBetaPreVibZeroToTwo_EDC, ...
        cmcBetaPostVibNegTwoToZero_EDC, cmcBetaPostVibZeroToTwo_EDC, ...
        cmcBetaFUVibNegTwoToZero_EDC, cmcBetaFUVibZeroToTwo_EDC, ...
        lastRowNV_EDC, lastRowV_EDC] = ...
        sub_getCMC_EDC_Beta(dataCMCBetaNV_EDC, dataCMCBetaV_EDC, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
        postIdxNV, postIdxV, pairsCmcChar, y);

    %% gamma CMC - APB
    [cmcGammaPreNegTwoToZero_APB, cmcGammaPreZeroToTwo_APB, ...
        cmcGammaPostNegTwoToZero_APB, cmcGammaPostZeroToTwo_APB, ...
        cmcGammaFUNegTwoToZero_APB, cmcGammaFUZeroToTwo_APB, ...
        cmcGammaPreVibNegTwoToZero_APB, cmcGammaPreVibZeroToTwo_APB, ...
        cmcGammaPostVibNegTwoToZero_APB, cmcGammaPostVibZeroToTwo_APB, ...
        cmcGammaFUVibNegTwoToZero_APB, cmcGammaFUVibZeroToTwo_APB, ...
        lastRowNV_APB_Gamma, lastRowV_APB_Gamma] = ...
        sub_getCMC_APB_Gamma(dataCMCGammaNV_APB, dataCMCGammaV_APB, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
        postIdxNV, postIdxV, pairsCmcChar, y);

    %% gamma CMC - FDI
    [cmcGammaPreNegTwoToZero_FDI, cmcGammaPreZeroToTwo_FDI, ...
        cmcGammaPostNegTwoToZero_FDI, cmcGammaPostZeroToTwo_FDI, ...
        cmcGammaFUNegTwoToZero_FDI, cmcGammaFUZeroToTwo_FDI, ...
        cmcGammaPreVibNegTwoToZero_FDI, cmcGammaPreVibZeroToTwo_FDI, ...
        cmcGammaPostVibNegTwoToZero_FDI, cmcGammaPostVibZeroToTwo_FDI, ...
        cmcGammaFUVibNegTwoToZero_FDI, cmcGammaFUVibZeroToTwo_FDI, ...
        lastRowNV_FDI_Gamma, lastRowV_FDI_Gamma] = ...
        sub_getCMC_FDI_Gamma(dataCMCGammaNV_FDI, dataCMCGammaV_FDI, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
        postIdxNV, postIdxV, pairsCmcChar, y);

    %% gamma CMC - FDS
    [cmcGammaPreNegTwoToZero_FDS, cmcGammaPreZeroToTwo_FDS, ...
        cmcGammaPostNegTwoToZero_FDS, cmcGammaPostZeroToTwo_FDS, ...
        cmcGammaFUNegTwoToZero_FDS, cmcGammaFUZeroToTwo_FDS, ...
        cmcGammaPreVibNegTwoToZero_FDS, cmcGammaPreVibZeroToTwo_FDS, ...
        cmcGammaPostVibNegTwoToZero_FDS, cmcGammaPostVibZeroToTwo_FDS, ...
        cmcGammaFUVibNegTwoToZero_FDS, cmcGammaFUVibZeroToTwo_FDS, ...
        lastRowNV_FDS_Gamma, lastRowV_FDS_Gamma] = ...
        sub_getCMC_FDS_Gamma(dataCMCGammaNV_FDS, dataCMCGammaV_FDS, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
        postIdxNV, postIdxV, pairsCmcChar, y);

    %% gamma CMC - EDC
    [cmcGammaPreNegTwoToZero_EDC, cmcGammaPreZeroToTwo_EDC, ...
        cmcGammaPostNegTwoToZero_EDC, cmcGammaPostZeroToTwo_EDC, ...
        cmcGammaFUNegTwoToZero_EDC, cmcGammaFUZeroToTwo_EDC, ...
        cmcGammaPreVibNegTwoToZero_EDC, cmcGammaPreVibZeroToTwo_EDC, ...
        cmcGammaPostVibNegTwoToZero_EDC, cmcGammaPostVibZeroToTwo_EDC, ...
        cmcGammaFUVibNegTwoToZero_EDC, cmcGammaFUVibZeroToTwo_EDC, ...
        lastRowNV_EDC_Gamma, lastRowV_EDC_Gamma] = ...
        sub_getCMC_EDC_Gamma(dataCMCGammaNV_EDC, dataCMCGammaV_EDC, ...
        preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
        preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
        postIdxNV, postIdxV, pairsCmcChar, y);

    %% start combining together Pre Post FU, then append exclusions
    
    % Beta -
        % -- NoVib --
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
    
        % -- Vib --
    
        % Preparation phase (-2 to 0 before pinch cue)
        cmcBetaPrepV_APB = vertcat(cmcBetaPreVibNegTwoToZero_APB,cmcBetaPostVibNegTwoToZero_APB,cmcBetaFUVibNegTwoToZero_APB);
        cmcBetaPrepV_FDI = vertcat(cmcBetaPreVibNegTwoToZero_FDI,cmcBetaPostVibNegTwoToZero_FDI,cmcBetaFUVibNegTwoToZero_FDI);
        cmcBetaPrepV_FDS = vertcat(cmcBetaPreVibNegTwoToZero_FDS,cmcBetaPostVibNegTwoToZero_FDS,cmcBetaFUVibNegTwoToZero_FDS);
        cmcBetaPrepV_EDC = vertcat(cmcBetaPreVibNegTwoToZero_EDC,cmcBetaPostVibNegTwoToZero_EDC,cmcBetaFUVibNegTwoToZero_EDC);
    
        % Execution phase (0 to 2 s after pinch cue)
        cmcBetaExeV_APB = vertcat(cmcBetaPreVibZeroToTwo_APB,cmcBetaPostVibZeroToTwo_APB,cmcBetaFUVibZeroToTwo_APB);
        cmcBetaExeV_FDI = vertcat(cmcBetaPreVibZeroToTwo_FDI,cmcBetaPostVibZeroToTwo_FDI,cmcBetaFUVibZeroToTwo_FDI);
        cmcBetaExeV_FDS = vertcat(cmcBetaPreVibZeroToTwo_FDS,cmcBetaPostVibZeroToTwo_FDS,cmcBetaFUVibZeroToTwo_FDS);
        cmcBetaExeV_EDC = vertcat(cmcBetaPreVibZeroToTwo_EDC,cmcBetaPostVibZeroToTwo_EDC,cmcBetaFUVibZeroToTwo_EDC);
    
        % add exclusions - Prep
        cmcBetaPrepV_APB = horzcat(cmcBetaPrepV_APB,exclusion2Vcmc);
        cmcBetaPrepV_FDI = horzcat(cmcBetaPrepV_FDI,exclusion2Vcmc);
        cmcBetaPrepV_FDS = horzcat(cmcBetaPrepV_FDS,exclusion2Vcmc);
        cmcBetaPrepV_EDC = horzcat(cmcBetaPrepV_EDC,exclusion2Vcmc);
    
        % add exclusions - Exe
        cmcBetaExeV_APB = horzcat(cmcBetaExeV_APB,exclusion2Vcmc);
        cmcBetaExeV_FDI = horzcat(cmcBetaExeV_FDI,exclusion2Vcmc);
        cmcBetaExeV_FDS = horzcat(cmcBetaExeV_FDS,exclusion2Vcmc);
        cmcBetaExeV_EDC = horzcat(cmcBetaExeV_EDC,exclusion2Vcmc);

    % Gamma - 
        % -- NoVib --
        % Preparation phase (-2 to 0 before pinch cue)
        cmcGammaPrepNV_APB = vertcat(cmcGammaPreNegTwoToZero_APB,cmcGammaPostNegTwoToZero_APB,cmcGammaFUNegTwoToZero_APB);
        cmcGammaPrepNV_FDI = vertcat(cmcGammaPreNegTwoToZero_FDI,cmcGammaPostNegTwoToZero_FDI,cmcGammaFUNegTwoToZero_FDI);
        cmcGammaPrepNV_FDS = vertcat(cmcGammaPreNegTwoToZero_FDS,cmcGammaPostNegTwoToZero_FDS,cmcGammaFUNegTwoToZero_FDS);
        cmcGammaPrepNV_EDC = vertcat(cmcGammaPreNegTwoToZero_EDC,cmcGammaPostNegTwoToZero_EDC,cmcGammaFUNegTwoToZero_EDC);
    
        % Execution phase (0 to 2 s after pinch cue)
        cmcGammaExeNV_APB = vertcat(cmcGammaPreZeroToTwo_APB,cmcGammaPostZeroToTwo_APB,cmcGammaFUZeroToTwo_APB);
        cmcGammaExeNV_FDI = vertcat(cmcGammaPreZeroToTwo_FDI,cmcGammaPostZeroToTwo_FDI,cmcGammaFUZeroToTwo_FDI);
        cmcGammaExeNV_FDS = vertcat(cmcGammaPreZeroToTwo_FDS,cmcGammaPostZeroToTwo_FDS,cmcGammaFUZeroToTwo_FDS);
        cmcGammaExeNV_EDC = vertcat(cmcGammaPreZeroToTwo_EDC,cmcGammaPostZeroToTwo_EDC,cmcGammaFUZeroToTwo_EDC);
    
        % add exclusions - Prep
        cmcGammaPrepNV_APB = horzcat(cmcGammaPrepNV_APB,exclusion2NVcmc);
        cmcGammaPrepNV_FDI = horzcat(cmcGammaPrepNV_FDI,exclusion2NVcmc);
        cmcGammaPrepNV_FDS = horzcat(cmcGammaPrepNV_FDS,exclusion2NVcmc);
        cmcGammaPrepNV_EDC = horzcat(cmcGammaPrepNV_EDC,exclusion2NVcmc);
    
        % add exclusions - Exe
        cmcGammaExeNV_APB = horzcat(cmcGammaExeNV_APB,exclusion2NVcmc);
        cmcGammaExeNV_FDI = horzcat(cmcGammaExeNV_FDI,exclusion2NVcmc);
        cmcGammaExeNV_FDS = horzcat(cmcGammaExeNV_FDS,exclusion2NVcmc);
        cmcGammaExeNV_EDC = horzcat(cmcGammaExeNV_EDC,exclusion2NVcmc);
    
        % -- Vib --
    
        % Preparation phase (-2 to 0 before pinch cue)
        cmcGammaPrepV_APB = vertcat(cmcGammaPreVibNegTwoToZero_APB,cmcGammaPostVibNegTwoToZero_APB,cmcGammaFUVibNegTwoToZero_APB);
        cmcGammaPrepV_FDI = vertcat(cmcGammaPreVibNegTwoToZero_FDI,cmcGammaPostVibNegTwoToZero_FDI,cmcGammaFUVibNegTwoToZero_FDI);
        cmcGammaPrepV_FDS = vertcat(cmcGammaPreVibNegTwoToZero_FDS,cmcGammaPostVibNegTwoToZero_FDS,cmcGammaFUVibNegTwoToZero_FDS);
        cmcGammaPrepV_EDC = vertcat(cmcGammaPreVibNegTwoToZero_EDC,cmcGammaPostVibNegTwoToZero_EDC,cmcGammaFUVibNegTwoToZero_EDC);
    
        % Execution phase (0 to 2 s after pinch cue)
        cmcGammaExeV_APB = vertcat(cmcGammaPreVibZeroToTwo_APB,cmcGammaPostVibZeroToTwo_APB,cmcGammaFUVibZeroToTwo_APB);
        cmcGammaExeV_FDI = vertcat(cmcGammaPreVibZeroToTwo_FDI,cmcGammaPostVibZeroToTwo_FDI,cmcGammaFUVibZeroToTwo_FDI);
        cmcGammaExeV_FDS = vertcat(cmcGammaPreVibZeroToTwo_FDS,cmcGammaPostVibZeroToTwo_FDS,cmcGammaFUVibZeroToTwo_FDS);
        cmcGammaExeV_EDC = vertcat(cmcGammaPreVibZeroToTwo_EDC,cmcGammaPostVibZeroToTwo_EDC,cmcGammaFUVibZeroToTwo_EDC);
    
        % add exclusions - Prep
        cmcGammaPrepV_APB = horzcat(cmcGammaPrepV_APB,exclusion2Vcmc);
        cmcGammaPrepV_FDI = horzcat(cmcGammaPrepV_FDI,exclusion2Vcmc);
        cmcGammaPrepV_FDS = horzcat(cmcGammaPrepV_FDS,exclusion2Vcmc);
        cmcGammaPrepV_EDC = horzcat(cmcGammaPrepV_EDC,exclusion2Vcmc);
    
        % add exclusions - Exe
        cmcGammaExeV_APB = horzcat(cmcGammaExeV_APB,exclusion2Vcmc);
        cmcGammaExeV_FDI = horzcat(cmcGammaExeV_FDI,exclusion2Vcmc);
        cmcGammaExeV_FDS = horzcat(cmcGammaExeV_FDS,exclusion2Vcmc);
        cmcGammaExeV_EDC = horzcat(cmcGammaExeV_EDC,exclusion2Vcmc);

    %% clean up this mess
    clear cmcBetaFUNegTwoToZero_APB cmcBetaFUNegTwoToZero_EDC cmcBetaFUNegTwoToZero_FDI cmcBetaFUNegTwoToZero_FDS cmcBetaFUZeroToTwo_APB cmcBetaFUZeroToTwo_EDC...
        cmcBetaFUZeroToTwo_FDI cmcBetaFUZeroToTwo_FDS cmcBetaPostNegTwoToZero_APB cmcBetaPostNegTwoToZero_EDC cmcBetaPostNegTwoToZero_FDI cmcBetaPostNegTwoToZero_FDS ... 
        cmcBetaPostZeroToTwo_APB cmcBetaPostZeroToTwo_EDC cmcBetaPostZeroToTwo_FDI cmcBetaPostZeroToTwo_FDS cmcBetaPreNegTwoToZero_APB cmcBetaPreNegTwoToZero_EDC cmcBetaPreNegTwoToZero_FDI... 
        cmcBetaPreNegTwoToZero_FDS cmcBetaPreZeroToTwo_APB cmcBetaPreZeroToTwo_EDC cmcBetaPreZeroToTwo_FDI cmcBetaPreZeroToTwo_FDS exclusion2NVcmc allDataTNT ...
        exclusion2VcmcsheetsToRead cmcBetaFUVibNegTwoToZero_APB cmcBetaFUVibNegTwoToZero_EDC cmcBetaFUVibNegTwoToZero_FDI cmcBetaFUVibNegTwoToZero_FDS cmcBetaFUVibZeroToTwo_APB cmcBetaFUVibZeroToTwo_EDC cmcBetaFUVibZeroToTwo_FDI...
        cmcBetaFUVibZeroToTwo_FDS cmcBetaPostVibNegTwoToZero_APB cmcBetaPostVibNegTwoToZero_EDC cmcBetaPostVibNegTwoToZero_FDI cmcBetaPostVibNegTwoToZero_FDS cmcBetaPostVibZeroToTwo_APB cmcBetaPostVibZeroToTwo_EDC cmcBetaPostVibZeroToTwo_FDI cmcBetaPostVibZeroToTwo_FDS ...
        cmcBetaPreVibNegTwoToZero_APB cmcBetaPreVibNegTwoToZero_EDC cmcBetaPreVibNegTwoToZero_FDI cmcBetaPreVibNegTwoToZero_FDS cmcBetaPreVibZeroToTwo_APB cmcBetaPreVibZeroToTwo_EDC cmcBetaPreVibZeroToTwo_FDI cmcBetaPreVibZeroToTwo_FDS

    clear cmcGammaFUNegTwoToZero_APB cmcGammaFUNegTwoToZero_EDC cmcGammaFUNegTwoToZero_FDI cmcGammaFUNegTwoToZero_FDS cmcGammaFUVibNegTwoToZero_APB cmcGammaFUVibNegTwoToZero_EDC cmcGammaFUVibNegTwoToZero_FDI cmcGammaFUVibNegTwoToZero_FDS ...
        cmcGammaFUVibZeroToTwo_APB cmcGammaFUVibZeroToTwo_EDC cmcGammaFUVibZeroToTwo_FDI cmcGammaFUVibZeroToTwo_FDS cmcGammaFUZeroToTwo_APB cmcGammaFUZeroToTwo_EDC cmcGammaFUZeroToTwo_FDI cmcGammaFUZeroToTwo_FDS cmcGammaPostNegTwoToZero_APB ...
        cmcGammaPostNegTwoToZero_EDC cmcGammaPostNegTwoToZero_FDI cmcGammaPostNegTwoToZero_FDS cmcGammaPostVibNegTwoToZero_APB cmcGammaPostVibNegTwoToZero_EDC cmcGammaPostVibNegTwoToZero_FDI cmcGammaPostVibNegTwoToZero_FDS cmcGammaPostVibNegTwoToZero_FDS ...
        cmcGammaPostVibNegTwoToZero_FDS cmcGammaPostVibZeroToTwo_APB cmcGammaPostVibZeroToTwo_EDC cmcGammaPostVibZeroToTwo_FDI cmcGammaPostVibZeroToTwo_FDS cmcGammaPostZeroToTwo_APB cmcGammaPostZeroToTwo_EDC cmcGammaPostZeroToTwo_FDI cmcGammaPostZeroToTwo_FDS ...
        cmcGammaPostZeroToTwo_FDS cmcGammaPreNegTwoToZero_APB cmcGammaPreNegTwoToZero_EDC cmcGammaPreNegTwoToZero_FDI cmcGammaPreNegTwoToZero_FDS cmcGammaPreVibNegTwoToZero_APB cmcGammaPreVibNegTwoToZero_EDC cmcGammaPreVibNegTwoToZero_FDI cmcGammaPreVibNegTwoToZero_FDS ...
        cmcGammaPreVibZeroToTwo_APB cmcGammaPreVibZeroToTwo_EDC cmcGammaPreVibZeroToTwo_FDI cmcGammaPreVibZeroToTwo_FDS cmcGammaPreZeroToTwo_APB cmcGammaPreZeroToTwo_EDC cmcGammaPreZeroToTwo_FDI cmcGammaPreZeroToTwo_FDS 

    clear dataCMCBetaNV_APB dataCMCBetaNV_EDC dataCMCBetaNV_FDI dataCMCBetaNV_FDS dataCMCBetaV_APB dataCMCBetaV_EDC dataCMCBetaV_FDI dataCMCBetaV_FDS dataCMCGammaNV_APB dataCMCGammaNV_EDC dataCMCGammaNV_FDI dataCMCGammaNV_FDS dataCMCGammaV_APB dataCMCGammaV_EDC dataCMCGammaV_FDI dataCMCGammaV_FDS
    
    %% exclude trials = 0 in exclusion2 "pinchIncludeTrial" column

    tableDir = {
        cmcBetaExeNV_APB,cmcBetaExeNV_EDC,cmcBetaExeNV_FDI,cmcBetaExeNV_FDS,cmcBetaExeV_APB,cmcBetaExeV_EDC,cmcBetaExeV_FDI,...
        cmcBetaExeV_FDS,cmcBetaPrepNV_APB,cmcBetaPrepNV_EDC,cmcBetaPrepNV_FDI,cmcBetaPrepNV_FDS,cmcBetaPrepV_APB,cmcBetaPrepV_EDC,cmcBetaPrepV_FDI,...
        cmcBetaPrepV_FDS,cmcGammaExeNV_APB,cmcGammaExeNV_EDC,cmcGammaExeNV_FDI,cmcGammaExeNV_FDS,cmcGammaExeV_APB,cmcGammaExeV_EDC,cmcGammaExeV_FDI,...
        cmcGammaExeV_FDS,cmcGammaPrepNV_APB,cmcGammaPrepNV_EDC,cmcGammaPrepNV_FDI,cmcGammaPrepNV_FDS,cmcGammaPrepV_APB,cmcGammaPrepV_EDC,...
        cmcGammaPrepV_FDI,cmcGammaPrepV_FDS
        };
    tableNames = { ...
        'cmcBetaExeNV_APB','cmcBetaExeNV_EDC','cmcBetaExeNV_FDI','cmcBetaExeNV_FDS', ...
        'cmcBetaExeV_APB','cmcBetaExeV_EDC','cmcBetaExeV_FDI','cmcBetaExeV_FDS', ...
        'cmcBetaPrepNV_APB','cmcBetaPrepNV_EDC','cmcBetaPrepNV_FDI','cmcBetaPrepNV_FDS', ...
        'cmcBetaPrepV_APB','cmcBetaPrepV_EDC','cmcBetaPrepV_FDI','cmcBetaPrepV_FDS', ...
        'cmcGammaExeNV_APB','cmcGammaExeNV_EDC','cmcGammaExeNV_FDI','cmcGammaExeNV_FDS', ...
        'cmcGammaExeV_APB','cmcGammaExeV_EDC','cmcGammaExeV_FDI','cmcGammaExeV_FDS', ...
        'cmcGammaPrepNV_APB','cmcGammaPrepNV_EDC','cmcGammaPrepNV_FDI','cmcGammaPrepNV_FDS', ...
        'cmcGammaPrepV_APB','cmcGammaPrepV_EDC','cmcGammaPrepV_FDI','cmcGammaPrepV_FDS'  ...
        };

    for i = 1:numel(tableDir) % for every entry into tableDir
        currentTbl = tableDir{i}; % pull out i-th table
        
        % determining # trials for each time point (since table includes pre post & fu)
        currentName = tableNames{i};

        if contains(currentName,"NV") % if it's NoVib
            nPre  = preTrialsAvailableNV;
            nPost = postTrialsAvailableNV;
            nFU   = fuTrialsAvailableNV;
        else  % if its Vib
            nPre  = preTrialsAvailableV;
            nPost = postTrialsAvailableV;
            nFU   = fuTrialsAvailableV;
        end

        nHeight = height(currentTbl); % get height of currentTbl
        timePoint = repmat("FU",nHeight,1); % make new var corrsponding to height of currentTbl containing all "FU" in rows
        timePoint(1:nPre) = "Pre"; % using # pre trials, change "FU" --> "Pre"
        timePoint(nPre+1:nPre+nPost) = "Post"; % using # Post trials, change "FU" --> "Pre"
        % since "FU" was entered by default, don't need to do anything else to change naming like above
        currentTbl.timePoint = timePoint; % add new column to currentTbl with approrpriate timePoint label 

        % these above actions will help denote what trial is what timePoint after trial exclusion, which is about to happen below
        
        % check if currentTbl has column 'pinchIncludeTrial'
        if ismember('pinchIncludeTrial', currentTbl.Properties.VariableNames)
            % if yes, exclude the rows that have 0 in pinchIncludeTrial
            % (should always be yes)
            currentTbl = currentTbl(currentTbl.pinchIncludeTrial == 1, :);
        end
        
        % assign name of currentTbl to name of tableDir{i} wkspce variable
        assignin('base', tableNames{i}, currentTbl);
    
        % END PRODUCT FROM LOOP: now we have excluded bad trials, and have a list of
        % trials that occurred according to Pre, Post, and FU. 
    end

    %% clear some more vars
    clear currentName filenameColV filenameColNV filenameColVfuIdxNV fuIdxV fuTrialsAvailableNV fuTrialsAvailableV i lastRowNV_APB lastRowNV_APB_Gamma lastRowNV_EDC lastRowNV_EDC_Gamma ...
        lastRowNV_FDI lastRowNV_FDI_Gamma lastRowNV_FDS lastRowNV_FDS_Gamma lastRowV_APB lastRowV_APB_Gamma lastRowV_EDC lastRowV_EDC_Gamma lastRowV_FDI lastRowV_FDI_Gamma lastRowV_FDS lastRowV_FDS_Gamma ...
        nFU nHeight nPost nPre postIdxNV postIdxV postTrialsAvailableNV postTrialsAvailableV preTrialsAvailableNV preTrialsAvailableV sheetsToRead y currentTbl timePoint fuIdxNV exclusion2Vcmc 

    %% combine all 32 CMC tables into one big one for sanity's sake

    for i=1:numel(tableNames) % for all values in tableNames
        currentName = tableNames{i}; % get current table name
        currentTable = eval(currentName); % get the currentTbl from list

        % parse naming
        parts = split(currentName,"_"); % split into parts around _'s
        muscle = parts{2}; % denote muscle (e.g., APB, FDI, FDS, EDC)
        main = parts{1}(4:end); % main part of the name (excluding "cmc" at start)

        if startsWith(main,"Beta") % if var starts iwth beta
            band= "Beta"; % it is beta band
        else
            band="Gamma"; % otherwise gamma
        end

        if contains(main,"Prep") % similar thing with prep and exe
            phase = "Prep";
        else
            phase = "Exe";
        end
        
        if contains(main,"NV") % similar thing with NV and V
            cond = "NoVib";
        else
            cond = "Vib";
        end
        
        % make cols according to details of table
        currentTable.Band = repmat(band,height(currentTable),1); % freq band
        currentTable.Phase = repmat(phase,height(currentTable),1); % prep or exe
        currentTable.Condition = repmat(cond,height(currentTable),1); % noVib or Vib
        currentTable.Muscle = repmat(muscle,height(currentTable),1); % muscle 
        currentTable.Subject   = repmat(currentPt, height(currentTable), 1); % subject #

        allCMC = [allCMC; currentTable]; % add to bigCMC table as we go
        allCMC.Muscle = string(allCMC.Muscle);
    end
end

%% rearrange allCMC into true long format. 
allCMC2 = stack(allCMC,["PML","S1L","M1L","SML","PMN","S1N","M1N","SMN"]);

% rename the indicator var and coh var
allCMC2 = renamevars(allCMC2, "PML_S1L_M1L_SML_PMN_S1N_M1N_SMN_Indicator", "BrainRegion");
allCMC2 = renamevars(allCMC2, "PML_S1L_M1L_SML_PMN_S1N_M1N_SMN", "Coh");

% rename timePoint/session coluimn name and entries so i can then merge by them
allCMC2 = renamevars(allCMC2,'timePoint','session');

% rename entries of allCMC2.session to Baseline inst of Pre, Post 1 inst of Post, and FU 1 inst of FU

% idx of rows want to change
preIdx = contains(allCMC2.session,"Pre");
postIdx = contains(allCMC2.session,"Post");
fuIdx = contains(allCMC2.session,"FU");
% rename
allCMC2.session(preIdx) = "Baseline";
allCMC2.session(postIdx) = "Post 1";
allCMC2.session(fuIdx) = "FU 1";

%% disregard the open incldue trial. i'm only looking at pinch for now
allCMC = removevars(allCMC, "openIncludeTrial");
allCMC2 = removevars(allCMC2, "openIncludeTrial");

%% save so i don't have to keep runnning this code above
writetable(allCMC,'allCMC.txt')
writetable(allCMC2,'allCMC2.txt')

%% combine allCMC with clinicalData
%allData = outerjoin(clinicalData,allCMC2,'Key','Subject','Key','session');

allData = outerjoin(clinicalData,allCMC2,'Key',{'Subject','session'});


%% save for now. Need to confirm accuracy before accepting.

writetable(allData,'allDataTest1.txt')


    
%% clear more vars
clear cmcBetaExeNV_APB cmcBetaExeNV_EDC cmcBetaExeNV_FDI cmcBetaExeNV_FDS cmcBetaExeV_APB cmcBetaExeV_EDC cmcBetaExeV_FDI cmcBetaExeV_FDS cmcBetaPrepNV_APB cmcBetaPrepNV_EDC cmcBetaPrepNV_FDI cmcBetaPrepNV_FDS cmcBetaPrepV_APB cmcBetaPrepV_EDC cmcBetaPrepV_FDI cmcBetaPrepV_FDS cmcGammaExeNV_APB cmcGammaExeNV_EDC cmcGammaExeNV_FDI cmcGammaExeNV_FDS cmcGammaExeV_APB cmcGammaExeV_EDC cmcGammaExeV_FDI cmcGammaExeV_FDS cmcGammaPrepNV_APB cmcGammaPrepNV_EDC cmcGammaPrepNV_FDI cmcGammaPrepNV_FDS cmcGammaPrepV_APB cmcGammaPrepV_EDC cmcGammaPrepV_FDI cmcGammaPrepV_FDS ...
    cond currentTable parts tableDir tableNames currentName currentExcelFile currentPt main i muscle band phase basePath

%% start plotting

% note: careful if running this from something other than MATLAB 2025b with dark mode. i originally wrote this script with dark mode, so the figs
% below only show up with dark background, as is present in 2025b on my machine.

% get subject list from allCMC
subjects = unique(allCMC.Subject);
muscles = unique(allCMC.Muscle);
bands    = ["Beta","Gamma"];
phases   = ["Prep","Exe"];
timeOrder = {'Pre','Post','FU'};
timePoints2 = ["Baseline","Post 1","FU 1"]; % to fit the "clinicalData" table and loop through WMFT data to plot with CMC data
conds = ["NoVib","Vib"];
nPairs   = numel(pairsCmcChar);
outDir = 'CMC_plots';

if ~isfolder(outDir)
    mkdir(outDir);
end

for iSubj=1:numel(subjects) % for all subjects
    currentSubj = subjects(iSubj); % list current subjID
    for iMus = 1:numel(muscles) % for all muscles (APB, FDI, FDS, EDC)
        currentMus = muscles(iMus); % get current muscle

        % create new figure for this current subject
        fig = figure('Visible','off','Name', sprintf('%s – %s', currentSubj, currentMus), ...
            'NumberTitle','off');
        sgtitle(sprintf('Subject %s — %s CMC over Time', currentSubj, currentMus));

        for iBand = 1:2 % for each freq band
            for iCond = 1:2 % for each vib/noVib cond
                for iPhase = 1:2 % for each prep exe phase

                    %figure out which subplot i'm on
                    idx = (iBand-1)*4 + (iCond-1)*2 + iPhase;
                    ax  = subplot(2,4,idx);
                    hold(ax,'on');

                    selection = allCMC.Subject == currentSubj & ... % get currSubj
                        allCMC.Muscle        == currentMus   & ... % get currMuscle
                        allCMC.Band          == bands(iBand) & ... % get currBand
                        allCMC.Condition     == conds(iCond) & ... % get currVib/NoVib
                        allCMC.Phase         == phases(iPhase); % get currPhase
                    T = allCMC(selection,:); % use the above to generate a temp table from allCMC - "selection"

                    if isempty(T) % if tempTable T is empty, do something
                        title(ax, sprintf('%s / %s — no data',bands(iBand),phases(iPhase)));
                        continue;
                    end

                    % group & average
                    tpCat = categorical(T.timePoint, timeOrder, timeOrder); % create categories of Pre Post FU, label them 1=Pre, 2=Post, 3=FU
                    [G, TP] = findgroups(tpCat); % G is array of 1, 2, 3 according to tpCat, TP is "Pre", "Post", "FU"
                    M = splitapply(@(x) mean(x,1,'omitnan'), T{:,pairsCmcChar}, G);

                    % plot each pair
                    for k = 1:nPairs
                        plot(ax, TP, M(:,k), '-o', 'DisplayName', pairsCmcChar{k});
                    end

                    % overlay WMFT scores onto CMC plots
                    hold(ax,'on')
                    
                    msk = strcmp(clinicalData.subject,currentSubj);             % make logical mask of whether row corresp to currentSubj
                    tempWMFT = clinicalData(msk,:);                             % make temp table with all cols and rows pertaining to currentSubj

                    yyaxis(ax, 'right')
                    hold(ax,'on')
                    tp_idx = [];
                    wmft   = [];
                    for j=1:height(tempWMFT)
                        session = tempWMFT.session{j}; % get current session
                        if contains(session, 'Baseline','IgnoreCase',true)
                            label = 'Pre';
                        elseif contains(session, 'Post 1','IgnoreCase',true)
                            label = 'Post';
                        elseif contains(session, 'FU 1','IgnoreCase',true)
                            label = 'FU';
                        else
                            continue
                        end
                        idx = find(strcmp(label, cellstr(TP)), 1);
                        if ~isempty(idx)
                            tp_idx(end+1) = idx;
                            wmft(end+1) = tempWMFT.WMFTAverageTime_s_(j);
                        end
                    end
                    plot(ax, TP(tp_idx), wmft,'s--','Color',[1 1 1], ...            
                        'MarkerEdgeColor','w', 'LineWidth',1.5);                    

                    ylabel('WMFT time (s)');
                    ax = gca;
                    ax.YColor = [1 1 0.9]; % change color of WMFT axis to match WMFT line (white)
                    ylim([0,120]); % max of WMFT is 120s

                    title(ax, sprintf('%s | %s | %s', bands(iBand), conds(iCond), phases(iPhase)));
                    xlabel(ax,'TimePoint');

                    yyaxis left
                    ylabel(ax,'Mean CMC');

                    if iBand==1 && iPhase==1 && iCond == 1
                        legend(ax,'Location','bestoutside');
                    end

                    hold(ax,'off');
                end
            end
        end
        fname = sprintf('%s_%s_CMC.png', currentSubj, currentMus); % save figs from each muscle for each subject
        saveas(fig, fullfile(outDir, fname));
        close(fig);
    end
end

%% Save allCMC data as csv, txt, mat. 
% should be saved in the "TNTanalysis" folder

writetable(allCMC,'cmcDataTNT.csv')
writetable(allCMC2,'cmcDataTNT2.csv')

writetable(allCMC,'cmcDataTNT.txt')
writetable(allCMC2,'cmcDataTNT2.txt')



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% End data wrangling %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% see step11 script for analyzing CMC data for outcomes.



