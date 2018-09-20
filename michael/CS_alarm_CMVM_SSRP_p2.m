% function [pop, Irate, SF, SH]=CS2T(Tfinal,Np,Rcrit,Vavg,Vsig,drift)
% clear pop Irate SF SH
clear lst lst2 cind pop contact colsp CM AS
% clf
R=40;%side length of nest. Nest area = side*side pxls
Np=250;%number of ants in total population
%build configuration for first frame
lst=2*R*(rand(Np,2)-0.5);
d2o= @(xy) sqrt(xy(:,1).^2+xy(:,2).^2);%measures distance to origin
rho=d2o(lst);
lst=lst(rho<R,:);
while length(lst)<Np %add in points til desired number reached
    lst=[lst; 2*R*(rand(1,2)-0.5)];
    lst=lst(d2o(lst)<R,:);
end
% plot(lst(:,1),lst(:,2),'o')
Rcrit=1.7;%interaction distance

%Velocity modulation params---------------
Veq=0.175;%0.5*V0;%equilibrium velocity, maybe = 0.5V0 ?
ASeq=0;%equilibrium alarm signal strength
Vhwidth=1*Veq;
% V0=.35;%velocity of S/R
V1=1; %velocity of A
Vmin=0.00;
THsig=pi/6;%std of turning angle

