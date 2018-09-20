%% generate speed-signal response planes
% mu0=0;% Veq
% AS0=0; %ASeq
Np=426;
dmu=@(MU, AS, a, b, th, mu0, AS0) th*(-a*(MU-mu0)+b*(AS-AS0));%defines SSRP given parameters a, b > 0
a_m=10;
a_sig=2;
b_m=2;
b_sig=2;
gamma=0.002;
N=Np+100;%get some extra points which will be shaved off
F_a= random('norm', a_m, a_sig, [N,1]);
F_b= random('norm', b_m, b_sig, [N,1]);
% F_th=random('exp', th_gamma, [N,1]);%some very few ants are way too fast
F_th=gamma*rand(N,1);%uniform distribution works better
F=[F_a, F_b, F_th];
F((F(:,1)<=0)|(F(:,2)<=0)|(F(:,3)<=0),:)=[];%remove any rows with a, b<=0
F(Np+1:end,:)=[];
whitebg([1 1 1])
plot3(F(:,1), F(:,2), F(:,3), 'k+')
%% plot speed-signal-response planes
XMIN=-10; XMAX=10; YMIN=-10; YMAX=10; ZMIN=-.1; ZMAX=.1;
[MU, ASs]=meshgrid(XMIN:0.1:XMAX, YMIN:0.1:YMAX);%we define XX as mu and YY as AS
whitebg([1 1 1])
for j=1:1%length(F)
    figure(1)
%     surf(MU, ASs, dmu(MU, ASs, F(j,1), F(j,2), F(j,3), mu0, AS0)); 
    alpha(0.4);
    hold on
    line([XMIN XMAX], [0 0], [0 0],'Color','k','LineStyle','--','LineWidth',2); 
    line([0 0], [YMIN YMAX], [0 0],'Color','k','LineStyle','--','LineWidth',2); 
    line([0 0], [0 0], [ZMIN ZMAX],'Color','k','LineStyle','--','LineWidth',2); 
    camorbit(50,0)
%     axis equal
    axis([XMIN XMAX YMIN YMAX ZMIN ZMAX]); 
%     axis equal
    xlabel('s'); ylabel('AS'); zlabel('\Delta s'); grid on
    hold off
    pause(0.2)
end