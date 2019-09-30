close all
clear all

load Omega_des


% ---------------------------
% Calcolo del modulo di omega (velocità angolare), i picchi sui grafici
% rappresentano i punto di ZENIT dell'orbita, ovvero sorvolo esatto del
% punto di osservazione

omega = (Omega_des.signals.values);
for index = 1:length(omega)
    momega(index) = norm(omega(index,:),2);
end

% plot dei omega di picco ottenuti
Imax = [];
k = 0;
for index = 2:length(omega)-1,
    if (momega(index)> momega(index-1)) && (momega(index)>momega(index+1))
        Imax = [Imax; index];
    end
end

plot(Imax,momega(Imax),'o')
hold on
plot(momega)
hold off


% ---------------------------
% Determinazione delle matrici di rotazione tra uno zenit e il successivo,
% per determinare i quaternioni, e successivamente i valori delle velocità
% angolari da applicare 

load('R_ECEF_2_B.mat');

R_ECEF_2_B = R_ECEF_2_B.signals.values;
result = zeros(3,3,10);

% All'interno della matrice 3 x 3 x length(Imax) vengono memorizzate le 
% matrici di rotazione tra uno ZENIT e il successivo
for i = 2:length(Imax)
    result(:,:,i) = R_ECEF_2_B(:,:,Imax(i))*R_ECEF_2_B(:,:,Imax(i-1))';
end


% ---------------------------
% Conversione in quaternioni, per ottenere successicamente la forma in
% asse/angolo. Il vettore quaternions contiene i quaternioni dei punti
% masimi identificati precedentemente
quaternions = zeros(10,4);
for i = 1:length(result)
    quaternions(i,:) = rotm2quat(result(:,:,i));
end


% ---------------------------
% Conversione da quaternioni al rappresentazione asse/angolo, dove i primi
% 3 elementi di ogni vettore rappresentano gli assi, mentre l'ultimo valore
% rappresenta l'angolo
axang = zeros(10,4);
for i = 1:length(result)
    axang(i,:) = quat2axang(quaternions(i,:));
end


% ---------------------------
% Determinazione delle nuove velocità angolari da imporre che hanno valori
% lineari, in funzione dell'integrale di qualcosa... 