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
q = 10;
s1 = 10;
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

function H = hamiltonianMatrix()
	global a;
	global b;
	global q;
	global r;
	H = [
		 a, -b^2/r;
		-q, -a
	];
end

function retval = ricatti2(xp, t)
	retval = hamiltonianMatrix() * xp;
end

function retval = u(p)
	global	b;
	global	r;
	retval = -(b/r) * p;
end

function	xp = loesung(x0, s1)
	global	t1;
	global	n;
	S = expm(t1 * hamiltonianMatrix());
	p0 = -(s1 * S(1,2) - S(2,2))^(-1) * (s1 * S(1,1) - S(2,1)) * x0;
	t = linspace(0, t1, n);
	xp0 = [ x0; p0 ];
	xp = lsode(@ricatti2, xp0, t);
	xp(:,3) = u(xp(:,2));
	xp(:,4) = t';
	xp = circshift(xp,1,2);
end

function	zeichnen(fd, name, xp)
	global	q;
	global	r;
	n = size(xp)(1,1)
	fprintf(fd, "\\def\\xpath%s{\n", name);
	fprintf(fd, "\t({%.4f*\\dt},{%.4f*\\dx})", xp(1,1), xp(1,2));
	for i = (2:n)
		fprintf(fd, "\n\t-- ({%.4f*\\dt},{%.4f*\\dx})",
			xp(i,1), xp(i,2));
	end
	fprintf(fd, "\n}\n");
	fprintf(fd, "\\def\\ppath%s{\n", name);
	fprintf(fd, "\t({%.4f*\\dt},{%.4f*\\dP})", xp(1,1), xp(1,3));
	for i = (2:n)
		fprintf(fd, "\n\t-- ({%.4f*\\dt},{%.4f*\\dP})",
			xp(i,1), xp(i,3));
	end
	fprintf(fd, "\n}\n");
	fprintf(fd, "\\def\\upath%s{\n", name);
	fprintf(fd, "\t({%.4f*\\dt},{%.4f*\\du})", xp(1,1), xp(1,4));
	for i = (2:n)
		fprintf(fd, "\n\t-- ({%.4f*\\dt},{%.4f*\\du})",
			xp(i,1), xp(i,4));
	end
	fprintf(fd, "\n}\n");
	fprintf(fd, "\\def\\parameter%s{\n", name);
	fprintf(fd, "\\node at (0,0) [above right]\n");
	fprintf(fd, "{$\\renewcommand{\\arraycolsep}{1pt}\n");
	fprintf(fd, "\\begin{array}{rcr}\n");
	fprintf(fd, "q&=&%.1f\\mathstrut\\\\\n", q);
	fprintf(fd, "r&=&%.1f\\mathstrut\n", r);
	fprintf(fd, "\\end{array}$};\n");
	fprintf(fd, "}\n");
end

fd = fopen("paths.tex", "w");

q = 5
r = 4
xp = loesung(x0, s1)
zeichnen(fd, "eins", xp);

q = 10
r = 2
xp = loesung(x0, s1)
zeichnen(fd, "zwei", xp);

q = 20
r = 1
xp = loesung(x0, s1)
zeichnen(fd, "drei", xp);

q = 40
r = 1.5
xp = loesung(x0, s1)
zeichnen(fd, "vier", xp);
fclose(fd);
