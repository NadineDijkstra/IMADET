function fit_data(data)

% define state space
Aprior(1,:) = [0.25 0.25 0.25 0.25]; % [high SNR, present; high SNR, absent; low SNR, present; low SNR, absent]
Aprior(2,:) = [0.25/2 0.25/2 0.75/2 0.75/2]; % high prior on INT

Wprior(1) = 0.5; % always 50/50 P/A - 50 P is divided into wprior class 2 and 1-wprior class 1
Wprior(2) = 0.25; % high prior w1
Wprior(3) = 0.75; % high prior w2

high_mu(1,:) = [0.5 2];
high_mu(2,:) = [2 0.5];
high_mu(3,:) = [0.5 0.5];

low_mu(1,:) = [0.5 1];
low_mu(2,:) = [1 0.5];
low_mu(3,:) = [0.5 0.5];

X(1,:) = [3,0]; % input w1 and w2 channels
X(2,:) = [2,0];
X(3,:) = [1,0]; 
X(4,:) = [0,0]; 
X(5,:) = [0,1]; 
X(6,:) = [0,2];
X(7,:) = [0,3]; 

A = zeros(size(Aprior,1),size(Wprior,2),size(X,1),2,2);
W = zeros(size(Aprior,1),size(Wprior,2),size(X,1),3);

P = zeros(size(Aprior,1),size(Wprior,2),size(X,1));
E = zeros(size(Aprior,1),size(Wprior,2),size(X,1));

c = 1;
for a = 1:size(Aprior,1)
    for w = 1:size(Wprior,2)
        for x = 1:size(X,1)
            
            fprintf('Evaluating model %d out of %d \n',c,size(Aprior,1)*size(Wprior,2)*size(X,1))
            
            % evaluate model
            [p_a,p_w] = HOSS_evaluation_precision(X(x,:), Aprior(a,:), Wprior(w), high_mu, low_mu);
            
            A(a,w,x,:,:) = p_a;
            W(a,w,x,:) = p_w;
            
            marginal_presence = sum(p_a,1);
            marginal_gain     = sum(p_a,2);
            
            P(a,w,x) = marginal_presence(1);
            E(a,w,x) = marginal_gain(1);
            
            c = c+1;
            
            clear p_a p_w
        end
    end
end

% save
save(['simulation_precision'])

% plot the things 
figure; c = 1;
Anames = {'flat','EXT','INT'};
Wnames = {'flat','w1','w2'};

for a = 1:size(Aprior,1)
    for w = 1:size(Wprior,2)
        subplot(size(Aprior,1),size(Wprior,2),c)
        plot(squeeze(P(a,w,:)),'r'); hold on
        plot(squeeze(E(a,w,:)),'b'); legend('present','external');
        
        set(gca,'XTick',1:7); set(gca,'XTickLabels',{'-3','-2','-1','0','1','2','3'})
        
        title(sprintf('A prior %s - W prior %s',Anames{a},Wnames{w}))
        xlabel('Sensory input'); ylabel('probability');
        ylim([0 1]);
        hold on; plot(xlim,[0.5 0.5], 'k--')
        
        c = c+1;
    end
end

figure; 
INT = E < 0.5 & P > 0.5; % present and internal - FA 


