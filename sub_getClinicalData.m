
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

timePoint = {"Pre","Post","FU"};
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

rowsToKeep = ~ismember(BBT_NHPT_data.session,{'Call Wk 8','Call Wk 9'}); % care about everything but these 
BBT_NHPT_data = BBT_NHPT_data(rowsToKeep,:);

clear rowsToKeep

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

%%


%%%%% ERROR: fix this PART
clinicalData2 = innerjoin(clinicalData, BBT_NHPT_data,'Keys','subject','Keys','session'); % this is wrong, but had to quit it for today. 






%%
% join will automatically replicate each subject's "group" for all of their sessions
clinicalData = innerjoin(clinicalData, groupAllocation, 'Keys', {'subject'},{'session'});

% reformat the subjID's of clinicalData
clinicalData.subject = regexprep(clinicalData.subject, '^TNT_0+', 'TNT'); % reformat the naming in clinicalData
d = strlength(clinicalData.subject) == 4;
clinicalData.subject(d) = regexprep(clinicalData.subject(d),'^TNT(\d)$','TNT0$1');
clinicalData.subject = string(clinicalData.subject);

%% check to make sure groupAllcoation is correct compared to original import
u = unique(clinicalData(:,{'subject','group'}),'rows','stable');

assert(isequal(sort(u.subject),sort(groupAllocation.subject)) && ...
       isequal(sort(u.group),  sort(groupAllocation.group)), ...
       'Group‐allocation mismatch!');

timeLabelsCell = {'Pre','Post','Follow up'};
timeLabelsStr = ["Baseline","Post","FU"];


clear Pre Post FU timePoint wolfTime subjID currentID sirius scabbers u

end