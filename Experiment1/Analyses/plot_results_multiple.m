function plot_results_multiple(results,sub_info)

% rewrite to vectors
nSubs = length(results);
VVIQ  = nan(nSubs,1); LHS_A = nan(nSubs,1); LHS_V = nan(nSubs,1);
Dp    = nan(nSubs,2); C = nan(nSubs,2); Acc = nan(nSubs,2);
FA    = nan(nSubs,2); H = nan(nSubs,2); prac = zeros(nSubs,2);
RT = zeros(nSubs,2,2,2);
for s = 1:nSubs
   VVIQ(s)  = results{s}.VVIQ;
   LHS_A(s) = results{s}.LHS_A;
   LHS_V(s) = results{s}.LHS_V;
   Dp(s,:) = results{s}.main_D;
   C(s,:) = results{s}.main_C;
   FA(s,:) = results{s}.main_FA;
   H(s,:) = results{s}.main_H;
   Acc(s,:) = results{s}.main_acc;
   prac(s,1) = results{s}.dpAcc;
   prac(s,2) = mean(results{s}.diViv);
   RT(s,:,:,:) = results{s}.RT;
end

save(fullfile('D:\IMADET\ExperimentsAll\Data','exp1'),'Dp','C','FA','H','prac')


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
for c = 1:2
   hold on; plot(c+randn(nSubs,1)/10,squeeze(Dp(:,c)),'marker','*',...
       'color',cs(c,:),'LineWidth',2,'LineStyle', 'none')
end
hold on; h = boxplot(Dp,'Positions', [1 2], 'Colors','k','Symbol','r');
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'no imagery','imagery'});
title("d'");

subplot(2,4,5); % dprime - diff
plot(1+randn(nSubs,1)/20,squeeze(Dp(:,2))-squeeze(Dp(:,1)),'marker','*',...
    'linestyle','none','color',[0.5 0.5 1],'LineWidth',2)
hold on; h = boxplot(Dp(:,2)-Dp(:,1),'Colors','k','Symbol','r'); ylim([-2 2])
hold on; plot(xlim,[0 0],'k--')
set(h,{'linew'},{2})
set(gca,'XTick', 1);
set(gca,'XTickLabels',{'difference'});

subplot(2,4,2); % criterion
for c = 1:2
   hold on; plot(c+randn(nSubs,1)/10,squeeze(C(:,c)),'marker','*',...
       'color',cs(c,:),'LineWidth',2,'LineStyle', 'none')
end
hold on; h = boxplot(C,'Positions', [1 2], 'Colors','k','Symbol','r');
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]);
set(gca,'XTickLabels',{'no imagery','imagery'});
title('C');

subplot(2,4,6); % criterion - diff
plot(1+randn(nSubs,1)/20,squeeze(C(:,2))-squeeze(C(:,1)),'marker','*',...
    'linestyle','none','color',[0.5 0.5 1],'LineWidth',2)
hold on; h = boxplot(C(:,2)-C(:,1),'Colors','k','Symbol','r'); ylim([-2 2])
hold on; plot(xlim,[0 0],'k--')
set(h,{'linew'},{2})
set(gca,'XTick', 1);
set(gca,'XTickLabels',{'difference'});


% subplot(2,3,3); % Accuracy
% cs = ['b' 'r'];
% for c = 1:2
%    hold on; plot(c+randn(nSubs,1)/10,squeeze(Acc(:,c)),[cs(c) '*'],'LineWidth',2)
% end
% hold on; h = boxplot(Acc,'Positions', [1 2], 'Colors','k');
% set(h,{'linew'},{2})
% set(gca,'XTick', [1 2]);
% set(gca,'XTickLabels',{'no imagery','imagery'});
% ylabel('Accuracy');
% hold on; plot(xlim,[0.70 0.70],'k--'); ylim([0.45 1]);

subplot(2,4,3); % False alarm
for c = 1:2
   hold on; plot(c+randn(nSubs,1)/10,squeeze(FA(:,c)),'marker','*',...
       'color',cs(c,:),'LineWidth',2,'LineStyle', 'none')
