% Parameter für den Zylinder
radius = 1;
height = 6;
theta = linspace(0, 2*pi, 100);
z = linspace(0, height, 100);

% Zylinder 3D Koordinaten
[Theta, Z] = meshgrid(theta, z);
X = radius * cos(Theta);
Y = radius * sin(Theta);

% Geodäten im 3D-Raum
z_line = linspace(1, 5, 100);
theta1 = linspace(1, 3, 100);          % Geodäte ohne Umrundung
theta2 = linspace(1, 3 + 2*pi, 100);   % Geodäte mit einer Umrundung
theta3 = linspace(1, 3 + 4*pi, 100);   % Geodäte mit zwei Umrundungen

% Erstellen einer neuen Figur
figure;

% 3D Zylinder Plot
subplot(1, 2, 1);
surf(X, Y, Z, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
hold on;

% Geodäten plotten
plot3(radius*cos(theta1), radius*sin(theta1), z_line, 'g', 'LineWidth', 2);
plot3(radius*cos(theta2), radius*sin(theta2), z_line, 'r', 'LineWidth', 2);
plot3(radius*cos(theta3), radius*sin(theta3), z_line, 'm', 'LineWidth', 2);

% Achsen und Beschriftungen
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Zylinder mit Geodäten');
grid on;

% 2D Zylinder-Oberfläche abrollen
subplot(1, 2, 2);

% Geodäte 1 im 2D Raum
phi1 = linspace(1, 3, 100);

% Geodäte 2 im 2D Raum
phi2 = linspace(1, 3 + 2*pi, 100);
phi2_wrapped = mod(phi2, 2*pi);

% Geodäte 3 im 2D Raum
phi3 = linspace(1, 3 + 4*pi, 100);
phi3_wrapped = mod(phi3, 2*pi);

% Zylinder-Oberfläche plotten
plot(phi1, z_line, 'g', 'LineWidth', 2);
hold on;

% Geodäte 2: Erstellen neuer Linien bei Überlauf
start_idx = 1;
for i = 2:length(phi2_wrapped)
    if phi2_wrapped(i) < phi2_wrapped(i-1)
        plot([phi2_wrapped(start_idx:i-1), 2*pi], [z_line(start_idx:i-1), z_line(i-1)], 'r', 'LineWidth', 2);
        start_idx = i;
        plot([0, phi2_wrapped(i)], [z_line(i-1), z_line(i)], 'r', 'LineWidth', 2);
    end
end
plot(phi2_wrapped(start_idx:end), z_line(start_idx:end), 'r', 'LineWidth', 2);

% Geodäte 3: Erstellen neuer Linien bei Überlauf
start_idx = 1;
for i = 2:length(phi3_wrapped)
    if phi3_wrapped(i) < phi3_wrapped(i-1)
        plot([phi3_wrapped(start_idx:i-1), 2*pi], [z_line(start_idx:i-1), z_line(i-1)], 'm', 'LineWidth', 2);
        start_idx = i;
        plot([0, phi3_wrapped(i)], [z_line(i-1), z_line(i)], 'm', 'LineWidth', 2);
    end
end
plot(phi3_wrapped(start_idx:end), z_line(start_idx:end), 'm', 'LineWidth', 2);

% Achsen und Beschriftungen
xlim([0 2*pi]);
ylim([0 6]);
xlabel('\phi');
ylabel('z');
title('Abgerollte Zylinderoberfläche');
grid on;
