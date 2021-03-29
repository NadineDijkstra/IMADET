function plot_results_single(results)

figure;
subplot(2,3,1); % surveys
bar([results.VVIQ; results.LHS_A; results.LHS_V]);
set(gca,'XTickLabels',{'VVIQ','LHS_A','LHS_V'});
ylim([0 4]); title('Surveys');

subplot(2,3,2); % staircase
plot(results.staircase(:,1),results.staircase(:,2),'o');
xlim([20 50]); ylim([50 110]);
ylabel('Accuracy');
xlabel('Visibility'); title('Staircase');

subplot(2,3,3); % practice
bar([results.dpAcc results.diViv]);
set(gca,'XTickLabels',{'det pract','ima right','ima left'});

subplot(2,3,4); % dprime
bar(results.main_D')
set(gca,'XTickLabels',{'no imagery','imagery'});
legend('left tilt','right tilt');
ylabel('D prime');

subplot(2,3,5); % criterion
bar(results.main_C')
set(gca,'XTickLabels',{'no imagery','imagery'});
legend('left tilt','right tilt');
ylabel('criterion');

subplot(2,3,6); % accuracy
bar(results.main_acc')
set(gca,'XTickLabels',{'no imagery','imagery'});
legend('left tilt','right tilt');
ylabel('accuracy');
