%
% kugel.m -- Differentialgleichung für Geodäten auf einer Kugel
%
% (c) 2024 Prof Dr Andreas Müller
%
global	n;
n = 100;

%
% Koordinaten: phi, theta
%

function xdot = f(x, s)
	phi = x(1,1);
	theta = x(2,1);
	xdot = [
		x(3,1);					% \dot{phi}
		x(4,1); 				% \dot{theta}
		-2 * cot(theta) * x(3,1) * x(4,1);	% \ddot{phi}
		(1/2) * sin(2*theta) * x(3,1)^2		% \ddot{theta}
	];
end

function x = geodaete(alpha, smax)
	global	n;
	x0 = [ 0; pi/2; cos(alpha); -sin(alpha)];
	t = linspace(0, smax, n);
	x = lsode(@f, x0, t);
	x(:,5) = t;
	x = circshift(x, 1, 2);
end

function punkt(fd, x)
	phi = x(1,2);
	theta = x(1,3);
	fprintf(fd, "< %.4f, %.4f, %.4f >",
		cos(phi) * sin(theta), cos(theta), sin(phi) * sin(theta));
end

function sphere(fd, x)
	fprintf(fd, "\tsphere { ");
	punkt(fd, x(1,:));
	fprintf(fd, ", r }\n");
end

function segment(fd, x1, x2)
	fprintf(fd, "\tcylinder { ");
	punkt(fd, x1(1,:));
	fprintf(fd, ", ");
	punkt(fd, x2(1,:));
	fprintf(fd, ", r }\n");
end

function zeichne(fd, name, x)
	fprintf(fd, "#macro %s()\n", name);
	n = size(x)(1,1);
	for i = (2:n)
		segment(fd, x(i-1,:), x(i,:));
		sphere(fd, x(i,:));
	end
	fprintf(fd, "#end\n");
end

fd = fopen("kugel.inc", "w");
winkel = linspace(0,160,9);
for i = (1:9)
	x = geodaete(winkel(i) * pi/180, 6);
	name = sprintf("pfad%c", char(96 + i));
	zeichne(fd, name, x);
end
fclose(fd);
