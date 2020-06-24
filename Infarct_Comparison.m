% infract comparison to PAC and power
load('C:\Users\user\Documents\MATLAB\theta_gamma_coupling.mat')
load('C:\Users\user\Documents\MATLAB\theta_highGamma_coupling.mat')
load('SpkInfo.mat')
%%
% 2W
labels.W = {'2WA02','2WA05','2WA06','2WA07','2WA10'};
infarctPerc.W = [21.43 38.14 32.38 11.65 24.85];
infarctVol.W = [266.75 396.11 327.178 108.63 259.1];
iTGC.W = [thetaGammaCouple{29,'Ipsilateral(Left)'} thetaGammaCouple{30,'Ipsilateral(Left)'},...
          thetaGammaCouple{31,'Ipsilateral(Left)'} thetaGammaCouple{32,'Ipsilateral(Left)'},...
          thetaGammaCouple{34,'Ipsilateral(Left)'}];
cTGC.W = [thetaHighGammaCouple{29,'Contralateral(Right)'} thetaHighGammaCouple{30,'Contralateral(Right)'},...
          thetaHighGammaCouple{31,'Contralateral(Right)'} thetaHighGammaCouple{32,'Contralateral(Right)'},...
          thetaHighGammaCouple{34,'Contralateral(Right)'}];
iTHGC.W = [thetaHighGammaCouple{29,'Ipsilateral(Left)'} thetaHighGammaCouple{30,'Ipsilateral(Left)'},...
          thetaHighGammaCouple{31,'Ipsilateral(Left)'} thetaHighGammaCouple{32,'Ipsilateral(Left)'},...
          thetaHighGammaCouple{34,'Ipsilateral(Left)'}];
cTHGC.W = [thetaHighGammaCouple{29,'Contralateral(Right)'} thetaHighGammaCouple{30,'Contralateral(Right)'},...
          thetaHighGammaCouple{31,'Contralateral(Right)'} thetaHighGammaCouple{32,'Contralateral(Right)'},...
          thetaHighGammaCouple{34,'Contralateral(Right)'}];
% 1M
labels.M      = {'1M01','1M02','1M06','1M07'};
infarctPerc.M = [14.37 13.44 23.15 24.54];
infarctVol.M = [121.11 45.38 209.44 311.76];
iTGC.M = [thetaGammaCouple{19,'Ipsilateral(Left)'} thetaGammaCouple{22,'Ipsilateral(Left)'},...
          thetaGammaCouple{31,'Ipsilateral(Left)'} thetaGammaCouple{26,'Ipsilateral(Left)'}];
cTGC.M = [thetaHighGammaCouple{19,'Contralateral(Right)'} thetaHighGammaCouple{22,'Contralateral(Right)'},...
          thetaHighGammaCouple{25,'Contralateral(Right)'} thetaHighGammaCouple{26,'Contralateral(Right)'}];
iTHGC.M = [thetaHighGammaCouple{19,'Ipsilateral(Left)'} thetaHighGammaCouple{22,'Ipsilateral(Left)'},...
          thetaHighGammaCouple{25,'Ipsilateral(Left)'} thetaHighGammaCouple{26,'Ipsilateral(Left)'}];
cTHGC.M = [thetaHighGammaCouple{19,'Contralateral(Right)'} thetaHighGammaCouple{22,'Contralateral(Right)'},...
          thetaHighGammaCouple{25,'Contralateral(Right)'} thetaHighGammaCouple{26,'Contralateral(Right)'}];
% AEE
labels.E = {'EE03','EE04','EE06','EE07','EE08','EE09'};
infarctPerc.E = [12.21 18.21 29.08 24.16 17.03 36.59];
infarctVol.E = [94.25 221.10 201.99 128.13 118.44 254.37];
iTGC.E = [thetaGammaCouple{39,'Ipsilateral(Left)'} thetaGammaCouple{40,'Ipsilateral(Left)'},...
          thetaGammaCouple{41,'Ipsilateral(Left)'} thetaGammaCouple{42,'Ipsilateral(Left)'},...
          thetaGammaCouple{43,'Ipsilateral(Left)'} thetaGammaCouple{44,'Ipsilateral(Left)'}];
cTGC.E = [thetaHighGammaCouple{39,'Contralateral(Right)'} thetaHighGammaCouple{40,'Contralateral(Right)'},...
          thetaHighGammaCouple{41,'Contralateral(Right)'} thetaHighGammaCouple{42,'Contralateral(Right)'},...
          thetaHighGammaCouple{43,'Contralateral(Right)'} thetaHighGammaCouple{44,'Contralateral(Right)'}];
