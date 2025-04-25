function [cmcGammaPreNegTwoToZero_APB, cmcGammaPreZeroToTwo_APB, ...
          cmcGammaPostNegTwoToZero_APB, cmcGammaPostZeroToTwo_APB, ...
          cmcGammaFUNegTwoToZero_APB, cmcGammaFUZeroToTwo_APB, ...
          cmcGammaPreVibNegTwoToZero_APB, cmcGammaPreVibZeroToTwo_APB, ...
          cmcGammaPostVibNegTwoToZero_APB, cmcGammaPostVibZeroToTwo_APB, ...
          cmcGammaFUVibNegTwoToZero_APB, cmcGammaFUVibZeroToTwo_APB, ...
          lastRowNV_APB_Gamma, lastRowV_APB_Gamma] = ...
    sub_getCMC_APB_Gamma(dataCMCGammaNV_APB, dataCMCGammaV_APB, ...
    preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
    preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
    postIdxNV, postIdxV, pairsCmcChar, y)

% Pre NoVib
cmcGammaPreNegTwoToZero_APB = dataCMCGammaNV_APB{y}(4:3+preTrialsAvailableNV, 36:43);
cmcGammaPreNegTwoToZero_APB.Properties.VariableNames = pairsCmcChar;
cmcGammaPreZeroToTwo_APB = dataCMCGammaNV_APB{y}(4:3+preTrialsAvailableNV, 54:61);
cmcGammaPreZeroToTwo_APB.Properties.VariableNames = pairsCmcChar;

% Post NoVib
cmcGammaPostNegTwoToZero_APB = dataCMCGammaNV_APB{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
cmcGammaPostNegTwoToZero_APB.Properties.VariableNames = pairsCmcChar;
cmcGammaPostZeroToTwo_APB = dataCMCGammaNV_APB{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
cmcGammaPostZeroToTwo_APB.Properties.VariableNames = pairsCmcChar;

% FU NoVib
lastRowNV_APB_Gamma = size(dataCMCGammaNV_APB{y}, 1);
cmcGammaFUNegTwoToZero_APB = dataCMCGammaNV_APB{y}(lastRowNV_APB_Gamma-fuTrialsAvailableNV+1:lastRowNV_APB_Gamma, 36:43);
cmcGammaFUNegTwoToZero_APB.Properties.VariableNames = pairsCmcChar;
cmcGammaFUZeroToTwo_APB = dataCMCGammaNV_APB{y}(lastRowNV_APB_Gamma-fuTrialsAvailableNV+1:lastRowNV_APB_Gamma, 54:61);
cmcGammaFUZeroToTwo_APB.Properties.VariableNames = pairsCmcChar;

% Pre Vib
cmcGammaPreVibNegTwoToZero_APB = dataCMCGammaV_APB{y}(4:3+preTrialsAvailableV, 36:43);
cmcGammaPreVibNegTwoToZero_APB.Properties.VariableNames = pairsCmcChar;
cmcGammaPreVibZeroToTwo_APB = dataCMCGammaV_APB{y}(4:3+preTrialsAvailableV, 54:61);
cmcGammaPreVibZeroToTwo_APB.Properties.VariableNames = pairsCmcChar;

% Post Vib
cmcGammaPostVibNegTwoToZero_APB = dataCMCGammaV_APB{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 36:43);
cmcGammaPostVibNegTwoToZero_APB.Properties.VariableNames = pairsCmcChar;
cmcGammaPostVibZeroToTwo_APB = dataCMCGammaV_APB{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 54:61);
cmcGammaPostVibZeroToTwo_APB.Properties.VariableNames = pairsCmcChar;

% FU Vib
lastRowV_APB_Gamma = size(dataCMCGammaV_APB{y}, 1);
cmcGammaFUVibNegTwoToZero_APB = dataCMCGammaV_APB{y}(lastRowV_APB_Gamma-fuTrialsAvailableV+1:lastRowV_APB_Gamma, 36:43);
cmcGammaFUVibNegTwoToZero_APB.Properties.VariableNames = pairsCmcChar;
cmcGammaFUVibZeroToTwo_APB = dataCMCGammaV_APB{y}(lastRowV_APB_Gamma-fuTrialsAvailableV+1:lastRowV_APB_Gamma, 54:61);
cmcGammaFUVibZeroToTwo_APB.Properties.VariableNames = pairsCmcChar;

end