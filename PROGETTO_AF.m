%% PROGETTO - GRUPPO AF

%TRACCIA 3C - CONTROLLI AUTOMATICI
%INGEGNERIA INFORMATICA - UNIVERSITÀ DI BOLOGNA
%Miro Daniel Rajer   Giorgio Mocci   Simone Badiali

s = tf('s');

omega_plot_min = 1e-4; 
omega_plot_max = 1e4; 

%PARAMETRI PROGETTO
beta = 0.3;
massa = 0.15;
e_i = 0.47; %distanza deformazione-centro
inerzia = 0.75;
mu_d = 0.012; %attrito dinamico
W = 4; %ampiezza del riferimento w(t)
omega_n = 120; %disturbo di misura n(t) da attenuare di An
M_n = 0.025; %ampiezza disturbo di misura in simulazione
A_n = 30; %attenuazione n(t)
h = 1;
Ta_h = 4; %tempo di assesamento all'1%
S_star = 1; %vincolo sovraelongazione
Teta_zero = -pi/2;
omega_e = 1590; %velocità angolare d'equilibrio

u_e = -omega_e*(-beta - mu_d*massa*omega_e*e_i*e_i); %ingresso di equilibrio
disp("Ingresso di equilibrio");
disp(u_e);

%MATRICI
A = (-beta-2*mu_d*massa*omega_e*e_i*e_i)/(massa*e_i*e_i + inerzia);
B = 1/(massa*e_i*e_i + inerzia);
C = 1;
D = 0;


GG = B/((s - A)); %FUNZIONE DI TRASFERIMENTO
GG = zpk(GG);
disp("Funzione di Trasferimento G(s)");
display(GG);
%BODE PLOT DELLA FUNZIONE DI TRASFERIMENTO GG
figure(1);
title("BODE PLOT OF G(s)");
grid on, zoom on, hold on;
%bodeplot(GG,{omega_plot_min,omega_plot_max});
bode(GG);
margin(GG); %grafica i margini di fase e ampiezza e la pulsazione critica

Rs = 1/s; %da specifica errore a infito nullo -> polo nell'origine
Ge = Rs*GG; % SISTEMA ESTESO
disp("Sistema esteso");
display(Ge);
%BODE PLOT DEL SISTEMA ESTESO Ge
figure(2);
title("BODE PLOT OF Ge(s)");
grid on, zoom on, hold on;
bode(Ge);
%bodeplot(Ge,{omega_plot_min,omega_plot_max});
margin(Ge); 

xi_star = 0.85; 
Mf_star = 85; % =100*xi_star
%dalle specifiche sulla S% otteniamo un margine di fase minimo di 85

omega_c_min = 460/(Mf_star*Ta_h); %dalle specifiche sul tempo di assestamento 
display(omega_c_min);


%a questo punto del percorso si nota dalla figura 2 come la omega_c=0.611
%mentre il vincolo è 1.3529

%il margine di fase è 73 mentre il vincolo è di 85

%dalla specifica sull'abbattimento del rumore di misura n(t) si ha che la
%nostra funzione deve stare sotto i -30db per omega>120



figure(3);
title("Mappatura specifiche - diagramma di Ge");
zoom on, grid on;
hold on;
x1 = [omega_n omega_plot_max omega_plot_max omega_n];
y1 = [-30 -30 100 100];
patch(x1, y1, 'red'); %vincolo su n(t)

x2 = [omega_c_min omega_n omega_n omega_c_min];
y2 = [-1 -1 1 1];
patch(x2, y2, 'black'); %vincolo su omega_c

%bode(Ge);
bodeplot(Ge,{omega_plot_min,omega_plot_max});
margin(Ge);

x3 = [omega_c_min omega_n omega_n omega_c_min];
y3 = [-270 -270 -180+Mf_star -180+Mf_star];
patch(x3, y3, 'g'); %vincolo su margine di fase


%REGOLATORE DINAMICO
% si procede alla sintesi del regolatore dinamico: si scelgono i paramentri
% per il calcolo di polo e zero

omega_cStar=2.91; 
phi_star= 70;
M_star =3.68; 
mu = 2; %guadagno

