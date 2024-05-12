%
% kreis.m -- J-Kreis für die Lichtausbreitung in einem inhomogenen Medium
%
% (c) 2024 Prof Dr Andreas Müller
%
global	nu;
nu = 0.5;
global	N;
N = 129;

%
% Brechungsindex
%
function retval = n(y)
	global	nu;
	retval = 1 + nu * y;
end

%
% Lagrange-Funktion
%
function retval = L(y, yprime)
	retval = n(y) * sqrt(1 + yprime^2);
end

%
% y	ein Vektor mit 1025 Funktionswerten von y und y'
%       an den Stellen x0 + (k-1)(x1-x0)/1024
%
function retval = funktional(y, l)
	n = size(y)(1,1) - 1;	% Anzahl Teilintervalle

	% Trapezapproximation des Integrals
	T(1,1) = l * (L(y(1,2), y(1,3)) + L(y(n+1,2), y(n+1,3))) / 2;

	% Schrittgrösse für Integralberechnung
	step = n;	% Schrittgrösse
	i0 = n;		% Startindex für Untersumme
	
	% berechne Trapezapproximationen mit höherer Auflösung
	k = 2;
	while (i0 > 1)
		i0 = i0 / 2;
		% Berechnung der Trapezsumme
		s = 0;
		i = i0 + 1;
		while (i < n+1)
			s = s + L(y(i,2), y(i,3));
			i = i + step;
		end
		T(k, 1) = (T(k-1,1) + s * l) / 2;
		l = l / 2;
		k = k + 1;
		step = step / 2;
	end

	% accelerate the integral computation
	n = size(T)(1,1);
	k = 2;
	m = 4;
	while (k <= n)
		i = k;
		T(:,k) = zeros(n,1);
		while (i <= n)
			T(i,k) = (m * T(i,k-1) - T(i-1,k-1)) / (m-1);
			i = i + 1;
		end
		k = k + 1;
		m = 4 * m;
	end
	retval = T(n, n);
end

%
% Euler-Lagrange-Differentialgleichung
%
function yprime = f(y, x)
	global	nu;
	yp = y(2,1);
	yprime = [ yp; (yp+1) / (y(1,1)+1/nu) ];
end

%
% Lösung der Euler-Lagrange-Differentialgleichung
%
function y = loesung(anfangspunkt, anfangssteigung, x1)
	global	N;
	x0 = anfangspunkt(1,1);
	y0 = [ anfangspunkt(2,1), anfangssteigung ];
	x = linspace(x0, x1, N);
	y = lsode(@f, y0, x);
	y(:,3) = x';
	y = circshift(y, 1, 2);
end

%
% Hilfsfunktion zur Bestimmung des korrekten x1, mit dem der vorgegebene
% Zielwert des Funktionals erreicht werden kann
%
global	Janfangspunkt;
global	Janfangssteigung;
global	Jzielwert;
function abweichung = J(x1)
	global	Janfangspunkt;
	global	Janfangssteigung;
	global	Jzielwert;
	x0 = Janfangspunkt(1,1);
	y = loesung(Janfangspunkt, Janfangssteigung, x1);
	abweichung = funktional(y, x1 - x0) - Jzielwert;
end

%
% Loesungskurve für einen vorgegebenen Zielwert des Funktionals berechnen
%
function y = theta(anfangspunkt, anfangssteigung, zielwert)
	global	Janfangspunkt;
	global	Janfangssteigung;
	global	Jzielwert;
	Janfangspunkt = anfangspunkt;
	Janfangssteigung = anfangssteigung;
	Jzielwert = zielwert;
	x1 = anfangspunkt(1,1) + zielwert;
	x1 = fsolve(@J, x1);
	y = loesung(anfangspunkt, anfangssteigung, x1);
end

%
% Lösungspfad als pfad in TikZ zeichnen
%
function pfadzeichnen(fn, y)
	fprintf(fn, "({%.4f*\\dx},{%.4f*\\dy})", y(1,1), y(1,2));
	n = size(y)(1,1);
	for i = (2:n)
		fprintf(fn, "\n\t-- ({%.4f*\\dx},{%.4f*\\dy})", y(i,1), y(i,2));
	end
end

function pfadmacro(fn, name, y)
	fprintf(fn, "\\def\\%s{ ", name);
	pfadzeichnen(fn, y);
	fprintf(fn, "\n}\n");
end

%
% Kreis berechnen
%
%  anfangspunkt
%  yp = vektor von anfangssteigungen
%
function p = kreis(anfangspunkt, yp, zielwert)
	global	N;
	n = size(yp)(1,1);
	p = zeros(n,2);
	for i = (1:n)
		y = theta(anfangspunkt, yp(i,1), zielwert);
		p(i,:) = [ y(N,1), y(N,2) ];
	end
end

%
% Kreispfad
%
function kreispfad(fn, p)
	fprintf(fn, "({%.4f*\\dx},{%.4f*\\dy})", p(1,1), p(1,2));
	n = size(p)(1,1);
	for i = (2:n)
		fprintf(fn, "\n\t-- ({%.4f*\\dx},{%.4f*\\dy})", p(i,1), p(i,2));
	end
end

%
% Kreiszeichnen
%
function kreismacro(fn, name, p)
	fprintf(fn, "\\def\\%s{ ", name);
	kreispfad(fn, p);
	fprintf(fn, "\n}\n");
end

%
% Faecher
%
function faecher(fn, name, anfangspunkt, steigung, range)
	global	N;
	fprintf(fn, "\\def\\%s{\n", name);
	h = 2 * range / 11;
	for m = (-range:h:range)
		y = theta(anfangspunkt, steigung + m, 1);
		fprintf(fn, "\\draw[color=blue!20] ");
		pfadzeichnen(fn, y);
		fprintf(fn, ";\n");
	end
	fprintf(fn, "}\n");
	yp = linspace(steigung - range, steigung + range, 41)';
	p = kreis(anfangspunkt, yp, 1);
	fprintf(fn, "\\def\\kreis%s{", name);
	fprintf(fn, "\t({%.4f*\\dx},{%.4f*\\dy})", p(1,1), p(1,2));
	for j = (2:41)
		fprintf(fn, "\n\t-- ({%.4f*\\dx},{%.4f*\\dy})", p(j,1), p(j,2));
	end
	fprintf(fn, "\n}\n");
end

fn = fopen("kreispfad.tex", "w");

i = 1;
for yp = (-0.6:0.1:1.0)
	name = sprintf("pfad%c", char(96 + i));
	y = theta([0;0], yp, 2);
	pfadmacro(fn, name, y);

	% Kreis ausgehend vom Endpunkt zeichnen
	name = sprintf("faecher%c", char(96 + i));
	y = theta([0;0], yp, 1);
	range = (2 + 2 * yp) / 3;
	faecher(fn, name, [y(N,1);y(N,2)], y(N,3), range);

	% next
	i = i + 1;
end

p = kreis([0;0], linspace(-0.65,1.15,41)', 1);
kreismacro(fn, "kreiseins", p);
p = kreis([0;0], linspace(-0.75,1.45,61)', 2);
kreismacro(fn, "kreiszwei", p);

fclose(fn);