% Vr=V0*randvect(Np,2);
lst=[(1:Np)' lst, randintr(Veq-Vhwidth, Veq+Vhwidth, Np,1), zeros(Np,1)];%=[id x y velocity_param, alarm state(0/1/2), vx, vy]
lst=[lst, lst(:,4).*randvect(Np,2)];

%set alarmed fraction A0:
a0=0.05;
lst(1:ceil(a0*Np),4)=V1;%A0. as a fraction of Np
lst(1:ceil(a0*Np),6:7)=lst(1:ceil(a0*Np),4).*randvect(ceil(a0*Np),2);%set intitial velocities with magnitude V1

%TIME PARAMETERS
Tfinal=1500;
plot_decimation=52;
pause_time=.01;
CM_decimation=1500;
store_decimation=1;

%Contact rate, AR variables:-------------
delay_decay=14;%very sensitive!!!
sr2=@(X) real(sqrt(X))-imag(sqrt(X));%
ASoC=@(t_list, current_T, delay_decay, mu_neibs, mu_self, mu_eq) sum(exp((t_list - current_T)/delay_decay).*sr2(mu_neibs-mu_eq));% + exp(0)*(mu_self-mu_eq);
dmu=@(MU, ASS, a, b, th, mu0, AS0) th*(-a*(MU-mu0)+b*(ASS-AS0));%defines SSRP given parameters a, b > 0

CM=cell(Np,1);%contacts memory: [times of contact, speed of neib]  holds matricies of different sizes or empty
AS=zeros(Np,1);%stores all Alarm signal strength of all individuals at time t
DMU=zeros(Np,1);
%get first contact data:
dist=tril(squareform(pdist(lst(:,2:3),'euclidean')));%compute distance matrix and take lower triangular part
cind=find((dist<Rcrit)&(dist~=0));%find pairs with separation < Rcrit
if isempty(cind)==1
    I=[]; J=[];
else
    [I,J]=ind2sub(size(dist),cind);%list of pairs. I and J are row-col indicies within dist
    IDpairs=[lst(I,1) lst(J,1)];%[ID of neib i, ID of neib j]
    for j=1:length(IDpairs)
        CM{IDpairs(j,1)}=[1, lst(IDpairs(j,2),4); CM{IDpairs(j,1)}];%record time of contact (here t=1) into column 1 and speed of contacting neighbor in col 2
        CM{IDpairs(j,2)}=[1, lst(IDpairs(j,1),4); CM{IDpairs(j,2)}];
    end
end
for p=1:Np
    if isempty(CM{p})==0
    AS(p,1)=ASoC(CM{p}(:,1), 1, delay_decay, CM{p}(:,2), lst(p,4), Veq);
    else
        AS(p,1)=exp(0)*(lst(p,4)-Veq);%if no contacts yet use only second term (self contact) in ASoC
    end
end

% circle
circl=[linspace(0, 2*pi, 80)', R*ones(80,1)];
[X, Y]=pol2cart(circl(:,1), circl(:,2));
% plot(X,Y,'g-')

pop=zeros(Tfinal,3);%[resting, alarmed, recovered]
pop(1,:)=[sum(lst(:,5)==0), sum(lst(:,5)==1), sum(lst(:,5)==2)];

colsp=repmat([0 0 0],Np,1); %for colorizing points. each row is a rgb color vector

c=1;
fr=zeros(floor(Tfinal/store_decimation)+1, 1);
fr(1)=1;
vel=zeros(floor(Tfinal/store_decimation)+1, 1);%BEHOLD THE FORMULA FOR NUMBER OF ELEMENTS IN DECIMATED LIST, record group velocity
vel(1)=mean(d2o(lst(:,6:7)));%average velocity
vdev=zeros(floor(Tfinal/store_decimation)+1, 1);%record velocity stdev
vdev(1)=std(lst(:,4));%average velocity
as=zeros(floor(Tfinal/store_decimation)+1, 1);
as(1)=mean(AS);
dmur=zeros(floor(Tfinal/store_decimation)+1, 1);
strf=cell(floor(Tfinal/store_decimation)+1,1);%the main data structure. Each cell stores all workers locations, state, walking style
% strf{1,1}=lst;

cm=jet(200);
% START SIMULATION   %---finished intitialization, contact data
for t=2:Tfinal
    t
%     strf{t,1}=strf{t-1,1};
    lst2=lst;
%     dist=squareform(pdist(strf{t-1,1}(:,2:3),'euclidean'));
%MOVEMENT STEP
    for p=1:Np%move all workers in this frame. interaction comes later
     [TH, ~]=cart2pol(lst(p,6), lst(p,7));%measure angle of previous velocity vector
     TH2=TH+random('norm',0,THsig);%random deviation from straight
     [vx, vy]=pol2cart(TH2, 1);%vector of unit length with new theta
%      pos2=lst2(p,2:3)+random('norm',V0,Vsig)*[vx vy];%
     pos2=lst2(p,2:3)+lst2(p,4)*[vx vy];%fixed speed set at speed param
         while d2o(pos2)>=R%if and while particle is beyond boundary, redo the randvect
         TH2=TH+random('norm',0,THsig);%random deviation from straight
         [vx, vy]=pol2cart(TH2, 1);%vector of unit length with new theta (in general direction of last v vector)
             pos2=lst2(p,2:3)-lst2(p,4)*[vx vy];%
         end
      
      lst2(p,2:3)=pos2;%update the position in current frame. 
      lst2(p,6:7)=pos2-lst(p,2:3);%computing xv yv is the only reason we need two versions of lst
    end
%     disp('completed movement step')
%MEASURE CONTACTS
dist=tril(squareform(pdist(lst2(:,2:3),'euclidean')));%compute distance matrix and take lower triangular part
cind=find((dist<Rcrit)&(dist~=0));%find pairs with separation < Rcrit
if isempty(cind)==1%store all contacts from this frame
    I=[]; J=[];
else
    [I,J]=ind2sub(size(dist),cind);%list of pairs. I and J are row-col indicies within dist
    IDpairs=[lst(I,1) lst(J,1)];%[ID of neib i, ID of neib j]
    for j=1:length(IDpairs)
        CM{IDpairs(j,1)}=[t, lst(IDpairs(j,2),4); CM{IDpairs(j,1)}];%record time of contact (here t=1) into column 1 and speed of contacting neighbor in col 2
        CM{IDpairs(j,2)}=[t, lst(IDpairs(j,1),4); CM{IDpairs(j,2)}];
    end
end
for p=1:Np%find AS being received by each ant
    if isempty(CM{p})==0
    AS(p,1)=ASoC(CM{p}(:,1), t, delay_decay, CM{p}(:,2), lst(p,4), Veq);
    else
        AS(p,1)=exp(0)*(lst(p,4)-Veq);%if no contacts yet use only second term (self contact) in ASoC
    end
end
%CONTINUOUSLY update each ant's speed as a function of its own speed and its AS-----------
for p=1:Np
    DMU(p)=dmu(lst2(p,4), AS(p), F(p,1), F(p,2), F(p,3), Veq, ASeq);
lst2(p,4)=lst2(p,4)+DMU(p);%change speed by delta-mu**********0000****00000
if lst2(p,4)<Vmin%cant have negative velocity
    lst2(p,4)=Vmin;
end
end

if mod(t,CM_decimation)==0%clear out old Contact data
    for p=1:Np
        CM{p}=CM{p}(CM{p}(:,1)>(t-CM_decimation), :);%clears out old contacts which contribute very little, frees up memory
    end
end
lst=lst2;
%(simulation could end here without plotting)

%record data
if mod(t,store_decimation)==0
    c=c+1;
% POP{c,1}=c;
% POP{c,2}=lst2(:,4);
% POP{c,3}=AS;

fr(c,1)=t;%must record frame number for plotting
vel(c)=mean(lst2(:,4));%average velocity
vdev(c)=std(lst2(:,4));
as(c,1)=mean(AS);
dmur(c,1)=mean(DMU);

strf{c,1}=[t*ones(Np,1), lst2, AS, DMU]; %=[id x y velocity_param, alarm state(0/1/2), vx, vy, AS, DMU]-------------
strf{c,2}=I;
end

% strf{t,1}=lst2; strf{t,2}=I;
%now PLOT arena----------------------
if mod(t,plot_decimation)==0
% hh=figure(1);
% whitebg([0 0 0])
% colormap(jet)
% %       plot(lst2(:,2),lst2(:,3),'ko','MarkerSize',3,'MarkerFaceColor',[.5 .9 .5])
% %       scatter(lst2(:,2),lst2(:,3),10,lst2(:,4),'filled');% color by speed
% %             scatter(lst2(:,2),lst2(:,3),10,map2colsp(lst2(:,4),cm,[0,6]),'filled');%color by speed
% %       scatter(lst2(:,2),lst2(:,3),10,DMU>0,'filled');% color by DMU (acceleration)
%   scatter(lst2(:,2),lst2(:,3),10,lst2(:,4)>Veq,'filled');%color = binary velocity
%   
%       hold on
%       plot(X,Y,'g-')
% %       if isempty(I)==0
% % %       scatter(lst2(I(trans),2),lst2(I(trans),3),30,repmat([1 1 1],length(I(trans)),1))%plot one of the interacting pair circle
% %        scatter(lst2(I,2),lst2(I,3),30,repmat([1 1 1],length(I),1))%plot one of the interacting pair circle
% % 
% %       end
%       axis([-R R -R R])
%       title(['Frame: ' num2str(t)], 'fontsize',13)
% axis square
% %       hold on
%         
% %         fig = gcf;
% %         fig.InvertHardcopy = 'off';
% %         saveas(hh, ['C:\Users\Michael_R_Lin\Documents\KANG-FEWELL LAB\Alarm Propagation\movies\' num2str(t) '.png'])
% hold off

% figure(2); 
% plot(lst2(:,4),rand(Np,1),'k+')
% % scatter(lst2(:,4),zeros(1,Np),20,map2colsp(1:Np,cm,[1 Np]), 'filled')
% xlim([0 4.5])

figure(3); whitebg([1 1 1])%PHASE SPACE PLOT
scatter3(lst2(:,4),AS,DMU,10,lst2(:,4),'filled'); 
% hold on
axis([0 2.5 -25 25 -0.2 0.2])
xlabel('\mu'); ylabel('AS'); zlabel('\Delta \mu')
camorbit(t/Tfinal*10,0)

pause(pause_time)
end

end
%% SIMULATION ENDS HERE____________________________
figure(9)
whitebg([1 1 1])
plot(fr, vel, 'k-'); hold on
% plot(fr, vdev, 'b-')
% plot(fr, dmur, 'b-')
% ylim([0, 1])
xlabel('Iteration number', 'fontsize',14)
ylabel('Average speed (distance/frame)', 'fontsize',14)

% histogram(pop,50)
% histogram(contact(:,3),20)
%% save video
for t=2:1:Tfinal
    hh=figure(1);
whitebg([0 0 0])
colormap(jet)
%       plot(lst2(:,2),lst2(:,3),'ko','MarkerSize',3,'MarkerFaceColor',[.5 .9 .5])
%       scatter(lst2(:,2),lst2(:,3),10,lst2(:,4),'filled');% color by speed
            scatter(strf{t,1}(:,3),strf{t,1}(:,4),10,map2colsp(strf{t,1}(:,5),cm,[0,2.3]),'filled');%color
%             by speed

      hold on
      plot(X,Y,'g-')
      if isempty(strf{t,2})==0
%       scatter(lst2(I(trans),2),lst2(I(trans),3),30,repmat([1 1 1],length(I(trans)),1))%plot one of the interacting pair circle
       scatter(strf{t,1}(strf{t,2},3),strf{t,1}(strf{t,2},4),30,repmat([1 1 1],length(strf{t,2}),1))%plot one of the interacting pair circle

      end
      axis([-R R -R R])
      title(['Frame: ' num2str(t)], 'fontsize',13)
axis square
%       hold on
        
        fig = gcf;
        fig.InvertHardcopy = 'off';
        saveas(hh, ['C:\Users\Michael\Documents\KANG LAB\Alarm Propagation\movies\' num2str(t) '.png'])
hold off
pause(0.001)
end
%% convert to strd
strd=strf2strd(strf);
%% individual stat
% for p=1:1:Np
% indv(p,:)= mean(strd{p},1);
% end
plot(indv(:,9), indv(:,10),'.')
indv=sortrows(indv,5);
%% phase plot for single agent
p=104
figure(3); whitebg([1 1 1])%PHASE SPACE PLOT
colormap jet
scatter(strd{p,1}(:,5), strd{p,1}(:,9), 10, map2colsp(strd{p,1}(:,1),cm,[1,Tfinal]), 'filled'); 
% for p=1:20:Np
% plot3(strd{p,1}(:,5), strd{p,1}(:,9), strd{p,1}(:,10), '-'); 
% hold on
% end
axis([0 2.5 -35 15])
xlabel('s'); ylabel('AS'); %zlabel('\Delta \mu')
%% s histograms
tvm=argmax(vel);
edges=linspace(0,2,30);
subplot(3,1,1)
histogram(strf{2,1}(:,5), edges,'Normalization','count', 'FaceColor', [1 1 1]*.2); ylim([0, 230]); xlabel('s', 'fontsize', 15); ylabel('count', 'fontsize', 12);
subplot(3,1,2)
histogram(strf{tvm,1}(:,5), edges,'Normalization','count', 'FaceColor', [1 1 1]*.2); ylim([0, 230]); xlabel('s', 'fontsize', 15); ylabel('count', 'fontsize', 12);
subplot(3,1,3)
histogram(strf{Tfinal-1,1}(:,5), edges,'Normalization','count', 'FaceColor', [1 1 1]*.2); ylim([0, 230]); xlabel('s', 'fontsize', 15); ylabel('count', 'fontsize', 12);
%% s hist over time for video
for t=2:5:Tfinal
    hh=figure(10); whitebg([1 1 1])
% histogram(strf{t,1}(:,5), edges,'Normalization','count', 'FaceColor', [1 1 1]*.2); ylim([0, 230]); xlabel('s', 'fontsize', 15); ylabel('count', 'fontsize', 12);
plot(fr(1:end-1), vel(1:end-1), 'k-'); hold on
plot(fr(t), vel(t), 'ro', 'markerfacecolor', 'r'); hold off
% plot(fr, vdev, 'b-')
% plot(fr, dmur, 'b-')
% ylim([0, 1])
xlabel('Iteration', 'fontsize',14)
ylabel('Average speed (distance/frame)', 'fontsize',14)
title(['frame = ', num2str(t)],'fontsize', 14)
saveas(hh, ['C:\Users\Michael\Documents\KANG LAB\Alarm Propagation\movies\' num2str(t) '.png'])
pause(0.01)
end
%% 
