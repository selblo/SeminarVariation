%
% eindim.m
%
% (c) 2024 Prof Dr Andreas Müller
%
global a;
global b;
global x0;
global r;
global q;
global s1;
global t1;
global n;
global h;

a = 1;
b = 1;
x0 = 1;
r = 1;
q = 1;
s1 = 1;
n = 50;
h = t1 / n;
t1 = 1;

function retval = ricatti(s,t)
	global a;
	global b;
	global q;
	global r;
	retval = -q + s * (s * (b^2/r) - 2*a);
end

function retval = ricatti2(xp, t)
	global a;
	global b;
	global q;
	global r;
	A = [
		 a, -b^2/r;
		-q, -a
	];
	retval = A * xp;
end

function retval = f(p0)
	global	t1;
	global	s1;
	t = [0, t1];
	xp0 = [ 0; p0 ];
	xp = lsode(@ricatti2, xp0, t);
	retval = xp(2,2) - s1;
end

p0 = fsolve(@f, 0.2)

t = linspace(0, t1, n);
xp0 = [ 0; p0 ];
xp = lsode(@ricatti2, xp0, t);
xp(:,3) = -(b/r) * xp(:,2);
xp

