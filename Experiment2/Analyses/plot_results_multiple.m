function plot_results_multiple(results,sub_info)

% rewrite to vectors
nSubs = length(results);
Dp    = nan(nSubs,2,2); C = nan(nSubs,2,2); Acc = nan(nSubs,2,2);
FA    = nan(nSubs,2,2); H = nan(nSubs,2,2); prac = zeros(nSubs,2);
gen_SDTs = nan(nSubs,4);
age = zeros(nSubs,1); gender = cell(nSubs,1); country = cell(nSubs,1);
ima_check = cell(nSubs,1); ima_influence = cell(nSubs,1); comments = cell(nSubs,1);
for s = 1:nSubs
   Dp(s,:,:) = results{s}.main_D;
   C(s,:,:) = results{s}.main_C;
   FA(s,:,:) = results{s}.main_FA;
   H(s,:,:) = results{s}.main_H;
   Acc(s,:,:) = results{s}.main_acc;
   prac(s,1) = results{s}.dpAcc;
   prac(s,2) = mean(results{s}.diViv);
   age(s) = results{s}.age;
   gender{s} = results{s}.gender;
   country{s} = results{s}.country;
   ima_check{s} = results{s}.ima_check;
   ima_influence{s} = results{s}.ima_influence;
   comments{s} = results{s}.comments;
   gen_SDTs(s,1) = results{s}.gen_D;
   gen_SDTs(s,2) = results{s}.gen_C;
   gen_SDTs(s,3) = results{s}.gen_FA;
   gen_SDTs(s,4) = results{s}.geb_H;
end

genders = unique(gender);
fprintf('Gender distribution: \n')
for g = 1:length(genders)
    total = sum(strcmp(gender,genders{g}));
    fprintf('\t %d %s \n',total,genders{g})
end
fprintf('Mean age: %.2f (%.2f) \n',mean(age),std(age))

save(fullfile('D:\IMADET\ExperimentsAll\Data','exp2'),'Dp','C','FA','H','prac','gen_SDTs')

%% -- Diagnostics -- %%
figure(1); 

% detection and imagery practice
subplot(3,3,1); histogram(prac(:,1)); title('Detection practice');
xlabel('Accuracy'); ylabel('n subjects');
subplot(3,3,2); histogram(prac(:,2)); title('Imagery practice');
xlabel('Vividness'); ylabel('n subjects');

% number of blocks included
sub_info = sub_info(sub_info(:,1)==1,:);
subplot(3,3,3); histogram(sub_info(:,2)); hold on;
histogram(sub_info(:,3)); legend('imagery','no imagery');
xlabel('Nr of blocks'); ylabel('n subjects')

% staircase
vis = zeros(nSubs,length(results{1}.staircase),2);
acc = zeros(nSubs,length(results{1}.staircase));
for s = 1:nSubs
    
    acc(s,:) = results{s}.staircase(:,2);
    vis(s,:,1) = results{s}.staircase(:,1);
    %vis(s,:,2) = results{s}.staircase(:,3);
    
    subplot(3,3,4:6);
    plot(results{s}.staircase(:,2)); hold on
    plot(xlim,[70 70],'k--')
    title('Accuracy'); xlabel('Stair step')
    
    subplot(3,3,7:9);
    plot(squeeze(vis(s,:,1)),'-'); hold on
    %plot(squeeze(vis(s,:,2)),'--'); hold on
    title('Visibility'); xlabel('Stair step')
end
subplot(3,3,4:6); hold on; plot(mean(acc,1),'k-','LineWidth', 3);
hold on; plot([length(results{s}.staircase(:,1))/2 length(results{s}.staircase(:,1))/2],ylim,'k--','LineWidth', 3)
subplot(3,3,7:9); hold on; plot(squeeze(mean(vis(:,:,1),1)),'k-','LineWidth', 3);
hold on; plot([length(results{s}.staircase(:,1))/2 length(results{s}.staircase(:,1))/2],ylim,'k--','LineWidth', 3)

%% -- Main results -- %% 
figure(2);
subplot(2,4,1); % dprime
cs(1,:) = [0.5 0.5 0.5];
cs(2,:) = [0 0 1];
Xs = [1 2 4 5]'; c = 1;
for b = 1:2
    for i = 1:2
        hold on; plot(Xs(c)+randn(nSubs,1)/10,squeeze(squeeze(Dp(:,i,b))),'marker','*',...
       'color',cs(i,:),'LineWidth',2,'LineStyle', 'none')
        hold on; br = boxplot(squeeze(Dp(:,i,b)),'Colors','k','Symbol','r','Positions',Xs(c),'width',0.5);%bar(Xs(c),squeeze(mean(Dp(:,i,b))),'k');
        set(br,{'linew'},{2})
        c = c+1;
    end      
