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
    if (data.main(t,5)==1 && data.main(t,6)==1) || ...
            (data.main(t,5)==0 && data.main(t,6)==0)
        B(t) = 1;
    elseif (data.main(t,5)==1 && data.main(t,6)==0) || ...
            (data.main(t,5)==0 && data.main(t,6)==1)
        B(t) = 0;
    end
end

% add one count to every cell
results.main_D = zeros(2,2);
results.main_C = zeros(2,2);
results.main_acc = zeros(2,2);
for i = 1:2 % imagery
    for b = 1:2 % base-rate
        trl_idx = data.main(:,2)==(i-1) & data.main(:,3)==(b-1);
        results.main_acc(i,b) = mean(data.main(trl_idx,5)==B(trl_idx));
        
        % hits
        hits = sum(B(trl_idx)==1 & data.main(trl_idx,5)==1);
        if hits == 0 % add count if 0
            hits = 0.5;
        elseif (hits/sum(data.main(trl_idx,5)==1))==1
            hits = hits -0.5;
        end
        H = hits/sum(data.main(trl_idx,5)==1);
        
        % FA's
        false_alarms = sum(B(trl_idx)==1 & data.main(trl_idx,5)==0);
        if false_alarms == 0 % add count if 0
            false_alarms = 0.5;
        elseif (false_alarms/sum(data.main(trl_idx,5)==0))==1
            false_alarms = false_alarms-0.5;
        end
        FA = false_alarms/sum(data.main(trl_idx,5)==0);
        
        [results.main_D(i,b),results.main_C(i,b)] = dprime(H,FA);
        results.main_FA(i,b) = FA;
        results.main_H(i,b) = H;
    end
end

% for all trials
results.gen_acc = mean(data.main(:,5)==B);

% hits
hits = sum(B==1 & data.main(:,5)==1);
if hits == 0 % add count if 0
    hits = 0.5;
elseif (hits/sum(data.main(:,5)==1))==1
    hits = hits -0.5;
end
H = hits/sum(data.main(:,5)==1);

% FA's
false_alarms = sum(B==1 & data.main(:,5)==0);
if false_alarms == 0 % add count if 0
    false_alarms = 0.5;
elseif (false_alarms/sum(data.main(:,5)==0))==1
    false_alarms = false_alarms-0.5;
end
FA = false_alarms/sum(data.main(:,5)==0);

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

%% Controls
%
% % C per block
% nTrls   = 35;
% nBlocks = length(data.main)/nTrls;
% results.C_pb = zeros(nBlocks,3);
% for b = 1:nBlocks
%
%     trl_idx = (b-1)*nTrls+1:nTrls*b;
%     results.C_pb(b,2) = data.main(trl_idx(1),2); % ima
%     results.C_pb(b,3) = data.main(trl_idx(1),3); % BR
%
%     % hits
%     hits = sum(B(trl_idx)==1 & data.main(trl_idx,5)==1);
%     if hits == 0 % add count if 0
%         hits = 0.5;
%     elseif (hits/sum(data.main(trl_idx,5)==1))==1
%         hits = hits -0.5;
%     end
%     H = hits/sum(data.main(trl_idx,5)==1);
%
%     % FA's
%     false_alarms = sum(B(trl_idx)==1 & data.main(trl_idx,5)==0);
%     if false_alarms == 0 % add count if 0
%         false_alarms = 0.5;
%     elseif (false_alarms/sum(data.main(trl_idx,5)==0))==1
%         false_alarms = false_alarms-0.5;
%     end
%     FA = false_alarms/sum(data.main(trl_idx,5)==0);
%
%     [~,results.C_pb(b,1)] = dprime(H,FA);
% end
