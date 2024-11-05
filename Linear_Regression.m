% Reset the plots and the data available
tic % to checck elapsed time without Profiler

clc
clear all
close all

%% Load & Plot Data 
load('./proj_fit_38.mat');
% load('./proj_fit_07.mat');

% plot the identification input values
figure(1);

% PLEASE CLICK MAXIMIZE WINDOW IN ORDER TO PROPERLY SEE THE FIGURE
tiles             = tiledlayout(1, 2);
tiles.TileSpacing = "tight";
tiles.Padding     = "compact";
nexttile % tile no 1
[id_X1_grid, id_X2_grid] = meshgrid(id.X{1, 1}, id.X{2, 1});
id_data = scatter3(id_X1_grid, id_X2_grid, id.Y, 'filled'); % no color set
% id_data = scatter3(id_X1_grid, id_X2_grid, id.Y, 'filled', 'MarkerFaceColor', '#C70039'); % to visualize one color for all
xlabel('X_1'); ylabel('X_2'); zlabel('Y'); hold on;

%% System of Linear Equations
% phi(x, m) function at the end of the file
% phi represents the regressors (basis functions)
m         = 6;
Phi       = phi(id.X, m);
Y_id_reshape = (reshape(id.Y', [size(id.Y, 1)*size(id.Y, 2), 1]));
theta     = Phi \ Y_id_reshape;
y_id_appr = Phi * theta;
MSE_id    = mean((Y_id_reshape - y_id_appr) .^ 2)

id_approx = mesh(id.X{1, 1}, id.X{2, 1}, reshape(y_id_appr, [size(id.X{1, 1}, 2) size(id.X{2, 1}, 2)]), 'EdgeColor', '#0072BD', 'FaceColor', 'none');
grid minor;
Legend1   = legend([id_data(1), id_approx], {'Real Output Values', 'Approximated Output Values'});
Legend1.Location = 'northwest';
title("Identification Data (MSE = " + MSE_id + ")");
view(25, 40)
hold off

title(tiles, "Linear Regression fitting for degree " + m, 'FontSize', 16, 'FontWeight', 'bold')
%% Validation on a Different Data Set (Validation set)
Y_val_reshape = (reshape(val.Y', [size(val.Y, 1)*size(val.Y, 2), 1]));
y_val_appr = phi(val.X, m) * theta;

nexttile % tile no 2
length_id  = size(id.X{1, 1}, 2);
length_val = size(val.X{1, 1}, 2);
MSE_val                      = mean((Y_val_reshape - y_val_appr) .^ 2, [1, 2]);
[val_X1_grid, val_X2_grid]   = meshgrid(val.X{1, 1}, val.X{2, 1});

val_data   = scatter3(val_X1_grid, val_X2_grid, val.Y, 'filled'); hold on;
val_approx = mesh(val_X1_grid, val_X2_grid, reshape(y_val_appr, [size(val.X{1, 1}, 2) size(val.X{2, 1}, 2)]), 'EdgeColor', '#0072BD', 'FaceColor', 'none');
grid minor;
Legend2 = legend([val_data(1), val_approx], {'Real Output Values', 'Approximated Output Values'});
Legend2.Location = 'northwest';
title("Validation Data (MSE = " + MSE_val + ")");
view(25, 40)
hold off

%% Trying Various Degrees (from 1 to 35)
% m       = 1 : 25;
% size_m  = size(m, 2);
% MSE_id  = zeros(1, size_m);
% MSE_val = zeros(1, size_m);
% 
% for i = m
%   % calculating the MSE for Identification dataset
%   phi_id     = phi(id.X, i);
%   theta      = phi_id \ Y_id_reshape;
%   y_id_appr  = phi_id * theta;
%   MSE_id(i)  = mean((Y_id_reshape - y_id_appr) .^ 2, [1 2]);
% 
%   % calculating the MSE for Validation dataset
%   phi_val    = phi(val.X, i);
%   y_val_appr = phi_val * theta;
%   MSE_val(i) = mean((Y_val_reshape - y_val_appr) .^ 2, [1 2]);
% end
% 
% %% Plot the MSEs computed previously
% figure(3);
% subplot(221)
% plot(m, MSE_id, 'LineStyle', '-', 'LineWidth', 2, 'Color', '#5F9EA0'); grid on
% axis([1 25 0 inf])
% xlabel('degree'); ylabel('MSE')
% title('MSE for identification data')
% 
% subplot(223)
% plot(m, MSE_val, 'LineStyle', '--', 'LineWidth', 2, 'Color', '#D2042D'); grid on
% axis([1 25 0 inf])
% xlabel('degree'); ylabel('MSE')
% title('MSE for validation data')
% 
% subplot(2, 2, [2 4])
% plot(m, MSE_id, 'LineStyle', '-', 'LineWidth', 2, 'Color', '#5F9EA0'); grid minor; hold on
% plot(m, MSE_val, 'LineStyle', '--', 'LineWidth', 2, 'Color', '#D2042D')
% legend("MSE_{id}", "MSE_{val}")
% axis([1 25 -1 30])
% xlabel('degree'); ylabel('MSE')
% title('MSE comparation between datasets')
% hold off;
% 
% sgtitle('MSE for varying degree', 'FontSize', 16, 'FontWeight', 'bold')
% 
% [id_minimum id_index]   = min(MSE_id);
% [val_minimum val_index] = min(MSE_val);

toc

%% Function Definitions
% "Before R2024a: Local functions in scripts must be defined at the end of the file, after the last line of script code."
% The functions will be left at the end so it will be compatible with versions pre R2024a
% function res = appr(x, m, size)
%   res = zeros(1, size);
%   steppity = 1;
%   for i = 0 : m - 1
%     for j = i : m - i
%       res(steppity) = x(1)^j * x(2)^i;
%       if i ~= j
%         res(steppity) = x(1)^i * x(2)^j;
%         steppity = steppity + 1;
%       end
%       steppity = steppity + 1;
%     end
%   end
% end % function for approximator

function res = phi(x, m)
  size_x    = size(x{1, 1}, 2);
  C         = table2array(combinations(0:m, 0:m)); % combinations of all the powers
  C_correct = C(sum(C, 2)<=m, :); % proper powers of the current polynomial
  size_poly = size(C_correct, 1); % get the number of rows (= number of elements of polynomial)
  res       = zeros(size_x * size_x, size_poly); % initialize phi with 0

  combs     = table2array(combinations(x{1, 1}, x{2, 1})); % combinations of all X1 and X2
  for i = 1 : (size_x * size_x)
      line = prod(power(combs(i, :), C_correct), 2);
      res(i, :) = line';
      % teehee = appr([combs(i, 1), combs(i, 2)], m, size_poly);
      % s_t    = size(teehee, 2);
      % teehee = teehee([flip(1:floor(s_t/2)), flip((s_t-ceil(s_t/2)+1):s_t)]);
      % res(i, :) = teehee;
  end
end % function for phi (regressor)