end
hold on; h = boxplot(FA,'Positions', [1 2], 'Colors','k','Symbol','r');
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]); ylim([0 1])
set(gca,'XTickLabels',{'no imagery','imagery'});
title('False alarms');

subplot(2,4,7); % False alarm - diff
plot(1+randn(nSubs,1)/20,squeeze(FA(:,2))-squeeze(FA(:,1)),'marker','*',...
    'linestyle','none','color',[0.5 0.5 1],'LineWidth',2)
hold on; h = boxplot(FA(:,2)-FA(:,1),'Colors','k','Symbol','r'); ylim([-1 1])
hold on; plot(xlim,[0 0],'k--')
set(h,{'linew'},{2})
set(gca,'XTick', 1); 
set(gca,'XTickLabels',{'difference'});

subplot(2,4,4); % Hits
for c = 1:2
   hold on; plot(c+randn(nSubs,1)/10,squeeze(H(:,c)),'marker','*',...
       'color',cs(c,:),'LineWidth',2,'LineStyle', 'none')
end
hold on; h = boxplot(H,'Positions', [1 2], 'Colors','k','Symbol','r');
set(h,{'linew'},{2})
set(gca,'XTick', [1 2]); ylim([0 1])
set(gca,'XTickLabels',{'no imagery','imagery'});
title('Hits');

subplot(2,4,8); % Hits - diff
plot(1+randn(nSubs,1)/20,squeeze(H(:,2))-squeeze(H(:,1)),'marker','*',...
    'linestyle','none','color',[0.5 0.5 1],'LineWidth',2)
hold on; h = boxplot(H(:,2)-H(:,1),'Colors','k','Symbol','r'); ylim([-1 1])
hold on; plot(xlim,[0 0],'k--')
set(h,{'linew'},{2})
set(gca,'XTick', 1);
set(gca,'XTickLabels',{'difference'});

%% -- Between subject survey results -- %% 
figure; 
subplot(2,3,[1 4]); % surveys
bar(1,mean(VVIQ),'FaceColor','b','FaceAlpha', 0.3);
hold on; plot(1+randn(nSubs,1)/7,VVIQ,'b*','LineWidth',2);
bar(2,mean(LHS_A),'FaceColor','r','FaceAlpha', 0.3);
hold on; plot(2+randn(nSubs,1)/7,LHS_A,'r*','LineWidth',2);
bar(3,mean(LHS_V),'FaceColor','g','FaceAlpha', 0.3);
hold on; plot(3+randn(nSubs,1)/7,LHS_V,'g*','LineWidth',2);
set(gca,'XTick',[1 2 3])
set(gca,'XTickLabels',{'VVIQ','LHS_A','LHS_V'});
ylim([0 4]); title('Surveys');


subplot(2,3,2); % diff C
scatter(C(:,1)-C(:,2),VVIQ,'b'); hold on
l = lsline; 
l.Color = 'b'; l.LineWidth = 2;
xlabel('C NI - C I'); ylabel('Vividness');
title('Criterion shift')

subplot(2,3,3)
scatter(C(:,1)-C(:,2),LHS_A,'r'); hold on
scatter(C(:,1)-C(:,2),LHS_V,'g'); hold on
l = lsline; 
l(1).Color = 'g'; l(1).LineWidth = 2;
l(2).Color = 'r'; l(2).LineWidth = 2;
xlabel('C NI - C I'); ylabel('Hallucination');
legend('Auditory','Visual'); title('Criterion shift')

subplot(2,3,5) % D-prime
scatter(Dp(:,1)-Dp(:,2),VVIQ,'b'); hold on
l = lsline;
l.Color = 'b'; l.LineWidth = 2;
xlabel('Dp NI - Dp I'); ylabel('Vividness');
title('D-prime effect')

subplot(2,3,6)
scatter(Dp(:,1)-Dp(:,2),LHS_A,'r'); hold on
scatter(Dp(:,1)-Dp(:,2),LHS_V,'g'); hold on
l = lsline;
l(1).Color = 'g'; l(1).LineWidth = 2;
l(2).Color = 'r'; l(2).LineWidth = 2;
ylabel('Hallucination');
legend('Auditory','Visual');
