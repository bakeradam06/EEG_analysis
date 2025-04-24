function [cmcBetaPreNegTwoToZero_EDC, cmcBetaPreZeroToTwo_EDC, ...
          cmcBetaPostNegTwoToZero_EDC, cmcBetaPostZeroToTwo_EDC, ...
          cmcBetaFUNegTwoToZero_EDC, cmcBetaFUZeroToTwo_EDC, ...
          lastRowNV] = ...
    sub_getCMC_EDC_Beta(dataCMCBetaNV_EDC, ...
                            preTrialsAvailableNV, postTrialsAvailableNV, fuTrialsAvailableNV, ...
                            postIdxNV, pairsCmcChar, y)

    %% Pre
    cmcBetaPreNegTwoToZero_EDC = dataCMCBetaNV_EDC{y}(4:3+preTrialsAvailableNV, 36:43);
    cmcBetaPreNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;

    cmcBetaPreZeroToTwo_EDC = dataCMCBetaNV_EDC{y}(4:3+preTrialsAvailableNV, 54:61);
    cmcBetaPreZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;

    %% Post
    cmcBetaPostNegTwoToZero_EDC = dataCMCBetaNV_EDC{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 36:43);
    cmcBetaPostNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;

    cmcBetaPostZeroToTwo_EDC = dataCMCBetaNV_EDC{y}(postIdxNV:postIdxNV+postTrialsAvailableNV-1, 54:61);
    cmcBetaPostZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;

    %% FU
    lastRowNV = size(dataCMCBetaNV_EDC{y}, 1);

    cmcBetaFUNegTwoToZero_EDC = dataCMCBetaNV_EDC{y}(lastRowNV-fuTrialsAvailableNV+1:lastRowNV, 36:43);
    cmcBetaFUNegTwoToZero_EDC.Properties.VariableNames = pairsCmcChar;

    cmcBetaFUZeroToTwo_EDC = dataCMCBetaNV_EDC{y}(lastRowNV-fuTrialsAvailableNV+1:lastRowNV, 54:61);
    cmcBetaFUZeroToTwo_EDC.Properties.VariableNames = pairsCmcChar;
end