end
xlim([0 6]); ylim([-1 4])
set(gca,'XTick', [1.5 4.5]); 
set(gca,'XTickLabels',{'20%','80%'});  
title('D prime');

subplot(2,4,5); % dprime - diff
for b = 1:2
    plot(b+randn(nSubs,1)/20,squeeze(Dp(:,2,b))-squeeze(Dp(:,1,b)),'marker','*',...
        'linestyle','none','color',[0.5 0.5 1],'LineWidth',2); hold on
end
hold on; h = boxplot(squeeze(Dp(:,2,:)-Dp(:,1,:)),'Colors','k','Symbol','r'); ylim([-2 2])
hold on; plot(xlim,[0 0],'k--');
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'20%','80%'});

subplot(2,4,2); % criterion
Xs = [1 2 4 5]'; c = 1;
for b = 1:2
    for i = 1:2
        hold on; plot(Xs(c)+randn(nSubs,1)/10,squeeze(squeeze(C(:,i,b))),'marker','*',...
       'color',cs(i,:),'LineWidth',2,'LineStyle', 'none')
        hold on; br = boxplot(squeeze(C(:,i,b)),'Colors','k','Symbol','r','Positions',Xs(c),'width',0.5);%bar(Xs(c),squeeze(mean(Dp(:,i,b))),'k');
        set(br,{'linew'},{2})
        c = c+1;
    end      
end
xlim([0 6]); ylim([-1.5 2.5])
set(gca,'XTick', [1.5 4.5]); 
set(gca,'XTickLabels',{'20%','80%'});  
title('Criterion');

subplot(2,4,6); % criterion - diff
for b = 1:2
    plot(b+randn(nSubs,1)/20,squeeze(C(:,2,b))-squeeze(C(:,1,b)),'marker','*',...
        'linestyle','none','color',[0.5 0.5 1],'LineWidth',2); hold on
end
hold on; h = boxplot(squeeze(C(:,2,:)-C(:,1,:)),'Colors','k','Symbol','r'); ylim([-2 2])
hold on; plot(xlim,[0 0],'k--');
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'20%','80%'});


subplot(2,4,3); % False alarm
Xs = [1 2 4 5]'; c = 1;
for b = 1:2
    for i = 1:2
        hold on; plot(Xs(c)+randn(nSubs,1)/10,squeeze(squeeze(FA(:,i,b))),'marker','*',...
       'color',cs(i,:),'LineWidth',2,'LineStyle', 'none')
        hold on; br = boxplot(squeeze(FA(:,i,b)),'Colors','k','Symbol','r','Positions',Xs(c),'width',0.5);%bar(Xs(c),squeeze(mean(Dp(:,i,b))),'k');
        set(br,{'linew'},{2})
        c = c+1;
    end      
end
xlim([0 6]); ylim([0 1])
set(gca,'XTick', [1.5 4.5]); 
set(gca,'XTickLabels',{'20%','80%'});  
title('False alarms');

subplot(2,4,7); % False alarm - diff
for b = 1:2
    plot(b+randn(nSubs,1)/20,squeeze(FA(:,2,b))-squeeze(FA(:,1,b)),'marker','*',...
        'linestyle','none','color',[0.5 0.5 1],'LineWidth',2); hold on
end
hold on; h = boxplot(squeeze(FA(:,2,:)-FA(:,1,:)),'Colors','k','Symbol','r'); ylim([-1 1])
hold on; plot(xlim,[0 0],'k--'); 
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'20%','80%'});

subplot(2,4,4); % Hits
Xs = [1 2 4 5]'; c = 1;
for b = 1:2
    for i = 1:2
        hold on; plot(Xs(c)+randn(nSubs,1)/10,squeeze(squeeze(H(:,i,b))),'marker','*',...
       'color',cs(i,:),'LineWidth',2,'LineStyle', 'none')
        hold on; br = boxplot(squeeze(H(:,i,b)),'Colors','k','Symbol','r','Positions',Xs(c),'width',0.5);%bar(Xs(c),squeeze(mean(Dp(:,i,b))),'k');
        set(br,{'linew'},{2})
        c = c+1;
    end      
