function plot_results_multiple(results,sub_info)

% rewrite to vectors
nSubs = length(results);
Dp    = nan(nSubs,3); C = nan(nSubs,3); Acc = nan(nSubs,3);
FA    = nan(nSubs,3); H = nan(nSubs,3); prac = zeros(nSubs,2);
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

save(fullfile('D:\IMADET\ExperimentsAll\Data','exp3'),'Dp','C','FA','H','prac','gen_SDTs')


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
histogram(sub_info(:,3)); hold on; histogram(sub_info(:,4));
legend('no imagery','congruent','incongruent');
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
cs(3,:) = [1 0 0];
for c = 1:3
    hold on; plot(c+randn(nSubs,1)/10,squeeze(squeeze(Dp(:,c))),'marker','*',...
       'color',cs(c,:),'LineWidth',2,'LineStyle', 'none')
    hold on; br = boxplot(Dp(:,c),'Colors','k','Symbol','r','Positions',c,'width',0.5);%bar(Xs(c),squeeze(mean(Dp(:,i,b))),'k');
    set(br,{'linew'},{2})
end
xlim([0 4]); ylim([-1 4])
set(gca,'XTick', [1 2 3]); 
set(gca,'XTickLabels',{'no-ima','cong','incong'});  
title('D prime');

subplot(2,4,5); % dprime - diff
cs(1,:) = [0.5 0.5 1];
cs(2,:) = [1 0.5 0.5];
for c = 1:2
    plot(c+randn(nSubs,1)/20,squeeze(Dp(:,1+c))-squeeze(Dp(:,1)),'marker','*',...
        'linestyle','none','color',cs(c,:),'LineWidth',2); hold on
end
hold on; h = boxplot([Dp(:,2)-Dp(:,1) Dp(:,3)-Dp(:,1)],'Colors','k','Symbol','r'); ylim([-2 2])
hold on; plot(xlim,[0 0],'k--');
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'cong','incong'});

subplot(2,4,2); % criterion
cs(1,:) = [0.5 0.5 0.5];
cs(2,:) = [0 0 1];
cs(3,:) = [1 0 0];
for c = 1:3
    hold on; plot(c+randn(nSubs,1)/10,squeeze(squeeze(C(:,c))),'marker','*',...
       'color',cs(c,:),'LineWidth',2,'LineStyle', 'none')
    hold on; br = boxplot(C(:,c),'Colors','k','Symbol','r','Positions',c,'width',0.5);%bar(Xs(c),squeeze(mean(Dp(:,i,b))),'k');
    set(br,{'linew'},{2})
end
xlim([0 4]); ylim([-1.5 2.5])
set(gca,'XTick', [1 2 3]); 
set(gca,'XTickLabels',{'no-ima','cong','incong'});  
title('Criterion');

subplot(2,4,6); % criterion - diff
cs(1,:) = [0.5 0.5 1];
cs(2,:) = [1 0.5 0.5];
for c = 1:2
    plot(c+randn(nSubs,1)/20,squeeze(C(:,1+c))-squeeze(C(:,1)),'marker','*',...
        'linestyle','none','color',cs(c,:),'LineWidth',2); hold on
end
hold on; h = boxplot([C(:,2)-C(:,1) C(:,3)-C(:,1)],'Colors','k','Symbol','r'); ylim([-2 2])
hold on; plot(xlim,[0 0],'k--');
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'cong','incong'});

subplot(2,4,3); % False alarm
cs(1,:) = [0.5 0.5 0.5];
cs(2,:) = [0 0 1];
cs(3,:) = [1 0 0];
for c = 1:3
    hold on; plot(c+randn(nSubs,1)/10,squeeze(squeeze(FA(:,c))),'marker','*',...
       'color',cs(c,:),'LineWidth',2,'LineStyle', 'none')
    hold on; br = boxplot(FA(:,c),'Colors','k','Symbol','r','Positions',c,'width',0.5);%bar(Xs(c),squeeze(mean(Dp(:,i,b))),'k');
    set(br,{'linew'},{2})
end
xlim([0 4]); ylim([0 1])
set(gca,'XTick', [1 2 3]); 
set(gca,'XTickLabels',{'no-ima','cong','incong'});  
title('False alarms');


subplot(2,4,7); % False alarm - diff
cs(1,:) = [0.5 0.5 1];
cs(2,:) = [1 0.5 0.5];
for c = 1:2
    plot(c+randn(nSubs,1)/20,squeeze(FA(:,1+c))-squeeze(FA(:,1)),'marker','*',...
        'linestyle','none','color',cs(c,:),'LineWidth',2); hold on
end
hold on; h = boxplot([FA(:,2)-FA(:,1) FA(:,3)-FA(:,1)],'Colors','k','Symbol','r'); 
ylim([-1 1])
hold on; plot(xlim,[0 0],'k--'); 
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'cong','incong'});

subplot(2,4,4); % Hits
cs(1,:) = [0.5 0.5 0.5];
cs(2,:) = [0 0 1];
cs(3,:) = [1 0 0];
for c = 1:3
    hold on; plot(c+randn(nSubs,1)/10,squeeze(squeeze(H(:,c))),'marker','*',...
       'color',cs(c,:),'LineWidth',2,'LineStyle', 'none')
    hold on; br = boxplot(H(:,c),'Colors','k','Symbol','r','Positions',c,'width',0.5);%bar(Xs(c),squeeze(mean(Dp(:,i,b))),'k');
    set(br,{'linew'},{2})
end
xlim([0 4]); ylim([0 1])
set(gca,'XTick', [1 2 3]); 
set(gca,'XTickLabels',{'no-ima','cong','incong'});  
title('Hits');

subplot(2,4,8); % Hits - diff
cs(1,:) = [0.5 0.5 1];
cs(2,:) = [1 0.5 0.5];
for c = 1:2
    plot(c+randn(nSubs,1)/20,squeeze(H(:,1+c))-squeeze(H(:,1)),'marker','*',...
        'linestyle','none','color',cs(c,:),'LineWidth',2); hold on
end
hold on; h = boxplot([H(:,2)-H(:,1) H(:,3)-H(:,1)],'Colors','k','Symbol','r'); 
ylim([-1 1])
hold on; plot(xlim,[0 0],'k--'); 
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'cong','incong'});

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
