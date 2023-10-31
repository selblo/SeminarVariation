%
% strainwave.m -- computation of strainwave curve (spoiler: not an ellipse)
%
% (c) 2023 Prof Dr Andreas Müller
%

%               3                                           2        3
%         (12 yp (x) + 12 yp(x)) ypp(x) yppp(x) + (3 - 21 yp (x)) ypp (x)
%(%o11) - ---------------------------------------------------------------
%                                4          2
%                              yp (x) + 2 yp (x) + 1

b = 1;
r = 2;
k = 1;

function retval = f(v, x)
	v
	dv = zeros(4,1);
	dv(1:3,1) = v(2:4,1);

	y = v(1,1);
	yp = v(2,1);
	ypp = v(3,1);
	yppp = v(4,1);

	num = (12 * yp^3 + 12 * yp) * ypp * yppp + (3 - 21 * yp^2) * ypp^3;
	den = yp^4 + 2 * yp^2 + 1;

	dv(4,1) =  -num / den
	retval = v;
end

t = linspace(0,2,21)
x0 = [ b; 0; -r; k ]

lsode(@f, x0', t)
