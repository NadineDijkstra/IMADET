function [info,data] = check_data(data)

% details
nBlocks = 8;
nTrials = length(data.main)/nBlocks;
acc     = [0.5 0.99];

% collect information per block
block_info = zeros(nBlocks,5);
ima         = 1;
ima_check   = 2;
high_br     = 3;
det_acc     = 4;
excl        = 5;

data.main_excl = zeros(length(data.main),1); % include or exclude trial

for b = 1:nBlocks
    idx = (b-1)*nTrials+1:b*nTrials;
    
    if sum(data.main(idx,2))==nTrials; block_info(b,ima) = 1; end
    if sum(data.main(idx,3))==nTrials; block_info(b,high_br) = 1; end
    
    % imagery check accuracy
    if sum(data.main(idx,7))==nTrials 
        block_info(b,ima_check) = 1;
    else % ima check incorrect 
        block_info(b,excl) = 1;
        data.main_excl(idx) = 1;
    end
    
    % detection accuracy
    block_info(b,det_acc) = mean(data.main(idx,6));
    if block_info(b,det_acc) < acc(1) || block_info(b,det_acc) >= acc(2)
        block_info(b,excl) = 1;
        data.main_excl(idx) = 1;
    end
end

% info
info = zeros(1,7);
incl            = 1;
n_blocks_im_lbr = 2;
n_blocks_im_hbr = 3;
n_blocks_ni_lbr = 4;
n_blocks_ni_hbr = 5;
e_det_acc       = 6;
e_ima_acc       = 7;

info(n_blocks_im_lbr) = sum(block_info(:,ima)==1 & block_info(:,high_br)==0 & block_info(:,excl) == 0);
info(n_blocks_im_hbr) = sum(block_info(:,ima)==1 & block_info(:,high_br)==1 & block_info(:,excl) == 0);
info(n_blocks_ni_lbr) = sum(block_info(:,ima)==0 & block_info(:,high_br)==0 & block_info(:,excl) == 0);
info(n_blocks_ni_hbr) = sum(block_info(:,ima)==0 & block_info(:,high_br)==1 & block_info(:,excl) == 0);
info(e_det_acc)   = sum(block_info(:,det_acc) < acc(1) | block_info(:,det_acc) >= acc(2));
info(e_ima_acc)   = sum(block_info(:,ima_check)==0);

if info(n_blocks_im_lbr) >= 1 && info(n_blocks_im_hbr) >= 1 && info(n_blocks_ni_lbr) >= 1 && info(n_blocks_ni_hbr) >= 1
    info(incl) = 1;
end

% exclude specified blocks
data.main = data.main(~data.main_excl,:);

