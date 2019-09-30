clear all;
close all;
Earth = wgs84Ellipsoid;

load('POSS_ECEF.mat');
load('PSAT_ECEF.mat');
load('Omega_des.mat');

time = PSAT_ECEF.time;
PSAT_ECEF = PSAT_ECEF.signals.values;
PSAT_ECEF = PSAT_ECEF';

%posizione dell'osservatore in latitudine e longitudine
lo_oss= 12.356088*pi/180;
la_oss= 43.119091*pi/180;
Poss = (POSS_ECEF.signals.values(1,:))';

%matrice di rotazione NED rispetto ECEF
zoss = -[cos(lo_oss)*cos(la_oss);sin(lo_oss)*cos(la_oss);sin(la_oss)];
yoss =  [-sin(lo_oss);cos(lo_oss);0];
xoss =  [-sin(la_oss)*cos(lo_oss);-sin(la_oss)*sin(lo_oss);cos(la_oss)];
RECEF_2_NED = [xoss,yoss,zoss];

%posizione del satellite in NED
PSAT_NED = (RECEF_2_NED')*PSAT_ECEF;

%posizione relativa all'osservatore in ECEF
PrelE = (PSAT_ECEF-Poss*ones(1,length(time)));
Prel = RECEF_2_NED'*PrelE;
PrelFilter=Prel;

rdaoss=sqrt(PrelFilter(1,:).^2+PrelFilter(2,:).^2+PrelFilter(3,:).^2);
el=-asin(PrelFilter(3,:)./rdaoss)*180/pi;
el(find(el<15))=0;
PrelFilter(3,:)=(-sin(el*(pi/180))).*rdaoss;%prel(3,ivis)

position = zeros(size(Prel(3,:)));
Ivis=find(Prel(3,:)<0);
position(Ivis)=1;

positionFilter = zeros(size(PrelFilter(3,:)));
Ivis2=find(PrelFilter(3,:)<0);
positionFilter(Ivis2)=1;

%grafico
figure(1)
hold on
title('Velocità angolari e sorvolo');
legend on;
plot(time, position)
plot(time, positionFilter,'g')
plot(time, Omega_des.signals.values*100)
%plot(time, PSAT_NED(3,:)*10^(-6))
hold off



figure(2)
plot3(PSAT_ECEF(1,:),PSAT_ECEF(2,:),PSAT_ECEF(3,:));
grid on
title('Sorvolo satellite');
hold on
[x,y,z] = ellipsoid(0,0,0,Earth.SemimajorAxis,Earth.SemiminorAxis,(6400)*1000,20);
surf(x,y,z)
axis('equal')
plot3(PSAT_ECEF(1,Ivis),PSAT_ECEF(2,Ivis),PSAT_ECEF(3,Ivis),'.r')
plot3(PSAT_ECEF(1,Ivis2),PSAT_ECEF(2,Ivis2),PSAT_ECEF(3,Ivis2),'.g')

    