end
xlim([0 6]); ylim([0 1])
set(gca,'XTick', [1.5 4.5]); 
set(gca,'XTickLabels',{'20%','80%'});  
title('Hits');

subplot(2,4,8); % Hits - diff
for b = 1:2
    plot(b+randn(nSubs,1)/20,squeeze(H(:,2,b))-squeeze(H(:,1,b)),'marker','*',...
        'linestyle','none','color',[0.5 0.5 1],'LineWidth',2); hold on
end
hold on; h = boxplot(squeeze(H(:,2,:)-H(:,1,:)),'Colors','k','Symbol','r'); ylim([-1 1])
hold on; plot(xlim,[0 0],'k--'); 
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'20%','80%'});

%% -- Between subject survey results -- %% 
figure; 

measure_names = {"D'",'Criterion','False alarms','Hits'};
for m = 1:4
    subplot(1,4,m); 
    scatter(prac(:,2),squeeze(gen_SDTs(:,m)),'k','filled');
    l = lsline; l.Color = 'k'; l.LineWidth = 2;
    xlabel('Vividness'); ylabel(measure_names{m}); 
    [r,p] = corr(prac(:,2),squeeze(gen_SDTs(:,m)),'type','Spearman');
    title(sprintf('r:%.3f p: %.3f',r,p))
end

%measures{1} = Dp; measures{2} = C; measures{3} = FA; measures{4} = H;
% 
% for m = 1:length(measures)
%     subplot(2,4,m);
%     scatter(prac(:,2),squeeze(measures{m}(:,1,1)),'b','filled'); hold on
%     scatter(prac(:,2),squeeze(measures{m}(:,2,1)),'r','filled'); hold on
%     l = lsline; [r,p] = corr(squeeze(measures{m}(:,:,1)),prac(:,2),'type','Spearman');
%     l(1).Color = 'r'; l(1).LineWidth = 2;
%     l(2).Color = 'b'; l(2).LineWidth = 2;
%     legend(sprintf('r: %.3f, p: %.3f',r(1),p(1)),sprintf('r: %.3f, p: %.3f',r(2),p(2)))
%     ylabel(measure_names{m}); xlabel('vividness'); title([measure_names{m} ' low BR'])
%     
%     subplot(2,4,m+4);
%     scatter(prac(:,2),squeeze(measures{m}(:,1,2)),'b','filled'); hold on
%     scatter(prac(:,2),squeeze(measures{m}(:,2,2)),'r','filled'); hold on
%     l = lsline; [r,p] = corr(squeeze(measures{m}(:,:,2)),prac(:,2),'type','Spearman');
%     l(1).Color = 'r'; l(1).LineWidth = 2;
%     l(2).Color = 'b'; l(2).LineWidth = 2;
%     legend(sprintf('r: %.3f, p: %.3f',r(1),p(1)),sprintf('r: %.3f, p: %.3f',r(2),p(2)))
%     ylabel(measure_names{m}); xlabel('vividness'); title([measure_names{m} ' high BR'])
% end

%% Ima_influence check

believe_effect = nan(nSubs,1);
believe_effect(contains(ima_influence,{'yes','I do'},'IgnoreCase',1)) = 1;
believe_effect(contains(ima_influence,{'maybe','a little','slightly','possibly','perhaps','some'},'IgnoreCase',1)) = 2;
believe_effect(contains(ima_influence,{'no'},'IgnoreCase',1)) = 3;

figure; diff_C = squeeze(C(:,1,:)-C(:,2,:));
Xs = [1 2 4 5 7 8]; c = 1; cs = ['g','m'];
for co = 1:3
    idx = believe_effect == co;
    for b = 1:2
        plot(Xs(c)+randn(sum(idx),1)/10,squeeze(diff_C(idx,b)),[cs(b) '*'],'LineWidth',2); hold on;
        
        br = boxplot(diff_C(idx,b),'Colors','k','Symbol','r','Positions',Xs(c),'width',0.5);
        set(br,{'linew'},{2}); hold on
        c = c+1;
    end
end
xlim([0 9]); ylim([-2 2])
set(gca,'XTick', [1.5 4.5 7.5]);
set(gca,'XTickLabels',{'Yes','Sometimes','No'});
hold on; plot(xlim,[0 0],'k--')
ylabel('C shift'); title('Do you think your imagery influenced your response?');
legend('20%','80%')

