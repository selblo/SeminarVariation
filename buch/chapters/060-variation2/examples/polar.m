%
% polar.m -- Differentialgleichung für Geodäten in Polarkoordinaten
%
% (c) 2024 Prof Dr Andreas Müller
%
global	n;
n = 100;

%
% Koordinaten: r, phi
%

function xdot = f(x, s)
	r = x(1,1);
	phi = x(2,1);
	xdot = [
		x(3,1);				% \dot{r}
		x(4,1); 			% \dot{phi}
		r * x(4,1)^2			% \ddot{r}
		-2 * (1/r) * x(3,1) * x(4,1);	% \ddot{phi}
	];
end

function x = geodaete(alpha, smax)
	global	n;
	x0 = [ 1; 0; cos(alpha); sin(alpha)];
	t = linspace(0, smax, n);
	x = lsode(@f, x0, t);
	x(:,5) = t;
	x = circshift(x, 1, 2);
end

function punkt(fd, x)
	r = x(1,2);
	phi = x(1,3);
	fprintf(fd, "({%.4f*\\dx},{%.4f*\\dy})", r * cos(phi), r * sin(phi));
end

function zeichne(fd, name, x)
	fprintf(fd, "\\def\\%s{\n\t", name);
	punkt(fd, x(1,:));
	n = size(x)(1,1);
	for i = (2:n)
		fprintf(fd, "\n\t-- ");
		punkt(fd, x(i,:));
	end
	fprintf(fd, "\n}\n");
end

fd = fopen("polarpfade.tex", "w");
winkel = linspace(0,170,18);
for i = (1:18)
	x = geodaete(winkel(i) * pi/180, 1);
	name = sprintf("pfad%c", char(96 + i));
	zeichne(fd, name, x);
end
fclose(fd);
