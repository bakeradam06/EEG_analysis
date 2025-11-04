
% ab created 10/31/25 to better organize main cmc data analysis script

% output: one table that contains all clinical data (WFMT, ARAT, FMA, BBT). 
% long format to enable statsitics, merge with ccc and cmc data later.

function [clinicalData] = sub_getClinicalData 

% create list of sheets to cycle though
sheetNames = {'WMFT time - FINAL','ARAT - FINAL'};
clinicalData = table(); % init

for sheet=1:length(sheetNames)
    tempData = readtable("TNT_allData_2025-10-31.xlsx", Sheet = sheetNames{sheet});
    
    switch sheet
        case 1 % wmft data, subjectId's, and session list
            % rename vars. same for below
            tempData = renamevars(tempData,["Var1", "Var2", "Var20", "Var21"], ...
                ["subject", "session", "WMFTavgHand", "WFMTavgTime"]);
            % remove vars we don't want
            colsToKeep = {'subject', 'session', 'WMFTavgHand', 'WFMTavgTime'};
            tempData = tempData(:,colsToKeep);
        case 2 % arat
            tempData = renamevars(tempData,"Var28", "ARATscore");
            colsToKeep = {'ARATscore'};
            % use 2 isntead of all because extra row at top. must match
            % wmft data above
            tempData = tempData(2:end,colsToKeep); 
                                % case 3 % fma
                                %     tempData = renamevars(tempData,["Var38", "Var39"], ...
                                %         ["FMAscore66", "FMAscore60"]);
                                %     colsToKeep = {"FMAscore66", "FMAscore60"};
                                %     tempData = tempData(:,colsToKeep);
                                % case 4 % bbt
                                %     tempData = renamevars(tempdata,["Var10","BBTaffected"]);
                                %     colsToKeep = {"BBTaffected"};
                                %     tempData = tempData(:,colsToKeep);
    end 
    clinicalData = [clinicalData, tempData];
end 
%% reformat subj naming convention in clinicalData
clinicalData.subject = regexprep(clinicalData.subject, '^TNT_0+', 'TNT'); 
d = strlength(clinicalData.subject) == 4;
clinicalData.subject(d) = regexprep(clinicalData.subject(d),'^TNT(\d)$','TNT0$1');
clinicalData.subject = string(clinicalData.subject);

% get unique subject id's
subjects = unique(clinicalData.subject);

% remove the unique entry in subjects 'days between wk6-FU'
strToRemove = 'days between Wk6-FU';
subjects(subjects == strToRemove) = [];
subjects(1) = []; % remove extra first row

% do same for clinicalData
clinicalData(clinicalData.subject == strToRemove,:) = [];
clinicalData(clinicalData.subject == "",:) = [];

timePoint = {'Pre', 'Post', 'FU'};

clear d strToRemove tempData

%% get BBT & NHPT data
% slightly more steps bc clinicalAssessments tab has phone call 1
% and phone call 2 rows. can't merge with WMFT and ARAT until this these are gone

% below comes from matlab import tool for ease

opts = spreadsheetImportOptions("NumVariables", 13);
% Specify sheet and range
opts.Sheet = "Clinical Assessments";
opts.DataRange = "A3:M739";
% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", ...
    "Var8", "Var9", "BBTaffected", "Var11", "Var12", "NHPTafffected"];
opts.SelectedVariableNames = ["Var1", "Var2", "BBTaffected", "NHPTafffected"];
opts.VariableTypes = ["categorical", "categorical", "char", "char", "char", ...
    "char", "char", "char", "char", "double", "char", "char", "double"];
% Specify variable properties
opts = setvaropts(opts, ["Var3", "Var4", "Var5", "Var6", "Var7", "Var8", ...
    "Var9", "Var11", "Var12"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", ...
    "Var7", "Var8", "Var9", "Var11", "Var12"], "EmptyFieldRule", "auto");
% Import the data
BBT_NHPT_data = readtable("TNT_AllData_2025-10-31.xlsx", opts, "UseExcel", false);

% clean up var
BBT_NHPT_data(1,:) = [];
BBT_NHPT_data = renamevars(BBT_NHPT_data, "Var1", "subject");
BBT_NHPT_data = renamevars(BBT_NHPT_data, "Var2", "session");
BBT_NHPT_data.subject = string(BBT_NHPT_data.subject);

%%
% fix naming convention (again)
BBT_NHPT_data.subject = regexprep(BBT_NHPT_data.subject, '^TNT_0+', 'TNT'); 
d = strlength(BBT_NHPT_data.subject) == 4;
BBT_NHPT_data.subject(d) = regexprep(BBT_NHPT_data.subject(d),'^TNT(\d)$','TNT0$1');
BBT_NHPT_data.subject = string(BBT_NHPT_data.subject);

