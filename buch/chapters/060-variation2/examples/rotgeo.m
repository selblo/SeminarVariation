%
% rotgeo.m -- computation of geodesics on a surface of revolution
%
% (c) 2024 Prof Dr Andreas Müller
%
global b;
b = 0.5;
global n;
n = 100;
global phif;
phif = 0;

function retval = r(z)
	global	b;
	retval = sqrt(1 - z^2/b^2);
end

function retval = rp(z)
	global	b;
	retval = -z / (b^2 * r(z));
end

function retval = rpp(z)
	global	b;
	retval = -1 / (b^2 *  r(z)^(3/2));
end

function dotx = f(x, s)
	dotx = zeros(4,4);
	phi = x(1,1);
	z = x(2,1);
	rz = r(z);
	rpz = rp(z);
	rppz = rpp(z);
	dotphi = x(3,1);
	dotz = x(4,1);
	dotx = zeros(4,1);
	dotx(1,1) = dotphi;
	dotx(2,1) = dotz;
	dotx(3,1) = -2 * (rpz / rz) * dotphi * dotz;
	dotx(4,1) = (-rpz * rppz * dotz^2 + rz * rpz * dotphi^2) / (1 + rpz^2);
end

function punkt = flaeche(x)
	phi = x(1,1);
	z = x(1,2);
	rz = r(z);
	punkt = [ rz * cos(phi), z, rz * sin(phi) ];
end

function draw(fd, name, x)
	fprintf(fd, "#macro %s(vorzeichen)\n", name);
	n = size(x)(1,1);
	for i = (1:n-1)
		p1 = flaeche(x(i,:));
		p2 = flaeche(x(i+1,:));
		fprintf(fd, "\tsphere { <%.4f,%.4f*vorzeichen,%.4f>, r }\n",
			p1(1,1), p1(1,2), p1(1,3));
		phi2 = x(i, 1);
		z2 = x(i, 1);
		rz2 = r(z2);
		fprintf(fd,
			"\tcylinder { <%.4f,%.4f*vorzeichen,%.4f>, <%.4f,%.4f*vorzeichen,%.4f>, r }\n",
			p1(1,1), p1(1,2), p1(1,3),
			p2(1,1), p2(1,2), p2(1,3));
	end
	fprintf(fd, "\tsphere { <%.4f,%.4f,%.4f>, r }\n",
		p2(1,1), p2(1,2), p2(1,3));
	fprintf(fd, "#end\n");
end

function x = pfad(parameter)
	global	n;
	azi = parameter(1,1);
	l = parameter(2,1);
	s = linspace(0, l, n);
	x0 = [ 0; 0; cos(azi); sin(azi) ];
	x = lsode(@f, x0, s);
	x(n,:)
end

function retval = abweichung(parameter)
parameter
	global	phif;
	global	n;
	x = pfad(parameter);
	retval = [ phif - x(n,1); x(n,2) ];
end

function parameter = finde(zielwinkel)
	global	phif;
	phif = zielwinkel
	startwinkel = zielwinkel - pi/2;
	if (zielwinkel < 105 * pi/180)
		startwinkel = startwinkel + 20 * pi/180;
	end
	parameter0 = [ startwinkel; 2 ]
	parameter = fsolve(@abweichung, parameter0);
end

function kurve(fd, name, winkel)
	ziel = winkel * pi / 180;
	parameter = finde(ziel);
	x = pfad(parameter);
	draw(fd, name, x);
end


fd = fopen("geodesics.inc", "w");
kurve(fd, "ziel100", 100);
kurve(fd, "ziel110", 110);
kurve(fd, "ziel120", 120);
kurve(fd, "ziel130", 130);
kurve(fd, "ziel140", 140);
kurve(fd, "ziel150", 150);
kurve(fd, "ziel160", 160);
kurve(fd, "ziel170", 170);
fclose(fd);
