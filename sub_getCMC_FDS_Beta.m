function [cmcBetaPreNegTwoToZero_FDS, cmcBetaPreZeroToTwo_FDS, ...
          cmcBetaPostNegTwoToZero_FDS, cmcBetaPostZeroToTwo_FDS, ...
          cmcBetaFUNegTwoToZero_FDS, cmcBetaFUZeroToTwo_FDS, ...
          lastRowNV] = ...
    sub_getCMC_FDS_Beta(dataCMCBetaNV_FDS, ...
                            preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
                            postIdxNV, pairsCmcChar, y)

    %% Pre
    cmcBetaPreNegTwoToZero_FDS = dataCMCBetaNV_FDS{y}(4:3+preTrialsAvailableNV, 36:43);
    cmcBetaPreNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;

    cmcBetaPreZeroToTwo_FDS = dataCMCBetaNV_FDS{y}(4:3+preTrialsAvailableNV, 54:61);
    cmcBetaPreZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

    %% Post
    cmcBetaPostNegTwoToZero_FDS = dataCMCBetaNV_FDS{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
    cmcBetaPostNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;

    cmcBetaPostZeroToTwo_FDS = dataCMCBetaNV_FDS{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
    cmcBetaPostZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;

    %% FU
    lastRowNV = size(dataCMCBetaNV_FDS{y}, 1);

    cmcBetaFUNegTwoToZero_FDS = dataCMCBetaNV_FDS{y}(lastRowNV-fuTrialsAvailableNV+1:lastRowNV, 36:43);
    cmcBetaFUNegTwoToZero_FDS.Properties.VariableNames = pairsCmcChar;

    cmcBetaFUZeroToTwo_FDS = dataCMCBetaNV_FDS{y}(lastRowNV-fuTrialsAvailableNV+1:lastRowNV, 54:61);
    cmcBetaFUZeroToTwo_FDS.Properties.VariableNames = pairsCmcChar;
end