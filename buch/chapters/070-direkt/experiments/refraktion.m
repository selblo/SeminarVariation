%
% refraktion.m
%
% (c) 2024 Prof Dr Andreas Müller
%
global n;
n = 10;
global nu;
nu = 0.2;
global	m;
m = 100;
global	fehlerueberhoehung;
fehlerueberhoehung = 100;

global diffcounter;
diffcounter = 0;

%
% Brechungsindex
%
function retval = brechungsindex(y)
	global	nu;
	retval = 1 + nu * y;
end

%
% Y-Funktion
%
function retval = Y(a, x)
	global	n;
	n = size(a)(1,2);
	k = 2 * (1:n) - 1;
	summanden = a .* arrayfun(@sin, k * x);
	retval = sum(summanden);
end

%
% Y'-Funktion
%
function retval = Yprime(a, x)
	global	n;
	n = size(a)(1,2);
	k = 2 * (1:n) - 1;
	summanden = a .* k .* arrayfun(@cos, k * x);
	retval = sum(summanden);
end

%
% Integrand
%
function retval = integrand(a, x)
	global	nu;
	retval = brechungsindex(Y(a, x)) * sqrt(1 + Yprime(a, x)^2);
end

%
% Integrand für partielle Ableitungen
%
function retval = integrandabl(a, x)
	global	diffcounter;
	diffcounter = diffcounter + 1;
	global	n;
	global	nu;
	y = Y(a, x);
	yp = Yprime(a, x);
	n = size(a)(1,2);
	k = 2 * (1:n) - 1;
	% erster Summand
	s1 = nu * arrayfun(@sin, k * x) * sqrt(1 + yp^2);
	% zweiter Summand
	s2 = k .* arrayfun(@cos, k * x) * yp * brechungsindex(y) / sqrt(1 + yp^2);
	% Summe
	abl = s1 + s2;
	retval = abl';
end

%
% Funktionen für lsode
%
global aparameter;

function retval = funktion(y, x)
	global	aparameter;
	retval = [ integrand(aparameter, x) ];
end

function retval = funktionabl(y, x)
	global	aparameter;
	retval = integrandabl(aparameter, x);
end

%
% Funktion f
%
function	retval = integral(a)
	global	aparameter;
	aparameter = a;
	t = [ 0, pi ];
	x0 = [ 0 ];
	x = lsode(@funktion, x0, t);
	retval = x(2,1);
end

%
% Gradient von f als Funktion von a_k
%
function	retval = integralabl(a)
	global	aparameter;
	aparameter = a;
	n = size(aparameter)(1,2);
	t = [ 0, pi ];
	x0 = zeros(n, 1);
	x = lsode(@funktionabl, x0, t);
	retval = x(2,:);
end

%
% Gradient von f
%
function	retval = gradf(a)
	n = size(a)(1,2);
	retval = zeros(1, n);
	f0 = integral(a);
	h = 0.00001;
	for i = (1:n)
		d = zeros(1,n);
		d(1,i) = h;
		retval(1, i) = (integral(a + d) - f0) / h;
	end
end

function	retval = ablf(a)
	retval = integralabl(a);
end

%
% Lösung zeichnen
%
function	drawsolution(fn, name, a)
	n = 100;
	x = linspace(0, pi, n);
	fprintf(fn, "\\def\\%s{\n", name);
	fprintf(fn, "\t({%.5f*\\dx},{%.5f*\\dy})\n", x(1), Y(a, x(1)));
	for i = (2:n)
		fprintf(fn, "\t-- ({%.5f*\\dx},{%.5f*\\dy})\n",
			x(i), Y(a, x(i)));
	end
	fprintf(fn, "}\n");
end

function	drawerror(fn, name, a)
	global dglloesung;
	global	fehlerueberhoehung;
	n = 100;
	x = linspace(0, pi, n);
	fprintf(fn, "\\def\\%s{\n", name);
	fprintf(fn, "\t({%.5f*\\dx},{%.4f*\\dy})\n", x(1),
		fehlerueberhoehung * (Y(a, x(1)) - dglloesung(1,1)));
	for i = (2:n)
		fprintf(fn, "\t-- ({%.5f*\\dx},{%.5f*\\dy})\n",
			x(i), fehlerueberhoehung * (Y(a, x(i)) - dglloesung(i,1)));
	end
	fprintf(fn, "}\n");
end

%
% Gradientabstieg
%
function a = loesung(n, a, alpha)
	counter = 0;
	d = 1;
	while ((counter < 1000) & (d > 0.000001))
		g = ablf(a);
		d = norm(g);
		counter = counter + 1;
		a = a - alpha * g;
		g(2,:) = a;
		g = circshift(g, 1, 1);
		g'
	end
end

a = zeros(1, n);
a(1,1) = -0.2;

format long

%integral(a)
%ablf(a)'
%gradf(a)'
%
%diffcounter
%
%n = 2;
%
%a = zeros(1, n);
%a(1,1) = -0.2;
%
%format long
%
%integral(a)
%ablf(a)'
%gradf(a)'
%
%diffcounter
%
%exit(0)