iTHGC.E = [thetaHighGammaCouple{39,'Ipsilateral(Left)'} thetaHighGammaCouple{40,'Ipsilateral(Left)'},...
          thetaHighGammaCouple{41,'Ipsilateral(Left)'} thetaHighGammaCouple{42,'Ipsilateral(Left)'},...
          thetaHighGammaCouple{43,'Ipsilateral(Left)'} thetaHighGammaCouple{44,'Ipsilateral(Left)'}];
cTHGC.E = [thetaHighGammaCouple{39,'Contralateral(Right)'} thetaHighGammaCouple{40,'Contralateral(Right)'},...
          thetaHighGammaCouple{41,'Contralateral(Right)'} thetaHighGammaCouple{42,'Contralateral(Right)'},...
          thetaHighGammaCouple{43,'Contralateral(Right)'} thetaHighGammaCouple{44,'Contralateral(Right)'}];
      
      
 %% Now Plot
 figure
 %Percentage vs Gamma
 subplot(4,2,1)
 hold on
 scatter(infarctPerc.W,iTGC.W,'r')
 scatter(infarctPerc.M,iTGC.M,'b')
 scatter(infarctPerc.E,iTGC.E,'k')
h =  lsline;
set(h(1),'color','r')
set(h(2),'color','b')
set(h(3),'color','k')

 title('Ipsi. % vs Gamma')
 ylabel('Commodulation')
 
  subplot(4,2,2)
 hold on
 scatter(infarctPerc.W,cTGC.W,'r')
 scatter(infarctPerc.M,cTGC.M,'b')
 scatter(infarctPerc.E,cTGC.E,'k')
h =  lsline;
set(h(1),'color','r')
set(h(2),'color','b')
set(h(3),'color','k')
 title('Con. % vs Gamma')
 
 % Percentage vs High Gamma
 subplot(4,2,3)
 hold on
 scatter(infarctPerc.W,iTHGC.W,'r')
 scatter(infarctPerc.M,iTHGC.M,'b')
 scatter(infarctPerc.E,iTHGC.E,'k')
h =  lsline;
set(h(1),'color','r')
set(h(2),'color','b')
set(h(3),'color','k')
 title('Ipsi. % vs High Gamma')
 ylabel('Commodulation')
 xlabel('Infarct %')
  subplot(4,2,4)
 hold on
 scatter(infarctPerc.W,cTHGC.W,'r')
 scatter(infarctPerc.M,cTHGC.M,'b')
 scatter(infarctPerc.E,cTHGC.E,'k')
h =  lsline;
set(h(1),'color','r')
set(h(2),'color','b')
set(h(3),'color','k')
 title('Con. % vs High Gamma')
 xlabel('Infarct %')
 
 
  %Volume vs Gamma
 subplot(4,2,5)
 hold on
 scatter(infarctVol.W,iTGC.W,'r')
 scatter(infarctVol.M,iTGC.M,'b')
 scatter(infarctVol.E,iTGC.E,'k')
h =  lsline;
set(h(1),'color','r')
set(h(2),'color','b')
set(h(3),'color','k')
 title('Ipsi. Vol vs Gamma')
 ylabel('Commodulation')
 
  subplot(4,2,6)
 hold on
 scatter(infarctVol.W,cTGC.W,'r')
 scatter(infarctVol.M,cTGC.M,'b')
 scatter(infarctVol.E,cTGC.E,'k')
h =  lsline;
set(h(1),'color','r')
set(h(2),'color','b')
set(h(3),'color','k')
 title('Con. Vol vs Gamma')
 
 % Percentage vs High Gamma
 subplot(4,2,7)
 hold on
 scatter(infarctVol.W,iTHGC.W,'r')
 scatter(infarctVol.M,iTHGC.M,'b')
 scatter(infarctVol.E,iTHGC.E,'k')
h =  lsline;
set(h(1),'color','r')
set(h(2),'color','b')
set(h(3),'color','k')
 title('Ipsi. Vol vs High Gamma')
 ylabel('Commodulation')
 xlabel('Infarct Vol (mm^3)')
 
  subplot(4,2,8)
 hold on
 scatter(infarctVol.W,cTHGC.W,'r')
 scatter(infarctVol.M,cTHGC.M,'b')
 scatter(infarctVol.E,cTHGC.E,'k')
h =  lsline;
set(h(1),'color','r')
set(h(2),'color','b')
set(h(3),'color','k')
 title('Con. Vol vs High Gamma')
 xlabel('Infarct Vol (mm^3)')
 groups = {'2Wk','1Mn','EES'};
 legend(groups)
 
 