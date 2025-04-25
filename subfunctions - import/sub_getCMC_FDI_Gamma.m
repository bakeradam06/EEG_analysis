function [cmcGammaPreNegTwoToZero_FDI, cmcGammaPreZeroToTwo_FDI, ...
          cmcGammaPostNegTwoToZero_FDI, cmcGammaPostZeroToTwo_FDI, ...
          cmcGammaFUNegTwoToZero_FDI, cmcGammaFUZeroToTwo_FDI, ...
          cmcGammaPreVibNegTwoToZero_FDI, cmcGammaPreVibZeroToTwo_FDI, ...
          cmcGammaPostVibNegTwoToZero_FDI, cmcGammaPostVibZeroToTwo_FDI, ...
          cmcGammaFUVibNegTwoToZero_FDI, cmcGammaFUVibZeroToTwo_FDI, ...
          lastRowNV_FDI_Gamma, lastRowV_FDI_Gamma] = ...
    sub_getCMC_FDI_Gamma(dataCMCGammaNV_FDI, dataCMCGammaV_FDI, ...
    preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
    preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
    postIdxNV, postIdxV, pairsCmcChar, y)

% Pre NoVib
cmcGammaPreNegTwoToZero_FDI = dataCMCGammaNV_FDI{y}(4:3+preTrialsAvailableNV, 36:43);
cmcGammaPreNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcGammaPreZeroToTwo_FDI = dataCMCGammaNV_FDI{y}(4:3+preTrialsAvailableNV, 54:61);
cmcGammaPreZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% Post NoVib
cmcGammaPostNegTwoToZero_FDI = dataCMCGammaNV_FDI{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
cmcGammaPostNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcGammaPostZeroToTwo_FDI = dataCMCGammaNV_FDI{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
cmcGammaPostZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% FU NoVib
lastRowNV_FDI_Gamma = size(dataCMCGammaNV_FDI{y}, 1);
cmcGammaFUNegTwoToZero_FDI = dataCMCGammaNV_FDI{y}(lastRowNV_FDI_Gamma-fuTrialsAvailableNV+1:lastRowNV_FDI_Gamma, 36:43);
cmcGammaFUNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcGammaFUZeroToTwo_FDI = dataCMCGammaNV_FDI{y}(lastRowNV_FDI_Gamma-fuTrialsAvailableNV+1:lastRowNV_FDI_Gamma, 54:61);
cmcGammaFUZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% Pre Vib
cmcGammaPreVibNegTwoToZero_FDI = dataCMCGammaV_FDI{y}(4:3+preTrialsAvailableV, 36:43);
cmcGammaPreVibNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcGammaPreVibZeroToTwo_FDI = dataCMCGammaV_FDI{y}(4:3+preTrialsAvailableV, 54:61);
cmcGammaPreVibZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% Post Vib
cmcGammaPostVibNegTwoToZero_FDI = dataCMCGammaV_FDI{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 36:43);
cmcGammaPostVibNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcGammaPostVibZeroToTwo_FDI = dataCMCGammaV_FDI{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 54:61);
cmcGammaPostVibZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

% FU Vib
lastRowV_FDI_Gamma = size(dataCMCGammaV_FDI{y}, 1);
cmcGammaFUVibNegTwoToZero_FDI = dataCMCGammaV_FDI{y}(lastRowV_FDI_Gamma-fuTrialsAvailableV+1:lastRowV_FDI_Gamma, 36:43);
cmcGammaFUVibNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;
cmcGammaFUVibZeroToTwo_FDI = dataCMCGammaV_FDI{y}(lastRowV_FDI_Gamma-fuTrialsAvailableV+1:lastRowV_FDI_Gamma, 54:61);
cmcGammaFUVibZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

end