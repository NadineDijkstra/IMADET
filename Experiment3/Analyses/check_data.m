function [info,data,block_info] = check_data(data)

% details
nBlocks = 12;
nTrials = length(data.main)/nBlocks;
acc     = [0.5 0.99];

% collect information per block
block_info = zeros(nBlocks,4);
ima         = 1; % no - congr - incongr
ima_check   = 2; 
det_acc     = 3;
excl        = 4;

data.main_excl = zeros(length(data.main),1); % include or exclude trial

for b = 1:nBlocks
    idx = (b-1)*nTrials+1:b*nTrials;
    
    if data.main(idx(1),2)==0; block_info(b,ima) = 0; % no imagery 
    elseif (data.main(idx(1),1)==1 && data.main(idx(1),2) == 1) || ...
            (data.main(idx(1),1)==2 && data.main(idx(1),2) == 2)
        block_info(b,ima) = 1; % congruent
    elseif (data.main(idx(1),1)==1 && data.main(idx(1),2) == 2) || ...
            (data.main(idx(1),1)==2 && data.main(idx(1),2) == 1)
        block_info(b,ima) = 2; % incongruent
    end        
    
    % imagery check accuracy
    if sum(data.main(idx,7))==nTrials 
        block_info(b,ima_check) = 1;
    else % ima check incorrect 
        block_info(b,excl) = 1;
        data.main_excl(idx) = 1;
    end
    
    % detection accuracy
    block_info(b,det_acc) = mean(data.main(idx,5));
    if block_info(b,det_acc) < acc(1) || block_info(b,det_acc) >= acc(2)
        block_info(b,excl) = 1;
        data.main_excl(idx) = 1;
    end
end

% info
info = zeros(1,7);
incl            = 1;
n_blocks_ni = 2;
n_blocks_ci = 3;
n_blocks_ii = 4;
e_det_acc   = 5;
e_ima_acc   = 6;

info(n_blocks_ni) = sum(block_info(:,ima)==0 & block_info(:,excl) == 0);
info(n_blocks_ci) = sum(block_info(:,ima)==1 & block_info(:,excl) == 0);
info(n_blocks_ii) = sum(block_info(:,ima)==2 & block_info(:,excl) == 0);
info(e_det_acc)   = mean(block_info(:,det_acc));
info(e_ima_acc)   = sum(block_info(:,ima_check)==0);

if info(n_blocks_ni) >= 2 && info(n_blocks_ci) >= 2 &&...
        info(n_blocks_ii) >= 2 && (info(e_det_acc) < acc(2) && info(e_det_acc) > acc(1))
    info(incl) = 1;
end

% exclude specified blocks
data.main = data.main(~data.main_excl,:);

