%
% sinspline.m -- spline interpolation für 
%
% (c) 2024 Prof Dr Andreas Müller
%
n = 10;
m = pi / 20;
x = (0:n)' * m
y = arrayfun(@sin,x)
A = 4 * eye(n+1) + circshift(eye(n+1),1) + circshift(eye(n+1),-1);
A(1,1) = 2;
A(n+1,n+1) = 2;
A
b = zeros(n+1,1);
b(2:n,1) = y(3:n+1,1) - y(1:n-1,1);
b(1,1) = y(2,1) - y(1,1);
b(n+1,1) = y(n+1,1) - y(n,1);
b = (1/m) * b;

s = A\b