tau= (M_star - cosd(phi_star))/(omega_cStar * sind(phi_star));
polo=(cosd(phi_star) - 1/M_star)/(omega_cStar * sind(phi_star)); %atau

Rd=(1+tau*s)/(1+polo*s);

L = (mu*Ge*Rd);  %funzione d'anello (funzione di trasferimento in anello aperto)


%bode della L con i vincoli del grafico precedente
figure(4);
title("BODE PLOT OF L(s)");
zoom on, grid on;
hold on;
x1 = [omega_n omega_plot_max omega_plot_max omega_n];
y1 = [-30 -30 100 100];
patch(x1, y1, 'red');

x2 = [omega_c_min omega_n omega_n omega_c_min];
y2 = [-1 -1 1 1];
patch(x2, y2, 'black');

%bode(L);
bodeplot(L,{omega_plot_min,omega_plot_max});
margin(L);

x3 = [omega_c_min omega_n omega_n omega_c_min];
y3 = [-270 -270 -180+Mf_star -180+Mf_star];
patch(x3, y3, 'g');

disp("Funzione d'anello");
display(L);
display(zpk(L));

k = 5.5; %guadagno aggiuntivo calcolato con System Control Designer
F = k*L/(1+k*L); %funzione di sensitività complementare
disp("Funzione di sensitività complementare");
display(F);
display(zpk(F));
figure(6);
title("BODE PLOT OF F(s)");
bode(F);

figure(7);
title("Risposta al gradino della F");
%grafico con vincoli su tempo di assestamento e sovraelongazione della
%risposta al gradino della F
hold on;
grid on, zoom on;
x1 = [4 10 10 4];
y1 = [0 0 3.96 3.96]; 

x2 = [4 10 10 4];
y2 = [4.04 4.04 8 8];

x3 = [0 3.9 3.9 0];
y3 = [4.04 4.04 8 8];

patch(x1, y1, 'y');
patch(x2, y2, 'y');
patch(x3, y3, 'green');
step(W*F); %gradino di ampiezza W


S = 1/(1+L);
figure(8);
title("BODE PLOT OF S(s)");
bode(s);

R = mu*Rd*Rs;
figure(9);
title("BODE PLOT OF R(s)");
bode(R);
disp("Regolatore");
display(zpk(R));


%% animation script
[y_step, t_step] = step(W*F, 4.5);
%il vettore y_step contiene i valori della risposta al gradino di ampiezza
%W della F fino al tempo 4.5
pause('on');
T=t_step;  
Y=y_step;

fhand=figure(10);
clf; 


for i=1:1:length(T)  

    figure(10);
    clf;
    
    X1 = [-0.005 0.005 0.005 -0.005];
    Y1 = [-1 -1 0 0];
    patch(X1, Y1, 'b'); %supporto pale
    
    pala1=patch([-0.02 -0.02 0.02 0.02] ,[-e_i e_i e_i -e_i],'r'); 
    pala2=patch([-e_i e_i e_i -e_i] ,[-0.02 -0.02 0.02 0.02],'y'); 
    
    
    %assi
    xlim([-1 1])
    ylim([-1 1])

 
    INTEGRANDA = @(t) interp1(T, Y, t); %crea funzione a partire dal vettore
    integrale = integral(INTEGRANDA,0,T(i)); %integrale per trovare la posizione

    %didascalie
    dim = [0.45 0.45 0.4 0.4];
    tempi = sprintf('tempo = %d s', T(i));
    velocita = sprintf('omega = %d rad/s', Y(i)+omega_e);
    deltaomega = sprintf('deltaomega = %d rad/s', Y(i));
    label = {tempi, velocita, deltaomega};
    annotation('textbox',dim,'String',label,'FitBoxToText','on', 'BackgroundColor','white');

    %rotazioni
    rotate(pala1, [0 0 1], integrale/(2*pi)*360);
    rotate(pala2, [0 0 1], integrale/(2*pi)*360);

    pause(0.0001); %necessaria per migliorare la visualizzazione


end 


%Badiali Simone, Mocci Giorgio, Rajer Miro Daniel
%Università di Bologna - Ingegneria Informatica


return;