clear opts sheet sheetNames

%% get rid of phone call rows. don't want them at all.

% care about everything but these. samee for below
rowsToKeep = ~ismember(BBT_NHPT_data.session,{'Call Wk 8','Call Wk 9'}); 
rowsToKeep2 = ~ismember(BBT_NHPT_data.subject,{'days between Wk6-FU',...
    'avg. days between wk6 - fu (days / weeks)', ...
    'min. days btwn wk6 - fu (days / weeks)',...
    'max. days btwn wk6 - fu (days/weeks)', ...
    'std. dev (s)'});
BBT_NHPT_data = BBT_NHPT_data(rowsToKeep,:);
BBT_NHPT_data = BBT_NHPT_data(rowsToKeep2,:);

clear rowsToKeep rowsToKeep2

%% obtain group allocation

groupAllocation = readtable('TNT_allData_2025-10-31.xlsx',Sheet = "GROUP ALLOCATION"); % ctrl=0 trt=1
groupAllocation.Properties.VariableNames(1:2) = ["subject","group"];

%% join clinicalData & NHPT/BBT data

% make sure subject is compatible with each other
clinicalData.subject = string(clinicalData.subject);
BBT_NHPT_data.subject = string(BBT_NHPT_data.subject);
groupAllocation.subject = string(groupAllocation.subject);
clinicalData.session = string(clinicalData.session);
BBT_NHPT_data.session = string(BBT_NHPT_data.session);
groupAllocation.subject = string(groupAllocation.subject);

%% merge WMFT/ARAT with BBT/NHPT & group allocation 

% check if subject, session identical. needs to be for join command.
if ~isequal(clinicalData.subject,BBT_NHPT_data.subject) % should return 1.
    disp('WARNING: clinical data subjectid and BBT_NHPT_data subject id not same.')
    return
end

if ~isequal(clinicalData.session,BBT_NHPT_data.session) % should also return 1.
    disp('WARNING: clinical data session and BBT_NHPT_data session not same.')
    return
end

% actual joining of two tables - NHPT/BBT with WMFT, ARAT
clinicalData = join(clinicalData, BBT_NHPT_data); 

%% do some checks. NHPT NaN's. have to work around since no NaN is 
% considered the same.
if ~all(isnan(clinicalData.NHPTafffected) == isnan(BBT_NHPT_data.NHPTafffected)) == 1
    disp('ERROR: NHPT NaNs are not the same. something is weird. check and correct')
    return 
end

% index the NaN's. find not NaN's. confirm non-NaN's are the same.
a = ~isnan(clinicalData.NHPTafffected); % not NaN's
b = ~isnan(BBT_NHPT_data.NHPTafffected);
noNaNa = clinicalData.NHPTafffected(a); % ID the values that aren't NaN
noNaNb = BBT_NHPT_data.NHPTafffected(b);

if ~isequal(noNaNa,noNaNb) % compare these values with each other.
    disp('ERROR: NHPT/BBT data did not join properly. check and correct')
    return
end

% aaaand same for bbt

% do some checks. BBT NaN's. have to work around since no NaN is 
% considered the same. therefore, isequal wouldnt work immediately.
if ~all(isnan(clinicalData.BBTaffected) == isnan(BBT_NHPT_data.BBTaffected)) == 1
    disp('ERROR: BBT NaNs are not the same. something is weird. check and correct')
    return 
end

% index the NaN's. find not NaN's. confirm non-NaN's are the same.
a = ~isnan(clinicalData.BBTaffected); % not NaN's
b = ~isnan(BBT_NHPT_data.BBTaffected);
noNaNa = clinicalData.BBTaffected(a); % ID the values that aren't NaN
noNaNb = BBT_NHPT_data.BBTaffected(b);

if ~isequal(noNaNa,noNaNb) % compare these values with each other.
    disp('ERROR: BBT data did not join properly. check and correct')
    return
end

clear a b noNaNa noNaNb BBT_NHPT_data colsToKeep subjects d

%% join group allocation
clinicalData = join(clinicalData, groupAllocation);

%% check to make sure groupAllcoation is correct compared to original import
u = unique(clinicalData(:,{'subject','group'}),'rows','stable');

assert(isequal(sort(u.subject),sort(groupAllocation.subject)) && ...
       isequal(sort(u.group),  sort(groupAllocation.group)), ...
       'Group‐allocation mismatch!');

timeLabelsCell = {'Pre','Post','Follow up'};
timeLabelsStr = ["Baseline","Post","FU"];

end