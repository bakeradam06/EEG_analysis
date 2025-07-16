function [cmcBetaPreNegTwoToZero_FDI, cmcBetaPreZeroToTwo_FDI, ...
          cmcBetaPostNegTwoToZero_FDI, cmcBetaPostZeroToTwo_FDI, ...
          cmcBetaFUNegTwoToZero_FDI, cmcBetaFUZeroToTwo_FDI, ...
          cmcBetaPreVibNegTwoToZero_FDI, cmcBetaPreVibZeroToTwo_FDI, ...
          cmcBetaPostVibNegTwoToZero_FDI, cmcBetaPostVibZeroToTwo_FDI, ...
          cmcBetaFUVibNegTwoToZero_FDI, cmcBetaFUVibZeroToTwo_FDI, ...
          lastRowNV_FDI, lastRowV_FDI] = ...
    sub_getCMC_FDI_Beta(dataCMCBetaNV_FDI, dataCMCBetaV_FDI, ...
    preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
    preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
    postIdxNV, postIdxV, pairsCmcChar, y)

% Pre NoVib
cmcBetaPreNegTwoToZero_FDI = dataCMCBetaNV_FDI{y}(4:3+preTrialsAvailableNV, 36:43);
cmcBetaPreNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcBetaPreZeroToTwo_FDI = dataCMCBetaNV_FDI{y}(4:3+preTrialsAvailableNV, 54:61);
cmcBetaPreZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% Post NoVib
cmcBetaPostNegTwoToZero_FDI = dataCMCBetaNV_FDI{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
cmcBetaPostNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcBetaPostZeroToTwo_FDI = dataCMCBetaNV_FDI{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
cmcBetaPostZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% FU NoVib
lastRowNV_FDI = size(dataCMCBetaNV_FDI{y}, 1);
cmcBetaFUNegTwoToZero_FDI = dataCMCBetaNV_FDI{y}(lastRowNV_FDI-fuTrialsAvailableNV+1:lastRowNV_FDI, 36:43);
cmcBetaFUNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcBetaFUZeroToTwo_FDI = dataCMCBetaNV_FDI{y}(lastRowNV_FDI-fuTrialsAvailableNV+1:lastRowNV_FDI, 54:61);
cmcBetaFUZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% Pre Vib
cmcBetaPreVibNegTwoToZero_FDI = dataCMCBetaV_FDI{y}(4:3+preTrialsAvailableV, 36:43);
cmcBetaPreVibNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcBetaPreVibZeroToTwo_FDI = dataCMCBetaV_FDI{y}(4:3+preTrialsAvailableV, 54:61);
cmcBetaPreVibZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% Post Vib
cmcBetaPostVibNegTwoToZero_FDI = dataCMCBetaV_FDI{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 36:43);
cmcBetaPostVibNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcBetaPostVibZeroToTwo_FDI = dataCMCBetaV_FDI{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 54:61);
cmcBetaPostVibZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% FU Vib
lastRowV_FDI = size(dataCMCBetaV_FDI{y}, 1);
cmcBetaFUVibNegTwoToZero_FDI = dataCMCBetaV_FDI{y}(lastRowV_FDI-fuTrialsAvailableV+1:lastRowV_FDI, 36:43);
cmcBetaFUVibNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcBetaFUVibZeroToTwo_FDI = dataCMCBetaV_FDI{y}(lastRowV_FDI-fuTrialsAvailableV+1:lastRowV_FDI, 54:61);
cmcBetaFUVibZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;
end