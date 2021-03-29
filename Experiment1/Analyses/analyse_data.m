function [results,B] = analyse_data(data)

% - VVIQ - %
results.VVIQ = mean(data.VVIQ);

% - LHS - %
results.LHS_A = mean(data.LHS(1:5));
results.LHS_V = mean(data.LHS(6:9));

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
   if (data.main(t,4)==1 && data.main(t,5)==1) || ...
           (data.main(t,4)==0 && data.main(t,5)==0)
        B(t) = 1;
   elseif (data.main(t,4)==1 && data.main(t,5)==0) || ...
           (data.main(t,4)==0 && data.main(t,5)==1)
        B(t) = 0;
   end 
end

% SDT measures
% add one count to every cell
results.main_D = zeros(2,1); 
results.main_C = zeros(2,1);
results.main_acc = zeros(2,1);
results.RT = zeros(2,2,2); % hits - FA ; misses - CR
for i = 1:2
    trl_idx = data.main(:,2)==(i-1);
    results.main_acc(i) = mean(data.main(trl_idx,4)==B(trl_idx));
    
    % hits
    hit_idx = B(trl_idx)==1 & data.main(trl_idx,4)==1;
    miss_idx = B(trl_idx)==0 & data.main(trl_idx,4)==1;
    hits = sum(hit_idx);
    if hits == 0 % add count if 0
        hits = 0.5;
    elseif (hits/sum(data.main(trl_idx,4)==1))==1
        hits = hits -0.5;
    end
    H = hits/sum(data.main(trl_idx,4)==1);
    
    results.RT(1,1,i) = mean(data.main(hit_idx,3));
    results.RT(2,1,i) = mean(data.main(miss_idx,3));
    
    % FA's
    FA_idx = B(trl_idx)==1 & data.main(trl_idx,4)==0;
    CR_idx = B(trl_idx)==0 & data.main(trl_idx,4)==0;
    false_alarms = sum(FA_idx);
    if false_alarms == 0 % add count if 0 
        false_alarms = 0.5;
    elseif (false_alarms/sum(data.main(trl_idx,4)==0))==1
        false_alarms = false_alarms-0.5;
    end
    FA = false_alarms/sum(data.main(trl_idx,4)==0);    
    
    [results.main_D(i),results.main_C(i)] = dprime(H,FA);
    results.main_FA(i) = FA;
    results.main_H(i) = H;
    
    results.RT(1,2,i) = mean(data.main(FA_idx,3));
    results.RT(2,2,i) = mean(data.main(CR_idx,3));
end


