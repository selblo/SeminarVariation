%
% ga.m
% 
% (c) 2024 Prof Dr Andreas Müller
%

x0 = 1;
alpha = 0.2;

n = 20;
x = zeros(n+1, 2);
x(1,1) = x0;

for i = (2:n+1)
	f = 1 - 4 * alpha * x(i-1,1)^2;
	x(i,2) = 1-f;
	x(i,1) = x(i-1,1) * f;
end

format long

x
