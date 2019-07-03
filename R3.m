close all
clear
load SOM_cossimlog.mat
semilogx(mean(s'),'r','LineWidth',1)

% % % plot(mean(s'),'r','LineWidth',1)
% % % axis([0,180000,-1,1])
% % % set(gca,'XTick',[0:40000:160000],'fontsize',12)
set(gca,'YTick',[-1:0.5:1],'fontsize',12)
xlabel('Agent-environment interactions','FontSize',16)
ylabel('Cosine similarity of most similar source task','FontSize',16)
% plot(log10(1:length(s)),mean(s'),'r','LineWidth',1)
% axis([2,6,-1,1])
% set(gca,'XTick',[2:1:6],'fontsize',12)
% set(gca,'YTick',[-1:0.5:1],'fontsize',12)
% xlabel('Agent-environment interactions (log_{10} scale)','FontSize',16)
% ylabel('Cosine similarity of most similar source task','FontSize',16)

% % % %%%%%%%%Legend%%%%%%%%%
% % % h_legend=legend('Experience replay with transition sequences','Experience replay with uniform random sampling','Prioritized experience replay (proportional)','Q-learning without experience replay')
% % % legend boxoff
% % % set(h_legend,'FontSize',12);
% % % %%%%%%%%%%%%%%%%%%%%%%%
% % % 
% % % 
% % % %%%%%%%%Textbox%%%%%%%%
% % % dim = [.15 .6 .3 .3];
% % % str = '\rho=0.0354';
% % % annotation('textbox',dim,'String',str,'FitBoxToText','on','LineStyle','none','FontWeight','bold','FontSize',14,'FontName','Arial');
% % % %%%%%%%%%%%%%%%%%%%%%%