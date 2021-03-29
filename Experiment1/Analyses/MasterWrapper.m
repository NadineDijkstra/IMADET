%% Set paths etc
clear all;
restoredefaultpath;
addpath(genpath('Analyses'))
root = fullfile(cd,'Data');

dataFiles = str2fullfile(root,'sub*.mat');
nSubs     = length(dataFiles);

% inclusion info
sub_info    = zeros(nSubs,5);

%% Analyze the data
for sub = 1:nSubs
    
    fprintf('Processing sub %d out of %d \n',sub,nSubs)    
    
    %% Read in the data
    load(fullfile(root,sprintf('sub_%03d.mat',sub)),'data')
    
    %% Check data 
    % check accuracy and imagery check and decide upon exclusion
    [sub_info(sub,:),data] = check_data(data);    
    
    %% Analyse the data
    % calculate d' and criterion for included pps
    if sub_info(sub,1) == 1
    results = analyse_data(data);
    
    save(fullfile(root,sprintf('sub_%03d',sub)),'results','-append');
    clear results;
    end
    
end

%% Exclusion info
n_excl = sum(~sub_info(:,1));

fprintf('Excluded %d out of %d subjects \n',n_excl,nSubs)

%% Collect good data
incl_subs = find(sub_info(:,1)==1);
nSubs     = length(incl_subs);
group_results = cell(nSubs,1); group_data = cell(nSubs,1);
for sub = 1:nSubs
    load(fullfile(root,sprintf('sub_%03d',incl_subs(sub))),'results','data');
    group_results{sub} = results; clear results
    group_data{sub} = data; clear data
end

%% Plot the results
plot_results_multiple(group_results,sub_info);


