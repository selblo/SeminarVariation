%
% meniskus.m
%
% (c) 2024 Prof Dr Andreas Müller
%
global	rho;
rho = 1;
global	g;
g = 1;
global	l;
l = 1;
global	N;
N = 100;
global	sigma;
sigma = 0.65;

function retval = fmeniskus(y, x)
	global	rho;
	global	g;
	retval = zeros(2,1);
	yp = y(2,1);
	retval(1,1) = yp;
	retval(2,1) = rho * g * y(1,1) * sqrt(1 + yp^2)^3;
end

x = linspace(0, l, N);
y0 = [ 0.01; 0 ];
y = lsode(@fmeniskus, y0, x);
y

function	kurvezeichnen(fn, name, y)
	n = size(y)(1,1)
	fprintf(fn, "\\def\\kurve%s{\n", name);
	fprintf(fn, "\t({%.4f*\\dx},{%.4f*\\dy})", -y(n,1), y(n,2));
	for i = (n-1:-1:1)
		fprintf(fn, "\n\t-- ({%.4f*\\dx},{%.4f*\\dy})",
			-y(i,1), y(i,2));
	end
	for i = (2:1:n)
		fprintf(fn, "\n\t-- ({%.4f*\\dx},{%.4f*\\dy}) %% %.4f",
			y(i,1), y(i,2), y(i,3));
	end
	fprintf(fn, "\n}\n");
end

function	retval = kurve(h0)
	global	l;
	global	N;
	x = linspace(0, l, N);
	y0 = [ h0; 0 ];
	size(x)
	y = lsode(@fmeniskus, y0, x);
	size(y)
	retval = x';
	retval(:,2:3) = y;
end

function	retval = k(h0)
	global 	sigma;
	ypl = sigma / sqrt(1 - sigma^2);
	global	l;
	x = [ 0, l ];
	y0 = [ h0; 0 ];
	y = lsode(@fmeniskus, y0, x);
	retval = y(2,2) - ypl;
end

fn = fopen("meniskuspaths.tex", "w");

kurvezeichnen(fn, "one", kurve(0.1));
kurvezeichnen(fn, "two", kurve(0.2));
kurvezeichnen(fn, "three", kurve(0.3));
kurvezeichnen(fn, "four", kurve(0.4));
kurvezeichnen(fn, "five", kurve(0.5));
kurvezeichnen(fn, "six", kurve(0.6));
kurvezeichnen(fn, "seven", kurve(0.7));
kurvezeichnen(fn, "eight", kurve(0.8));
%kurvezeichnen(fn, "nine", kurve(0.9));

h0 = fzero(@k, [0.5,0.6])

fprintf(fn, "\\def\\hzero{%.5f}\n", h0);

kurvezeichnen(fn, "final", kurve(h0));

fclose(fn);

