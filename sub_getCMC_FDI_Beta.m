function [cmcBetaPreNegTwoToZero_FDI, cmcBetaPreZeroToTwo_FDI, ...
          cmcBetaPostNegTwoToZero_FDI, cmcBetaPostZeroToTwo_FDI, ...
          cmcBetaFUNegTwoToZero_FDI, cmcBetaFUZeroToTwo_FDI, ...
          lastRowNV] = ...
    sub_getCMC_FDI_Beta(dataCMCBetaNV_FDI, ...
                            preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
                            postIdxNV, pairsCmcChar, y)

    %% Pre
    cmcBetaPreNegTwoToZero_FDI = dataCMCBetaNV_FDI{y}(4:3+preTrialsAvailableNV, 36:43);
    cmcBetaPreNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;

    cmcBetaPreZeroToTwo_FDI = dataCMCBetaNV_FDI{y}(4:3+preTrialsAvailableNV, 54:61);
    cmcBetaPreZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

    %% Post
    cmcBetaPostNegTwoToZero_FDI = dataCMCBetaNV_FDI{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
    cmcBetaPostNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;

    cmcBetaPostZeroToTwo_FDI = dataCMCBetaNV_FDI{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
    cmcBetaPostZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;

    %% FU
    lastRowNV = size(dataCMCBetaNV_FDI{y}, 1);

    cmcBetaFUNegTwoToZero_FDI = dataCMCBetaNV_FDI{y}(lastRowNV-fuTrialsAvailableNV+1:lastRowNV, 36:43);
    cmcBetaFUNegTwoToZero_FDI.Properties.VariableNames = pairsCmcChar;

    cmcBetaFUZeroToTwo_FDI = dataCMCBetaNV_FDI{y}(lastRowNV-fuTrialsAvailableNV+1:lastRowNV, 54:61);
    cmcBetaFUZeroToTwo_FDI.Properties.VariableNames = pairsCmcChar;
end