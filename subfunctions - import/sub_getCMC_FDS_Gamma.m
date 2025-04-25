function [cmcGammaPreNegTwoToZero_FDS, cmcGammaPreZeroToTwo_FDS, ...
          cmcGammaPostNegTwoToZero_FDS, cmcGammaPostZeroToTwo_FDS, ...
          cmcGammaFUNegTwoToZero_FDS, cmcGammaFUZeroToTwo_FDS, ...
          cmcGammaPreVibNegTwoToZero_FDS, cmcGammaPreVibZeroToTwo_FDS, ...
          cmcGammaPostVibNegTwoToZero_FDS, cmcGammaPostVibZeroToTwo_FDS, ...
          cmcGammaFUVibNegTwoToZero_FDS, cmcGammaFUVibZeroToTwo_FDS, ...
          lastRowNV_FDS_Gamma, lastRowV_FDS_Gamma] = ...
    sub_getCMC_FDS_Gamma(dataCMCGammaNV_FDS, dataCMCGammaV_FDS, ...
    preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
    preTrialsAvailableV, postTrialsAvailableV, fuTrialsAvailableV, ...
    postIdxNV, postIdxV, pairsCmcChar, y)

% Pre NoVib
cmcGammaPreNegTwoToZero_FDS = dataCMCGammaNV_FDS{y}(4:3+preTrialsAvailableNV, 36:43);
cmcGammaPreNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcGammaPreZeroToTwo_FDS = dataCMCGammaNV_FDS{y}(4:3+preTrialsAvailableNV, 54:61);
cmcGammaPreZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% Post NoVib
cmcGammaPostNegTwoToZero_FDS = dataCMCGammaNV_FDS{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
cmcGammaPostNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcGammaPostZeroToTwo_FDS = dataCMCGammaNV_FDS{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
cmcGammaPostZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% FU NoVib
lastRowNV_FDS_Gamma = size(dataCMCGammaNV_FDS{y}, 1);
cmcGammaFUNegTwoToZero_FDS = dataCMCGammaNV_FDS{y}(lastRowNV_FDS_Gamma-fuTrialsAvailableNV+1:lastRowNV_FDS_Gamma, 36:43);
cmcGammaFUNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcGammaFUZeroToTwo_FDS = dataCMCGammaNV_FDS{y}(lastRowNV_FDS_Gamma-fuTrialsAvailableNV+1:lastRowNV_FDS_Gamma, 54:61);
cmcGammaFUZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% Pre Vib
cmcGammaPreVibNegTwoToZero_FDS = dataCMCGammaV_FDS{y}(4:3+preTrialsAvailableV, 36:43);
cmcGammaPreVibNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcGammaPreVibZeroToTwo_FDS = dataCMCGammaV_FDS{y}(4:3+preTrialsAvailableV, 54:61);
cmcGammaPreVibZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% Post Vib
cmcGammaPostVibNegTwoToZero_FDS = dataCMCGammaV_FDS{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 36:43);
cmcGammaPostVibNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcGammaPostVibZeroToTwo_FDS = dataCMCGammaV_FDS{y}(postIdxV:postIdxV+postTrialsAvailableV-1, 54:61);
cmcGammaPostVibZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

% FU Vib
lastRowV_FDS_Gamma = size(dataCMCGammaV_FDS{y}, 1);
cmcGammaFUVibNegTwoToZero_FDS = dataCMCGammaV_FDS{y}(lastRowV_FDS_Gamma-fuTrialsAvailableV+1:lastRowV_FDS_Gamma, 36:43);
cmcGammaFUVibNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;
cmcGammaFUVibZeroToTwo_FDS = dataCMCGammaV_FDS{y}(lastRowV_FDS_Gamma-fuTrialsAvailableV+1:lastRowV_FDS_Gamma, 54:61);
cmcGammaFUVibZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

end