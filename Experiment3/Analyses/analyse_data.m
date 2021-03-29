function [results,B] = analyse_data(data)


% - staircase - %
nStairs = size(data.staircase,1);
results.staircase = zeros(nStairs,3);
for s = 1:nStairs
    results.staircase(s,1) = data.staircase{s,1};
    results.staircase(s,2) = data.staircase{s,2};
    results.staircase(s,3) = data.staircase{s,3};
    if s == (nStairs/2)+1
        results.staircase(s,1) = data.staircase{1,1};
    end
end

% - practice detection accuracy - %
results.dpAcc = mean(data.det_practice(:,1));

% - practice imagery vividness - %
results.diViv(1) = mean(data.ima_practice(data.ima_practice(:,1)==0,2));
results.diViv(2) = mean(data.ima_practice(data.ima_practice(:,1)==1,2));

% - main results - %
B = nan(size(data.main,1),1); % recode into say present | absent
for t = 1:size(data.main,1)
    if (data.main(t,4)==1 && data.main(t,5)==1) || ... % stim and true
            (data.main(t,4)==0 && data.main(t,5)==0) %  no-stim but false
        B(t) = 1;
    elseif (data.main(t,4)==1 && data.main(t,5)==0) || ... % no-stim but false
            (data.main(t,4)==0 && data.main(t,5)==1) % no-stim and true
        B(t) = 0;
    end
end

% recode condition indices 
idx{1} = data.main(:,2) == 0; % no imagery
idx{2} = (data.main(:,1)==1 & data.main(:,2) == 1) | ... % incongruent
            (data.main(:,1)==2 & data.main(:,2) == 2);
idx{3} = (data.main(:,1)==1 & data.main(:,2) == 2) | ... % congruent
            (data.main(:,1)==2 & data.main(:,2) == 1); 

% add one count to every cell
results.main_D = zeros(3,1);
results.main_C = zeros(3,1);
results.main_acc = zeros(3,1);
for c = 1:3 
        trl_idx = idx{c};
        results.main_acc(c) = mean(data.main(trl_idx,5));
        
        % hits
        hits = sum(B(trl_idx)==1 & data.main(trl_idx,4)==1);
        if hits == 0 % add count if 0
            hits = 0.5;
        elseif (hits/sum(data.main(trl_idx,4)==1))==1
            hits = hits -0.5;
        end
        H = hits/sum(data.main(trl_idx,4)==1);
        
        % FA's
        false_alarms = sum(B(trl_idx)==1 & data.main(trl_idx,4)==0);
        if false_alarms == 0 % add count if 0
            false_alarms = 0.5;
        elseif (false_alarms/sum(data.main(trl_idx,4)==0))==1
            false_alarms = false_alarms-0.5;
        end
        FA = false_alarms/sum(data.main(trl_idx,4)==0);
        
        [results.main_D(c),results.main_C(c)] = dprime(H,FA);
        results.main_FA(c) = FA;
        results.main_H(c) = H;
end

% for all trials
results.gen_acc = mean(data.main(:,5));

% hits
hits = sum(B==1 & data.main(:,4)==1);
if hits == 0 % add count if 0
    hits = 0.5;
elseif (hits/sum(data.main(:,4)==1))==1
    hits = hits -0.5;
end
H = hits/sum(data.main(:,4)==1);

% FA's
false_alarms = sum(B==1 & data.main(:,4)==0);
if false_alarms == 0 % add count if 0
    false_alarms = 0.5;
elseif (false_alarms/sum(data.main(:,4)==0))==1
    false_alarms = false_alarms-0.5;
end
FA = false_alarms/sum(data.main(:,4)==0);

[results.gen_D,results.gen_C] = dprime(H,FA);
results.gen_FA = FA;
results.geb_H = H;


% -- debrief questions -- %
results.age = data.age;
results.gender = data.gender;
results.country = data.country;
results.ima_check = data.ima_check;
results.ima_influence = data.ima_influence;
results.comments = data.comments;

