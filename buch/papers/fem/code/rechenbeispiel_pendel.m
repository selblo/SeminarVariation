%% Beispiel: Pendel
% u'' + g/l*u = 0

% Dauer und Zeitschritt
T = 4;
deltat = 0.1;
n = T/deltat + 1;

% Pendelparameter
 % Pendellänge
l = 1;
 % Schwerkraft
g = 10;
 % Startwinkel
u0 = 0.175;

% Nebendiagonale 
ndiag = [zeros(1,n) ; [eye(n-1, n-1) zeros(n-1,1)]];

% L befüllen
 % Diagonale
L = (2/3 * g/l * deltat - 2/deltat) * eye(n, n);
L(1,1) = L(1,1) / 2;
L(n,n) = L(n,n) / 2;
 % Nebendiagonale
Lndiag = (1/6 * g/l * deltat + 1/deltat) * ndiag;
L = L + Lndiag + transpose(Lndiag);

% b erstellen
b = zeros(n, 1);

% Ausgangsbedingunen einfügen (u(0) = u(l) = 0)
 % u(0) = pi/2
b = b + L(:,1)*u0;
L(1,:) = zeros(1, n);
L(:,1) = [1;zeros(n-1, 1)];
b(1) = -u0;
 % "u'(0) = 0" -> Schwäche d. linearen approx.
u1 = u0;
b = b + L(:,2)*u1;
L(2,:) = zeros(1, n);
L(:,2) = [0;1;zeros(n-2, 1)];
b(2) = -u1;

% Matrix invertieren, um Resultat zu berechnen
u = L\-b;

% Symbolische Lösung mit Matlab bestimmen
syms u_(t);
ode = diff(u_, t, 2) + (g/l) * u_ == 0;
cond1 = u_(0) == u0;
du = diff(u_, t);
cond2 = du(0) == 0;
SymbolicSolution=dsolve(ode, cond1, cond2);
tsol = linspace(0, T, 1000);
u_ = matlabFunction(SymbolicSolution);
usol = u_(tsol);

% Plotten der Resultate
t = linspace(0, T, n);
plot(t, u, tsol, usol);