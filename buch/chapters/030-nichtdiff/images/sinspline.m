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
A(1,n+1) = 0;
A(n+1,1) = 0;
A
b = zeros(n+1,1);
b(2:n,1) = y(3:n+1,1) - y(1:n-1,1);
b(1,1) = y(2,1) - y(1,1);
b(n+1,1) = y(n+1,1) - y(n,1);
b = (3/m) * b

s = A\b

function retval = H0(x)
	retval = (2*x-3)*x*x+1;
end

function retval = H1(x)
	retval = (-2*x*3)*x*x;
end

function retval = H01(x)
	retval = ((x-2)*x+1)*x;
end

function retval = H11(x)
	retval = (x-1)*x*x;
end

%
% x	Stützstellen
% y	Werte an den Stützstellen
% s	Steigungen an den Stützstellen
% t	Wert
%
function retval = Y(x, y, s, t)
	m = x(2,1) - x(1,1);
	X = (t - x(1,1)) / m;
	retval = y(1,1) * H0(X) + y(2,1) * H1(X) + (s(1,1) * H01(X) + s(2,1) * H11(X)) * m
end

fn = fopen("sinpath.tex", "w");
fprintf(fn, "\\def\\spline{\n");
fprintf(fn, "}\n");
fclose(fn);