%a(1,1) = 1;
%integral(a)
%ablf(a)
%gradf(a)
%a(1,1) = -1;
%integral(a)
%ablf(a)
%gradf(a)
%a(1,1) = -2;
%integral(a)
%ablf(a)
%gradf(a)
%a(1,1) = -3;
%integral(a)
%ablf(a)
%gradf(a)

%
% Refraktionsdifferentialgleichung
%
function retval = refdgl(y, x)
	global	nu;
	retval = zeros(2,1);
	retval(1,1) = y(2,1); 
	retval(2,1) = (nu / brechungsindex(y(1,1))) * (1 + y(2,1)^2);
end

steigungen = [ -0.2, -0.4 ];
ziele = zeros(1,2);

y0 = zeros(2, 1);
y0(2,1) = steigungen(1,1);
x = [ 0, pi ];
y = lsode(@refdgl, y0, x);
ziele(1,1) = y(2,1);

y0(2,1) = steigungen(1,2);
x = [ 0, pi ];
y = lsode(@refdgl, y0, x);
ziele(1,2) = y(2,1);

steigungen
ziele

counter = 0;
while (norm(ziele) > 0.000001) & (counter < 100)
	counter = counter + 1;
	neuesteigung = mean(steigungen);
	y0(2,1) = neuesteigung;
	x = [ 0, pi ];
	y = lsode(@refdgl, y0, x);
	neuesziel = y(2,1)
	if (neuesziel < 0)
		steigungen(1,2) = neuesteigung;
		ziele(1,2) = neuesziel;
	else
		steigungen(1,1) = neuesteigung;
		ziele(1,1) = neuesziel;
	end
	ziele
end

x = linspace(0, pi, 100);
y0 = zeros(2, 1);
y0(2,1) = mean(steigungen);
global dglloesung;
dglloesung = lsode(@refdgl, y0, x);

fn = fopen("refraktionpath.tex", "w");

fprintf(fn, "\\def\\dglsol{\n");
fprintf(fn, "\t({%.4f*\\dx},{%.4f*\\dy})\n", x(1,1), dglloesung(1,1));
for i = (2:100)
	fprintf(fn, "\t-- ({%.4f*\\dx},{%.4f*\\dy})\n", x(1,i), dglloesung(i,1));
end
fprintf(fn, "}\n");

lsode_options("maximum step size", 0.01);

a = zeros(1,1);
a(1,1) = -0.27;

tabelle = zeros(6,6);

alpha = 0.1
a = loesung(1, a, alpha);
drawsolution(fn, "lone", a);
drawerror(fn, "eone", a);
tabelle(1:1,1) = a';

alpha = alpha / 2;
a(1,2) = 0;
a = loesung(2, a, alpha);
drawsolution(fn, "ltwo", a);
drawerror(fn, "etwo", a);
tabelle(1:2,2) = a';

alpha = alpha / 2;
a(1,3) = 0;
a = loesung(3, a, alpha);
drawsolution(fn, "lthree", a);
drawerror(fn, "ethree", a);
tabelle(1:3,3) = a';

alpha = alpha / 2;
a(1,4) = 0;
a = loesung(4, a, alpha);
drawsolution(fn, "lfour", a);
drawerror(fn, "efour", a);
tabelle(1:4,4) = a';

alpha = alpha / 2;
a(1,5) = 0;
a = loesung(5, a, alpha);
drawsolution(fn, "lfive", a);
drawerror(fn, "efive", a);
tabelle(1:5,5) = a';

alpha = alpha / 2;
a(1,6) = 0;
a = loesung(6, a, alpha);
drawsolution(fn, "lsix", a);
drawerror(fn, "esix", a);
tabelle(1:6,6) = a';

tabelle

fprintf(fn, "\\def\\tabelleninhalt{\n");
for i = (1:6)
	fprintf(fn, "%d", i);
	for k = (1:6)
		if (k >= i)
			fprintf(fn, "&%10.6f", tabelle(i, k));
		else
			fprintf(fn, "&           ");
		end
	end
	if (i == 1)
		fprintf(fn, "\\mathstrut\\rlap{\\raisebox{3pt}{\\strut}}\\\\\n");
	elseif (i == 6)
		fprintf(fn, "\\mathstrut\\\\[3pt]\n");
	else
		fprintf(fn, "\\mathstrut\\\\\n");
	end
end
fprintf(fn, "}\n");

fprintf(fn, "\\def\\steigungen{\n");
for i = (1:6)
	a = tabelle(1:i, i)';
	yp = Yprime(a, 0);
	fprintf(fn, "%d & %12.6f ", i, yp);
	if (i == 1)
		fprintf(fn, "\\rlap{\\raisebox{3pt}{\\strut}}\\\\\n");
	elseif (i == 6)
		fprintf(fn, "\\\\[2pt]\n");
	else
		fprintf(fn, "\\\\\n");
	end
end
fprintf(fn, "\\hline\n");
fprintf(fn, "\\infty & %12.6f \\rlap{\\raisebox{3pt}{\\strut}}\\\\[2pt]\n", mean(steigungen));
fprintf(fn, "}\n");

fclose(fn);
