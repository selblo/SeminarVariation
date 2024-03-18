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

%
% Integrand
%
function retval = integrand(a, x)
	global	n;
	global	nu;
	n = size(a)(1,2);
	y = arrayfun(@sin, (1:n) * x);
	y = a .* y;
	retval = (1 + nu * sum(y)) * sqrt(1 + sum(y .* y));
end

%
%  
%
global aparameter;

function retval = funktion(y, x)
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
	x = lsode(@funktion, x0, t);
	retval = x(2,1);
end

%
% Gradient von f
%
function	retval = gradf(a)
	n = size(a)(1,2);
	retval = zeros(1, n);
	f0 = integral(a);
	h = 0.001;
	for i = (1:n)
		d = zeros(1,n);
		d(1,i) = h;
		retval(1, i) = (integral(a + d) - f0) / h;
	end
end

a = zeros(1, n);

format long

integral(a)
gradf(a)
a(1,1) = 1;
integral(a)
gradf(a)
a(1,1) = -1;
integral(a)
gradf(a)
a(1,1) = -2;
integral(a)
gradf(a)
a(1,1) = -3;
integral(a)
gradf(a)

a = zeros(1,n);
alpha = 0.8;
for i = (1:100)
	g = gradf(a);
	a = a - alpha * g;
	g(2,:) = a;
	g = circshift(g, 1, 1);
	g'
end
