function [cmcBetaPreNegTwoToZero_FDS, cmcBetaPreZeroToTwo_FDS, ...
          cmcBetaPostNegTwoToZero_FDS, cmcBetaPostZeroToTwo_FDS, ...
          cmcBetaFUNegTwoToZero_FDS, cmcBetaFUZeroToTwo_FDS, ...
          cmcBetaPreVibNegTwoToZero_FDS, cmcBetaPreVibZeroToTwo_FDS, ...
          cmcBetaPostVibNegTwoToZero_FDS, cmcBetaPostVibZeroToTwo_FDS, ...
          cmcBetaFUVibNegTwoToZero_FDS, cmcBetaFUVibZeroToTwo_FDS, ...
          lastRowNV_FDS, lastRowV_FDS] = ...
    sub_getCMC_FDS_Beta(dataCMCBetaNV_FDS, dataCMCBetaV_FDS, ...
    preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
    preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
    postIdxNV, postIdxV, pairsCmcChar, y)

% Pre NoVib
cmcBetaPreNegTwoToZero_FDS = dataCMCBetaNV_FDS{y}(4:3+preTrialsAvailableNV, 36:43);
cmcBetaPreNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcBetaPreZeroToTwo_FDS = dataCMCBetaNV_FDS{y}(4:3+preTrialsAvailableNV, 54:61);
cmcBetaPreZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% Post NoVib
cmcBetaPostNegTwoToZero_FDS = dataCMCBetaNV_FDS{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
cmcBetaPostNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcBetaPostZeroToTwo_FDS = dataCMCBetaNV_FDS{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
cmcBetaPostZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% FU NoVib
lastRowNV_FDS = size(dataCMCBetaNV_FDS{y}, 1);
cmcBetaFUNegTwoToZero_FDS = dataCMCBetaNV_FDS{y}(lastRowNV_FDS-fuTrialsAvailableNV+1:lastRowNV_FDS, 36:43);
cmcBetaFUNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcBetaFUZeroToTwo_FDS = dataCMCBetaNV_FDS{y}(lastRowNV_FDS-fuTrialsAvailableNV+1:lastRowNV_FDS, 54:61);
cmcBetaFUZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% Pre Vib
cmcBetaPreVibNegTwoToZero_FDS = dataCMCBetaV_FDS{y}(4:3+preTrialsAvailableV, 36:43);
cmcBetaPreVibNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcBetaPreVibZeroToTwo_FDS = dataCMCBetaV_FDS{y}(4:3+preTrialsAvailableV, 54:61);
cmcBetaPreVibZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% Post Vib
cmcBetaPostVibNegTwoToZero_FDS = dataCMCBetaV_FDS{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 36:43);
cmcBetaPostVibNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcBetaPostVibZeroToTwo_FDS = dataCMCBetaV_FDS{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 54:61);
cmcBetaPostVibZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% FU Vib
lastRowV_FDS = size(dataCMCBetaV_FDS{y}, 1);
cmcBetaFUVibNegTwoToZero_FDS = dataCMCBetaV_FDS{y}(lastRowV_FDS-fuTrialsAvailableV+1:lastRowV_FDS, 36:43);
cmcBetaFUVibNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcBetaFUVibZeroToTwo_FDS = dataCMCBetaV_FDS{y}(lastRowV_FDS-fuTrialsAvailableV+1:lastRowV_FDS, 54:61);
cmcBetaFUVibZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;
end