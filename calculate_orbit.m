clear all
close all
Earth = wgs84Ellipsoid;

r_peri=(6400+400)*1000;
r_apo=(6400+400)*1000;
%r_peri=6783777;
%r_apo=6783777;

%r_apo=(6400+400)*1000;

%GM=6.67e-11*6e24;
GM=0.398601234780431e15;
Omega=0*pi/180; %long nodo ascendente
Ii=51.36049*pi/180;   %inclinazione
omega=135*pi/180; %long perigeo
R1=[cos(Omega),-sin(Omega),0;sin(Omega),cos(Omega),0;0,0,1];
R2=[1,0,0;0,cos(Ii),-sin(Ii);0,sin(Ii),cos(Ii)];
R3=[cos(omega),-sin(omega),0;sin(omega),cos(omega),0;0,0,1];
Rorbita=R1*R2*R3;
a=(r_apo+r_peri)/2;
e=(r_apo-r_peri)/(r_apo+r_peri);
%a=6783777.06;
%e=0.0005850;
T=2*pi*a^1.5/sqrt(GM);
Tterra=86164.090530833; %% giorno siderale
omegaterra=2*pi/Tterra;

t=0:10:Tterra*1.7242;

P=[];
for i=1:length(t);
    p=orbita(t(i),a,e,T,Rorbita,omegaterra);
    P=[P,p];
end
%satellite in ECEF
figure(1)
plot3(P(1,:),P(2,:),P(3,:)),grid
hold on
[x,y,z] = ellipsoid(0,0,0,Earth.SemimajorAxis,Earth.SemiminorAxis,(6400)*1000,20);
surf(x,y,z)
axis('equal')
hold on

%osservatore in ECEF
lo_oss=12*pi/180;
la_oss=44*pi/180;
r_oss=1/sqrt(((cos(la_oss)/Earth.SemimajorAxis)^2+(sin(la_oss)/Earth.SemiminorAxis)^2));
%calcolare usando la latitudine geodetica
Poss=r_oss*[cos(lo_oss)*cos(la_oss);sin(lo_oss)*cos(la_oss);sin(la_oss)];

plot3(Poss(1),Poss(2),Poss(3),'ok')

figure(2)
r=sqrt(P(1,:).^2+P(2,:).^2+P(3,:).^2);
la=asin(P(3,:)./r);
lo=atan2(P(2,:),P(1,:));
plot(lo*180/pi,la*180/pi),grid

%terna NED rispetto ECEF; calcolare usando latitudine geodetica
zoss=-[cos(lo_oss)*cos(la_oss);sin(lo_oss)*cos(la_oss);sin(la_oss)];
yoss=[-sin(lo_oss);cos(lo_oss);0];
xoss=[-sin(la_oss)*cos(lo_oss);-sin(la_oss)*sin(lo_oss);cos(la_oss)];
RECEF_2_NED=[xoss,yoss,zoss];
%posizione relativa all'osservatore in ECEF
PrelE=(P-Poss*ones(1,length(t)));
%posizione relativa all'osservatore in NED
Prel=RECEF_2_NED'*PrelE;

figure(3);
plot(t,Prel(3,:)/1000)

rdaoss=sqrt(Prel(1,:).^2+Prel(2,:).^2+Prel(3,:).^2);
eltot=asin(Prel(3,:)./rdaoss)*180/pi;
aztot=atan2(Prel(2,:),Prel(1,:))*180/pi;

figure(4)
%punti sopra l'orizzonte
Ivis=find(Prel(3,:)<0);
%Ivis=find(eltot<-15);
plot3(Prel(1,Ivis),Prel(2,Ivis),Prel(3,Ivis),'.');
xlabel('N');
ylabel('E');
zlabel('D');

rdaoss=sqrt(Prel(1,Ivis).^2+Prel(2,Ivis).^2+Prel(3,Ivis).^2);
el=-asin(Prel(3,Ivis)./rdaoss)*180/pi;
az=atan2(Prel(2,Ivis),Prel(1,Ivis))*180/pi;

figure(5);
plot(az,el,'.')
length(Ivis)/length(t)

figure(1)
plot3(P(1,Ivis),P(2,Ivis),P(3,Ivis),'.r')
