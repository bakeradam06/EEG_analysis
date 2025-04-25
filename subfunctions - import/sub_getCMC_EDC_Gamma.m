function [cmcGammaPreNegTwoToZero_EDC, cmcGammaPreZeroToTwo_EDC, ...
          cmcGammaPostNegTwoToZero_EDC, cmcGammaPostZeroToTwo_EDC, ...
          cmcGammaFUNegTwoToZero_EDC, cmcGammaFUZeroToTwo_EDC, ...
          cmcGammaPreVibNegTwoToZero_EDC, cmcGammaPreVibZeroToTwo_EDC, ...
          cmcGammaPostVibNegTwoToZero_EDC, cmcGammaPostVibZeroToTwo_EDC, ...
          cmcGammaFUVibNegTwoToZero_EDC, cmcGammaFUVibZeroToTwo_EDC, ...
          lastRowNV_EDC_Gamma, lastRowV_EDC_Gamma] = ...
    sub_getCMC_EDC_Gamma(dataCMCGammaNV_EDC, dataCMCGammaV_EDC, ...
    preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
    preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
    postIdxNV, postIdxV, pairsCmcChar, y)

% Pre NoVib
cmcGammaPreNegTwoToZero_EDC = dataCMCGammaNV_EDC{y}(4:3+preTrialsAvailableNV, 36:43);
cmcGammaPreNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;
cmcGammaPreZeroToTwo_EDC = dataCMCGammaNV_EDC{y}(4:3+preTrialsAvailableNV, 54:61);
cmcGammaPreZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;

% Post NoVib
cmcGammaPostNegTwoToZero_EDC = dataCMCGammaNV_EDC{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
cmcGammaPostNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;
cmcGammaPostZeroToTwo_EDC = dataCMCGammaNV_EDC{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
cmcGammaPostZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;

% FU NoVib
lastRowNV_EDC_Gamma = size(dataCMCGammaNV_EDC{y}, 1);
cmcGammaFUNegTwoToZero_EDC = dataCMCGammaNV_EDC{y}(lastRowNV_EDC_Gamma-fuTrialsAvailableNV+1:lastRowNV_EDC_Gamma, 36:43);
cmcGammaFUNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;
cmcGammaFUZeroToTwo_EDC = dataCMCGammaNV_EDC{y}(lastRowNV_EDC_Gamma-fuTrialsAvailableNV+1:lastRowNV_EDC_Gamma, 54:61);
cmcGammaFUZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;

% Pre Vib
cmcGammaPreVibNegTwoToZero_EDC = dataCMCGammaV_EDC{y}(4:3+preTrialsAvailableV, 36:43);
cmcGammaPreVibNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;
cmcGammaPreVibZeroToTwo_EDC = dataCMCGammaV_EDC{y}(4:3+preTrialsAvailableV, 54:61);
cmcGammaPreVibZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;

% Post Vib
cmcGammaPostVibNegTwoToZero_EDC = dataCMCGammaV_EDC{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 36:43);
cmcGammaPostVibNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;
cmcGammaPostVibZeroToTwo_EDC = dataCMCGammaV_EDC{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 54:61);
cmcGammaPostVibZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;

% FU Vib
lastRowV_EDC_Gamma = size(dataCMCGammaV_EDC{y}, 1);
cmcGammaFUVibNegTwoToZero_EDC = dataCMCGammaV_EDC{y}(lastRowV_EDC_Gamma-fuTrialsAvailableV+1:lastRowV_EDC_Gamma, 36:43);
cmcGammaFUVibNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;
cmcGammaFUVibZeroToTwo_EDC = dataCMCGammaV_EDC{y}(lastRowV_EDC_Gamma-fuTrialsAvailableV+1:lastRowV_EDC_Gamma, 54:61);
cmcGammaFUVibZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;

end