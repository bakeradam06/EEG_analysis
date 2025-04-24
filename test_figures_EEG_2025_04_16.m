% time = 1:100;  % your time vector
% eegMetric = randn(1, 100);  % example EEG metric (e.g., power)
% motorScore = linspace(50, 30, 100);  % example motor score, perhaps lower scores indicate improvement
% 
% figure;
% yyaxis left
% plot(time, eegMetric, 'b-', 'LineWidth', 1.5);
% ylabel('EEG Metric');
% 
% yyaxis right
% plot(time, motorScore, 'r--', 'LineWidth', 1.5);
% ylabel('Motor Score');
% 
% xlabel('Time (s)');
% title('EEG Metric and Motor Improvement Over Time');
% legend('EEG Power', 'Motor Score');


%%
% Example data (replace with your computed averages)
timePoints = [1 2 3]; % Pre, Post, FU
avgCoherence = [0.35, 0.42, 0.40];    % average coherence for a given region pair
motorScore   = [80, 65, 70];           % motor performance score (e.g., lower score means better outcome)

figure;
yyaxis left
plot(timePoints, avgCoherence, '-o', 'LineWidth', 2);
ylabel('Avg Coherence');
hold on;

yyaxis right
plot(timePoints, motorScore, '--s', 'LineWidth', 2);
ylabel('Motor Score');
xlabel('Time (1=Pre, 2=Post, 3=FU)');
title('Coherence and Motor Recovery over Time');
legend('Avg Coherence', 'Motor Score');

%%
% Example change scores (replace with your computed values)
deltaCoherence = [0.07, -0.05];  % For each subject/region pair: (Post - Pre)
deltaMotor     = [-15, 10];       % Corresponding change in motor score (Pre - Post, if lower is better)

% Scatter plot
figure;
scatter(deltaCoherence, deltaMotor, 50, 'filled');
xlabel('Change in Coherence (Post-Pre)');
ylabel('Change in Motor Score (Pre-Post)');
title('Relationship between Coherence Change and Motor Recovery');

% Fit a linear regression model (optional)
mdl = fitlm(deltaCoherence, deltaMotor);
hold on;
plot(mdl);
legend('Data Points','Regression Line','95% Confidence Interval');

%% Simulate sample output table for group-level coherence data
% Define simulation parameters:
regionPairs = ["M1L-M1N", "PML-S1L", "S1L-S1N", "M1L-S1L"];  % example region pairs
timePoints = ["Pre"; "Post"; "FU"];
nPairs = numel(regionPairs);
nTime = numel(timePoints);
nSubjects = 5;  % number of subjects in simulated data

% Preallocate arrays:
subjectIDs   = strings(nSubjects * nPairs * nTime, 1);
regionPairList = strings(nSubjects * nPairs * nTime, 1);
timePointList  = strings(nSubjects * nPairs * nTime, 1);
PreCoh = nan(nSubjects * nPairs * nTime, 1);
PostCoh = nan(nSubjects * nPairs * nTime, 1);
FUCoh = nan(nSubjects * nPairs * nTime, 1);

% Fill in simulated data:
counter = 1;
for s = 1:nSubjects
    for r = 1:nPairs
        for t = 1:nTime
            subjectIDs(counter) = "Subject" + string(s);
            regionPairList(counter) = regionPairs(r);
            timePointList(counter) = timePoints(t);
            % Simulate coherence values as random numbers between 0.2 and 0.8
            PreCoh(counter) = 0.2 + 0.6 * rand();
            PostCoh(counter) = 0.2 + 0.6 * rand();
            FUCoh(counter) = 0.2 + 0.6 * rand();
            counter = counter + 1;
        end
    end
end

% Create the simulated table (outputCohAll)
outputCohAll = table(subjectIDs, regionPairList, timePointList, PreCoh, PostCoh, FUCoh, ...
    'VariableNames', {'subjectID', 'regionPair', 'timePoint', 'PreCoh', 'PostCoh', 'FUCoh'});

% Display the simulated data (first 10 rows)
disp('Simulated outputCohAll Table:');
disp(outputCohAll(1:10,:));

% Compute difference scores and percent changes (using Pre as the baseline)
outputCohAll.dPrePost = outputCohAll.PostCoh - outputCohAll.PreCoh;
outputCohAll.dPreFU   = outputCohAll.FUCoh  - outputCohAll.PreCoh;
outputCohAll.dPrePostPct = (outputCohAll.dPrePost ./ outputCohAll.PreCoh) * 100;
outputCohAll.dPreFUPct   = (outputCohAll.dPreFU   ./ outputCohAll.PreCoh) * 100;

disp('Output Table after adding difference scores:');
disp(outputCohAll(1:10,:));

