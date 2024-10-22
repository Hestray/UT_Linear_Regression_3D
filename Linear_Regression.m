% Reset the plots and the data available
clc
clear all
close all

%% Load & Plot Data
load('./proj_fit_38.mat');

% plot the identification input values
figure(1);

% PLEASE CLICK MAXIMIZE WINDOW IN ORDER TO PROPERLY SEE THE FIGURE
tiles             = tiledlayout(1, 2);
tiles.TileSpacing = "tight";
tiles.Padding     = "compact";
nexttile % tile no 1
[id_X1_grid, id_X2_grid] = meshgrid(id.X{1, 1}, id.X{2, 1});
id_data = scatter3(id_X1_grid, id_X2_grid, id.Y, 'filled'); % no color set
% id_data = scatter3(id_X1_grid, id_X2_grid, id.Y, 'filled', 'MarkerFaceColor', '#C70039');
xlabel('X_1'); ylabel('X_2'); zlabel('Y'); hold on;

%% Approximator Function
% appr(x, m) function at the end of the file

%% System of Linear Equations
% phi(x, m) function at the end of the file
% phi represents the regressors (basis functions)
m         = 2;
theta     = phi(id.X, m) \ id.Y';
y_id_appr = phi(id.X, m) * theta;
MSE_id    = mean((id.Y - y_id_appr') .^ 2, [1, 2])

id_approx = mesh(id.X{1, 1}, id.X{2, 1}, y_id_appr', 'EdgeColor', '#0072BD');
grid minor; shg
Legend1   = legend([id_data(1), id_approx], {'Real Output Values', 'Approximated Output Values'})
Legend1.Location = 'northwest';
title("Identification Data (MSE = " + MSE_id + ")");
view(25, 40)
hold off

title(tiles, 'Linear Regression fitting for degree 2', 'FontSize', 16, 'FontWeight', 'bold')
%% Validation on a Different Data Set (Validation set)
y_val_appr = phi(val.X, m) * theta;

nexttile % tile no 2
length_id  = length(id.X{1,1});
length_val = length(val.X{1,1});
y_val_approx_reduced         = y_val_appr(:, round(linspace(1, length_id, length_val)));
MSE_val                      = mean((val.Y - y_val_approx_reduced') .^ 2, [1, 2]);
[val_X1_grid, val_X2_grid]   = meshgrid(val.X{1, 1}, val.X{2, 1});

val_data   = scatter3(val_X1_grid, val_X2_grid, val.Y, 'filled'); hold on;
val_approx = mesh(val_X1_grid, val_X2_grid, y_val_approx_reduced', 'EdgeColor', '#0072BD');
grid minor; shg
Legend2 = legend([val_data(1), val_approx], {'Real Output Values', 'Approximated Output Values'})
Legend2.Location = 'northwest';
title("Validation Data (MSE = " + MSE_val + ")");
view(25, 40)
hold off

%% Trying Various Degrees (from 1 to 35)
m       = 1 : 35;
MSE_id  = [];
MSE_val = [];

for i = m
  % calculating the MSE for Identification dataset
  theta = phi(id.X, i) \ id.Y';
  y_id_appr = phi(id.X, i) * theta;
  MSE_id = [MSE_id, mean((id.Y - y_id_appr') .^ 2, [1, 2])];

  % calculating the MSE for Validation dataset
  y_val_appr = phi(val.X, i) * theta;
  y_val_approx_reduced = y_val_appr(:, round(linspace(1, 41, 31)));
  MSE_val = [MSE_val, mean((val.Y - y_val_approx_reduced') .^ 2, [1, 2])];
end

%% Plot the MSEs computed previously
figure(3);
subplot(221)
plot(m, MSE_id, 'LineStyle', '-', 'LineWidth', 2, 'Color', '#5F9EA0'); grid on
axis([1 35 0 inf])
xlabel('degree'); ylabel('MSE')
title('MSE for identification data')

subplot(223)
plot(m, MSE_val, 'LineStyle', '--', 'LineWidth', 2, 'Color', '#D2042D'); grid on
axis([1 35 0 inf])
xlabel('degree'); ylabel('MSE')
title('MSE for validation data')

subplot(2, 2, [2 4])
plot(m, MSE_id, 'LineStyle', '-', 'LineWidth', 2, 'Color', '#5F9EA0'); grid minor; hold on
plot(m, MSE_val, 'LineStyle', '--', 'LineWidth', 2, 'Color', '#D2042D')
legend("MSE_{id}", "MSE_{val}")
axis([1 35 -1 50])
xlabel('degree'); ylabel('MSE')
title('MSE comparation between datasets')
shg; hold off;

sgtitle('MSE for varying degree', 'FontSize', 16, 'FontWeight', 'bold')

[id_minimum id_index]   = min(MSE_id);
[val_minimum val_index] = min(MSE_val);

%% Function Definitions
% "Before R2024a: Local functions in scripts must be defined at the end of the file, after the last line of script code."
% The functions will be left at the end so it will be compatible with versions pre R2024a
function res = appr(x, m)
  res = [];
  for i = 0 : m - 1
    for j = i : m - i
      res = [res, x(1)^j * x(2)^i];
      if i ~= j
        res = [res, x(1)^i * x(2)^j];
      end
    end
  end
end % function for approximator

function res = phi(x, m)
  res = [];
  for i = 1 : length(x{1, 1})
    res = [res; appr([x{1, 1}(i), x{2, 1}(i)], m)];
  end
end % function for phi (regressor)
