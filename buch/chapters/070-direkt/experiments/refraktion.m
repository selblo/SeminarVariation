%
% refraktion.m
%
% (c) 2024 Prof Dr Andreas Müller
%
global n;
n = 5;
global nu;
nu = 0.2;
global	m;
m = 100;

%
% Integrand
%
function retval = integrand(a, x)
	global	n;
	global	nu;
	n = size(a)(1,2);
	y = arrayfun(@sin, (1:n) * x);
	retval = (1 + nu * sum(y)) * sqrt(1 + sum(y .* y));
end

%
%  
%
global aparameter;

function retval = funktion(y, x)
	y
	x
	global	aparameter;
	retval = [ integrand(aparameter, x) ];
end

%
% Funktion f
%
function	retval = integral(a)
	global	aparameter;
	aparameter = a;
	t = [ 0, pi ];
	x0 = [ 0 ];
funktion(x0)
	x = lsode(@funktion, x0, t)
	retval = x(2,1);
end

a = (1:n);

integral(a)