% Compute a group summary across subjects, per region pair and time point
% (This uses groupsummary to average across subjects for each unique combination)
groupSummary = groupsummary(outputCohAll, {'regionPair', 'timePoint'}, 'mean', ...
    {'PreCoh','PostCoh','FUCoh','dPrePost','dPreFU','dPrePostPct','dPreFUPct'});

disp('Group Summary (mean values) across region pair and time point:');
disp(groupSummary);

% Plotting

% Option 1: Grouped Bar Chart for the Mean Coherence Values by Region Pair
% For each region pair, we want to show the mean Pre, Post and FU coherence.
uniquePairs = unique(groupSummary.regionPair);
nUniquePairs = numel(uniquePairs);
meanPre = zeros(nUniquePairs, 1);
meanPost = zeros(nUniquePairs, 1);
meanFU = zeros(nUniquePairs, 1);
for i = 1:nUniquePairs
    % Extract the rows for the current region pair
    idxPre = strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "Pre");
    idxPost = strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "Post");
    idxFU = strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "FU");
    
    if any(idxPre)
        meanPre(i) = groupSummary.mean_PreCoh(idxPre);
    end
    if any(idxPost)
        meanPost(i) = groupSummary.mean_PostCoh(idxPost);
    end
    if any(idxFU)
        meanFU(i) = groupSummary.mean_FUCoh(idxFU);
    end
end

% Create a categorical array for the x-axis
X = categorical(uniquePairs);
X = reordercats(X, uniquePairs);
Y = [meanPre, meanPost, meanFU];

figure;
bar(X, Y)
xlabel('Region Pair')
ylabel('Mean Coherence')
title('Group Mean Coherence by Region Pair and Time Point')
legend('Pre','Post','FU','Location','Best')

% Option 2: Line Plot of the Group Means Over Time for Each Region Pair
figure;
colors = lines(nUniquePairs);
hold on;
for i = 1:nUniquePairs
    % For each region pair, extract mean values in the order: Pre, Post, FU
    meanValues = [groupSummary.mean_PreCoh(strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "Pre")), ...
                  groupSummary.mean_PostCoh(strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "Post")), ...
                  groupSummary.mean_FUCoh(strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "FU"))];
    plot(1:3, meanValues, '-o', 'Color', colors(i,:), 'LineWidth', 2, 'DisplayName', uniquePairs(i));
end
set(gca, 'XTick', 1:3, 'XTickLabel', {'Pre','Post','FU'});
xlabel('Time Point')
ylabel('Mean Coherence')
title('Group Mean Coherence Trends Over Time by Region Pair')
legend('Location','Best')
hold off;

% %% Save the simulated output table and group summary for later use
% writetable(outputCohAll, 'simulated_outputCohAll.csv');
% writetable(groupSummary, 'simulated_groupSummary.csv');



%% SIMULATE SAMPLE OUTPUT TABLE (using your previous simulation code)
% Define simulation parameters:
regionPairs = ["M1L-M1N", "PML-S1L", "S1L-S1N", "M1L-S1L"];  % example region pairs
timePoints = ["Pre"; "Post"; "FU"];
nPairs = numel(regionPairs);
nTime = numel(timePoints);
nSubjects = 5;  % number of subjects in simulated data

% Preallocate arrays:
subjectIDs   = strings(nSubjects * nPairs * nTime, 1);
regionPairList = strings(nSubjects * nPairs * nTime, 1);
timePointList  = strings(nSubjects * nPairs * nTime, 1);
PreCoh = nan(nSubjects * nPairs * nTime, 1);
PostCoh = nan(nSubjects * nPairs * nTime, 1);
FUCoh = nan(nSubjects * nPairs * nTime, 1);

% Fill in simulated data
counter = 1;
for s = 1:nSubjects
    for r = 1:nPairs
        for t = 1:nTime
            subjectIDs(counter) = "Subject" + string(s);
            regionPairList(counter) = regionPairs(r);
            timePointList(counter) = timePoints(t);
            % Simulate coherence values as random numbers between 0.2 and 0.8.
            PreCoh(counter) = 0.2 + 0.6 * rand();
            PostCoh(counter) = 0.2 + 0.6 * rand();
            FUCoh(counter) = 0.2 + 0.6 * rand();
            counter = counter + 1;
        end
    end
end

% Create the simulated table
outputCohAll = table(subjectIDs, regionPairList, timePointList, PreCoh, PostCoh, FUCoh, ...
    'VariableNames', {'subjectID', 'regionPair', 'timePoint', 'PreCoh', 'PostCoh', 'FUCoh'});

