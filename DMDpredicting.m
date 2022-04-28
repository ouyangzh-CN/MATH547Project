clc,clear
close all
load("data.mat");
qwe = 30;
X = data.mean(:,1:qwe);
%Form DMD matrix
% if ~exist('Output')
%     Output = DMD(X.mean,[],.99);
% end

% Uncomment this if you'd like to visualize the data
% figure
% imagesc(X)

% Parameters:
thresh = 0.9;
nstacks = 17; % number of stacks

Color = [0 0.4470 0.7410;
        0.8500 0.3250 0.0980;
        0.9290 0.6940 0.1250;
        0.4940 0.1840 0.5560;
        0.4660 0.6740 0.1880;
    ];
% Construct the augmented, shift-stacked data matrices
% This resolves DMD's issues with standing waves
Xaug = [];
for st = 1:nstacks
    Xaug = [Xaug; X(:, st:end-nstacks+st)];
end

for i_aug = 1:1
%%% Compute DMD on Xaug (or X) %%% 
    if i_aug == 1
        Output = DMD(X,[],thresh);
    elseif i_aug == 2
        Output = DMD(Xaug,[],thresh);
    end

    dt = 1;

    % Extracting out DMD outputs with nicer variable names
    lambda = Output.DMD.D;
    %omega = log(lambda)/dt/2/pi;
    omega = log(lambda)/dt;
    S_r = Output.DMD.Sig(1:Output.DMD.r,1:Output.DMD.r);
    V_r = Output.DMD.VX(:,1:Output.DMD.r);
    Atilde = Output.DMD.A;
    X = Output.X;
    Xp = Output.Xp;

    %%% Plot eigenvalues %%%
    figure('Position', [496 401 798 583]);
    subplot(2,2,1);
        plot(lambda, 'k.');
        rectangle('Position', [-1 -1 2 2], 'Curvature', 1, ...
            'EdgeColor', 'k', 'LineStyle', '--');
        axis(1.2*[-1 1 -1 1]);
        axis square;
        title('\lambda')
        set(gca,'FontSize',12,'LineWidth',1.25)
        xlabel('Real')
        ylabel('Imaginary')
    subplot(2,2,2);
        plot(omega, 'k.');
        line([0 0], 200*[-1 1], 'Color', 'k', 'LineStyle', '--');
        axis([-8 2 -170 +170]);
        axis square;
        title('\omega')
        set(gca,'FontSize',12,'LineWidth',1.25)
        xlabel('Real')
        ylabel('Frequency (Hz)')

    set(gcf, 'PaperUnits', 'inches', 'PaperPosition', [0 0 6 3], 'PaperPositionMode', 'manual');
    % print('-depsc2', '-loose', ['../figures/DMD_eigenvalues.eps']);

    %%% DMD and FFT Spectra %%%
    % alternate scaling of DMD modes
    Ahat = (S_r^(-1/2)) * Atilde * (S_r^(1/2));
    [What, D] = eig(Ahat);
    W_r = S_r^(1/2) * What;
    Phi = Xp*V_r/S_r*W_r;

    f = abs(imag(omega));
    P = (diag(Phi'*Phi));

    % DMD spectrum
    subplot(2,2,3);
        stem(f, P, 'k');
        xlim([0 150]);
        axis square;
        title('DMD Spectrum')
        set(gca,'FontSize',12,'LineWidth',1.25)
        xlabel('Frequency (Hz)')
    % FFT spectrum
%     timesteps = size(X, 2);
%     srate = 1/dt;
%     nelectrodes = 59;
%     NFFT = 2^nextpow2(timesteps);
%     f = srate/2*linspace(0, 1, NFFT/2+1);
%     subplot(2,2,4); 
%         hold on;
%         for c = 1:nelectrodes
%             fftp(c,:) = fft(X(c,:), NFFT);
%             plot(f, 2*abs(fftp(c,1:NFFT/2+1)), ...
%                 'Color', 0.6*[1 1 1]);
%         end
%         plot(f, 2*abs(mean(fftp(c,1:NFFT/2+1), 1)), ...
%             'k', 'LineWidth', 2);
%         xlim([0 150]);
%         ylim([0 400]);
%         axis square;
%         box on;
%         title('FFT Spectrum')
%         set(gca,'FontSize',12,'LineWidth',1.25)
%         xlabel('Frequency (Hz)')

    % compute DMD mode amplitude
    x1 = X(:,1);
    b = Phi\x1;
    % DMD reconstrcution
    mm1 = size(data.mean,2);
    tt = 0:50-1;
    mm2 = size(tt,2);
    time_dynamics = zeros(Output.DMD.r,mm2);
    t = (0:mm1-1)*dt;
    for iter = 1:mm2
        time_dynamics(:,iter) = (b.*exp(omega*tt(iter)));
    end
    Xdmd = Phi*time_dynamics;
    %plot(t,Xdmd(1:10,:),t,X(1:10,:));
    country_id = [95;101;6;163;522];
    countryName = {'UK','US','CHN','India','Sudan'};
    for i = 1:5
        candi = find(data.loc == country_id(i) & data.age == 149 & ...
            data.sex == 1);
        PLOT(i) = candi;
    end
    
    figure
    t = t + 1970;
    tt = tt + 1970;
    for i = 1:length(PLOT)
        id = PLOT(i);
        PP(i,:) = plot(t,data.mean(id,:),'*',...
            t,real(Xdmd(id,1:mm1)),'LineWidth',2,'Color',Color(i,:));
        %PP(i,:) = plot(tt(end-15:end),real(Xdmd(id,end-15:end)),'LineWidth',2,'Color',Color(i,:));
        hold on
        plot(tt(end-4:end),real(Xdmd(id,end-4:end)),'o',...
            'LineWidth',2,'Color',Color(i,:))
        
        xlabel('year'),ylabel('mean education rate')
        set(gca,'FontSize',12,'LineWidth',2)
        %plot(t,data.raw(id,:),'o')
    end
    plot([qwe+1970,qwe+1970],[-1,2.5],'--','LineWidth',1.5,'Color',[0 0 0])
    legend(PP(:,1),{'Unite Kingdom','Canada','China','India','Sudan'})
end