%%
Reps=40;
par.Np=round(linspace(0.3,1.7,8)*250);
par.a0=0.05;
par.delay_decay=14;
par.Veq=0.175; 
par.V1=1;
par.Vhwidth=1*0.175;
% strrd=cell(Reps,length(par.Np));%SAVE SEPARATELY. DONT OVERWRITE STRR
%
tic
for hw=5:length(par.Np)
    hw
    par.Np(hw)
    remaining_time(hw,8,toc)
for r=1:Reps
    r
[fr, vel, vdev, as, cr, dmur]=CMVM_SSRP_func(F, par.Np(hw), par.a0, par.delay_decay, par.Veq, par.V1, par.Vhwidth);
strrd{r,hw}=[fr, vel, vdev, as, cr, dmur];
end
end
%%
for r=1:1:Reps
    
    figure(4)
    hold on
whitebg([1 1 1])
% plot(strr{r,1}(:,1), strr{r,1}(:,4), '-'); 

plot(strr{r,1}(:,1), strr{r,1}(:,2), '-');
% plot(strr{r,1}(:,1), strr{r,1}(:,4), 'r-');
% plot(strr{r,1}(:,4)*0.01, strr{r,1}(:,2),'-');
% ylim([0, 1])
xlabel('Iteration number', 'fontsize',14)
ylabel('Average Velocity (mm/s)', 'fontsize',14)
end
%% get median trajectories
velR=[]; asR=[];
vdevR=[]; dmurR=[];
for r=1:Reps
    velR=[velR, strr{r,1}(:,2)];
    vdevR=[vdevR, strr{r,1}(:,3)];
    asR=[asR, strr{r,1}(:,4)];
    dmurR=[dmurR, strr{r,1}(:,6)];
end
velR=median(velR,2);
    vdevR=median(vdevR,2);
    asR=median(asR,2);
    dmurR=median(dmurR,2);
    
plot(fr, velR,'k-'); hold on
plot(fr, vdevR,'b-'); 

figure(7)
plot3(velR, asR, dmurR,'.')
%% get median trajectories
velR=[]; asR=[];
vdevR=[]; dmurR=[];
fr=strrd{1,1}(:,1);
repdat=zeros(size(strrd,1), size(strrd,2), 1);
cm=cool(8);
% figure(1)

for w=1:8
    w
for r=1:size(strrd,1)
    r
    velR=[velR, strrd{r,w}(:,2)];
    vdevR=[vdevR, strrd{r,w}(:,3)];
    asR=[asR, strrd{r,w}(:,4)];
    dmurR=[dmurR, strrd{r,w}(:,6)];
    %get curve integrals--------
% repdat(r,w,1)=sum(strr{r,w}(:,2));
end
velR=median(velR,2);
    vdevR=median(vdevR,2);
    asR=median(asR,2);
    dmurR=median(dmurR,2);
    
plot(fr, velR,'-', 'linewidth',1,'color', cm(w,:)); 
% plot(fr, vdevR,'b-'); 
xlabel('Iteration', 'fontsize',14)
ylabel('Group avg speed (distance/frame)', 'fontsize',14)
% ylabel('mean AS', 'fontsize',14)
ylim([0,3.2])
hold on
% title(['s_{hw} = ',num2str(par.Vhwidth(w)/0.175), 's_{\mu}'],'fontsize', 14)
end

%%
par.Vhwidth=0.175*linspace(0,1,4);
for w=1:4
    figure(w)
    hold on
    for r=1:1:size(strr,1)
        plot(strr{r,w}(:,1), strr{r,w}(:,2), 'k-')
    end
    xlabel('Iteration', 'fontsize',14)
ylabel('Average speed (distance/frame)', 'fontsize',14)
title(['s_{hw} = ',num2str(par.Vhwidth(w)/0.175), 's_{\mu}'],'fontsize', 14)
ylim([0,3.5])
end