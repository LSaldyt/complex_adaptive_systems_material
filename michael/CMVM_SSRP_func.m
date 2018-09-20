function [fr, vel, vdev, as, cr, dmur]=CMVM_SSRP_func(F, Np, a0, delay_decay, Veq, V1, Vhwidth)
clear lst lst2 POP colsp CM AS
% clf
R=40;%side length of nest. Nest area = side*side pxls
% Np=250;%number of ants in total population
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
% Veq=V0;%equilibrium velocity, maybe = 0.5V0 ?
ASeq=0;%equilibrium alarm signal strength
% V0=.35;%velocity of S/R
% V1=1.0; %velocity of A
Vmin=0.0;
THsig=pi/6;%std of turning angle

lst=[(1:Np)' lst, randintr(Veq-Vhwidth, Veq+Vhwidth, Np,1), zeros(Np,1)];%=[id x y velocity_param, alarm state(0/1/2), vx, vy]
lst=[lst, lst(:,4).*randvect(Np,2)];%random direction

%set alarmed fraction A0:
% a0=0.05;
lst(1:ceil(a0*Np),4)=V1;%A0. as a fraction of Np
lst(1:ceil(a0*Np),6:7)=lst(1:ceil(a0*Np),4).*randvect(ceil(a0*Np),2);%set intitial velocities with magnitude V1

%TIME PARAMETERS
Tfinal=2000;
% plot_decimation=33;
% pause_time=.001;
CM_decimation=floor(Tfinal/2);
store_decimation=10;

%Contact rate, AR variables:-------------
% delay_decay=14;%very sensitive!!!
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
    for j=1:size(IDpairs,1)
        CM{IDpairs(j,1)}=[1, lst(IDpairs(j,2),4); CM{IDpairs(j,1)}];%record time of contact (here t=1) into column 1 and speed of contacting neighbor in col 2
        CM{IDpairs(j,2)}=[1, lst(IDpairs(j,1),4); CM{IDpairs(j,2)}];
    end
end
for p=1:Np
    if isempty(CM{p})==0
    AS(p,1)=ASoC(CM{p}(:,1), 1, delay_decay, CM{p}(:,2), lst(p,4), Veq);
    else
        AS(p,1)=exp(0)*sr2(lst(p,4)-Veq);%if no contacts yet use only second term (self contact) in ASoC
    end
end

% circle
% circl=[linspace(0, 2*pi, 80)', R*ones(80,1)];
% [X, Y]=pol2cart(circl(:,1), circl(:,2));
% plot(X,Y,'g-')

% strf=cell(Tfinal,3);%the main data structure. Each cell stores all workers locations, state, walking style
% strf{1,1}=lst;
% pop=zeros(Tfinal,3);%[resting, alarmed, recovered]

% colsp=repmat([0 0 0],Np,1); %for colorizing points. each row is a rgb color vector
% contact=zeros(Tfinal,3);%[1-1 2-2 1-2] contact counts in each frame

c=1;
fr=zeros(floor(Tfinal/store_decimation)+1, 1);
fr(1)=1;
vel=zeros(floor(Tfinal/store_decimation)+1, 1);%BEHOLD THE FORMULA FOR NUMBER OF ELEMENTS IN DECIMATED LIST, record group velocity
vel(1)=mean(d2o(lst(:,6:7)));%average velocity
vdev=zeros(floor(Tfinal/store_decimation)+1, 1);%record velocity stdev
vdev(1)=std(lst(:,4));%average velocity
as=zeros(floor(Tfinal/store_decimation)+1, 1);
as(1)=mean(AS);
cr=zeros(floor(Tfinal/store_decimation)+1, 1);
cr(1)=numel(I);
dmur=zeros(floor(Tfinal/store_decimation)+1, 1);

% cm=jet(200);
% START SIMULATION   %---finished intitialization, contact data
for t=2:Tfinal
%     t
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
    for j=1:size(IDpairs,1)
        CM{IDpairs(j,1)}=[t, lst(IDpairs(j,2),4); CM{IDpairs(j,1)}];%record time of contact (here t=1) into column 1 and speed of contacting neighbor in col 2
        CM{IDpairs(j,2)}=[t, lst(IDpairs(j,1),4); CM{IDpairs(j,2)}];
    end
end
for p=1:Np%find AS being received by each ant
    if isempty(CM{p})==0
    AS(p,1)=ASoC(CM{p}(:,1), t, delay_decay, CM{p}(:,2), lst(p,4), Veq);
    else
        AS(p,1)=exp(0)*sr2(lst(p,4)-Veq);%if no contacts yet use only second term (self contact) in ASoC
    end
end
%CONTINUOUSLY update each ant's speed as a function of its own speed and its AS-----------
for p=1:Np
    DMU(p)=dmu(lst2(p,4), AS(p), F(p,1), F(p,2), F(p,3), Veq, ASeq);
lst2(p,4)=lst2(p,4)+DMU(p);%change speed by delta-mu**********0000****00000 :) :) :) :) :) :) :) :) :) :) :) :) :) :) :) :) :) :) :) :) :) 
if lst2(p,4)<Vmin%cant have negative velocity
    lst2(p,4)=Vmin;
end
end

% if mod(t,CM_decimation)==0
%     for p=1:Np
%         CM{p}=CM{p}(CM{p}(:,1)>(t-CM_decimation), :);%clears out old contacts which contribute very little, frees up memory
%     end
% end

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
cr(c,1)=numel(I);%total contacts in this frame
dmur(c,1)=mean(DMU);
end

end
%now PLOT ----------------------
% figure(4)
% whitebg([1 1 1])
% plot(fr, vel, '-'); hold on
% % plot(fr, vdev, 'b-')
% % ylim([0, 1])
% xlabel('Iteration number', 'fontsize',14)
% ylabel('Average Velocity (mm/s)', 'fontsize',14)
% title(num2str(Vhwidth))
% pause(0.1)

end
