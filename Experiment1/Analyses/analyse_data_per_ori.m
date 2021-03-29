function [results,B] = analyse_data_per_ori(data)

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

results.main_D = zeros(2,2); % stim by ima
results.main_C = zeros(2,2);
results.main_acc = zeros(2,2);
for s = 1:2
    for i = 1:2
        trl_idx = data.main(:,1)==(s-1) & data.main(:,2)==(i-1);
        results.main_acc(s,i) = mean(data.main(trl_idx,4)==B(trl_idx));
        H = sum(B==1 & data.main(:,4)==1 & trl_idx)/sum(data.main(:,4)==1 & trl_idx);
        FA = sum(B==1 & data.main(:,4)==0 & trl_idx)/sum(data.main(:,4)==0 & trl_idx);
        [results.main_D(s,i),results.main_C(s,i)] = dprime(H,FA);
        results.main_FA(s,i) = FA;
        results.main_H(s,i) = H;
    end
end

results.main_ima_acc = sum(data.main(:,6))/length(data.main);

% acc by block
nBlocks = length(data.main)/24; nTrls = 24;
results.acc_pb  = nan(nBlocks,1);
for b = 1:nBlocks
    idx = (b-1)*nTrls+1:b*nTrls;
    results.acc_pb(b) = mean(data.main(idx,4)==B(idx));    
end