% Compute difference scores and percent changes (using Pre as the baseline)
outputCohAll.dPrePost = outputCohAll.PostCoh - outputCohAll.PreCoh;
outputCohAll.dPreFU   = outputCohAll.FUCoh - outputCohAll.PreCoh;
outputCohAll.dPrePostPct = (outputCohAll.dPrePost ./ outputCohAll.PreCoh) * 100;
outputCohAll.dPreFUPct   = (outputCohAll.dPreFU ./ outputCohAll.PreCoh) * 100;

% Create a group summary (averaging across subjects) using groupsummary
groupSummary = groupsummary(outputCohAll, {'regionPair', 'timePoint'}, 'mean', ...
    {'PreCoh','PostCoh','FUCoh','dPrePost','dPreFU','dPrePostPct','dPreFUPct'});

% Visualization Option 1: Grouped Bar Chart (already provided)
uniquePairs = unique(groupSummary.regionPair);
nUniquePairs = numel(uniquePairs);
meanPre = zeros(nUniquePairs, 1);
meanPost = zeros(nUniquePairs, 1);
meanFU = zeros(nUniquePairs, 1);
for i = 1:nUniquePairs
    idxPre = strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "Pre");
    idxPost = strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "Post");
    idxFU = strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "FU");
    if any(idxPre)
        meanPre(i) = groupSummary.mean_PreCoh(idxPre);
    end
    if any(idxPost)
        meanPost(i) = groupSummary.mean_PostCoh(idxPost);
    end
    if any(idxFU)
        meanFU(i) = groupSummary.mean_FUCoh(idxFU);
    end
end
X = categorical(uniquePairs);
X = reordercats(X, uniquePairs);
Y = [meanPre, meanPost, meanFU];
figure;
bar(X, Y)
xlabel('Region Pair')
ylabel('Mean Coherence')
title('Group Mean Coherence by Region Pair and Time Point')
legend('Pre','Post','FU','Location','Best')

% Visualization Option 2: Line Plot of Group Means Over Time
figure;
colors = lines(nUniquePairs);
hold on;
for i = 1:nUniquePairs
    % For each region pair, extract group mean values in the order Pre, Post, FU
    meanValues = [groupSummary.mean_PreCoh(strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "Pre")), ...
                  groupSummary.mean_PostCoh(strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "Post")), ...
                  groupSummary.mean_FUCoh(strcmp(groupSummary.regionPair, uniquePairs(i)) & strcmp(groupSummary.timePoint, "FU"))];
    plot(1:3, meanValues, '-o', 'Color', colors(i,:), 'LineWidth', 2, 'DisplayName', uniquePairs(i));
end
set(gca, 'XTick', 1:3, 'XTickLabel', {'Pre','Post','FU'});
xlabel('Time Point')
ylabel('Mean Coherence')
title('Group Mean Coherence Trends Over Time by Region Pair')
legend('Location','Best')
hold off;

% Visualization Option 3: Scatter Plot of Individual Subject Values with Jitter
% Here we plot individual subject coherence values for each region pair and time point.
figure;
hold on;
uniqueTime = unique(outputCohAll.timePoint);
% Create a numeric mapping for time points: Pre=1, Post=2, FU=3
timeNumeric = zeros(height(outputCohAll),1);
for i = 1:height(outputCohAll)
    switch outputCohAll.timePoint{i}
        case 'Pre'
            timeNumeric(i) = 1;
        case 'Post'
            timeNumeric(i) = 2;
        case 'FU'
            timeNumeric(i) = 3;
    end
end

% Use different colors for each region pair
colorMap = lines(nUniquePairs);
for i = 1:nUniquePairs
    idx = strcmp(outputCohAll.regionPair, uniquePairs(i));
    % Add a small random jitter to the timeNumeric values to prevent overlapping points
    jitteredTime = timeNumeric(idx) + (rand(sum(idx),1)-0.5)*0.1;
    scatter(jitteredTime, outputCohAll.PreCoh(idx), 50, 'MarkerEdgeColor', colorMap(i,:), 'DisplayName', uniquePairs(i));
end
xlabel('Time (1=Pre, 2=Post, 3=FU)')
ylabel('Pre Coherence Values')
title('Scatter Plot of Individual Pre Coherence Values by Region Pair')
legend('Location','Best')
hold off;

% Visualization Option 4: Box Plot for Coherence Differences (e.g., dPrePost)
% This shows the distribution of the pre-to-post change for each region pair.
figure;
boxplot(outputCohAll.dPrePost, outputCohAll.regionPair)
xlabel('Region Pair')
ylabel('dPrePost (Post - Pre)')
title('Box Plot of Pre-to-Post Coherence Changes by Region Pair')
% 
% %% Optional: Save the simulated tables and plots to files
% writetable(outputCohAll, 'simulated_outputCohAll.csv');
% writetable(groupSummary, 'simulated_groupSummary.csv');