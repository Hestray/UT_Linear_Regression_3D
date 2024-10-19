%% Load & Plot Data
load('./proj_fit_38.mat');
figure(1);
mesh(id.X{1, 1}, id.X{2, 1}, id.Y, 'LineStyle', ':', 'EdgeColor', '#D95319');
xlabel('x1'); ylabel('x2'); zlabel('y'); hold on;
%% Approximator Function
% appr(x, m) function at the end of the file
%% System of Linear Equations
% phi(x, m) function at the end of the file
m = 2;
theta = phi(id.X, m) \ id.Y';
y_id_appr = phi(id.X, m) * theta;
MSE_id = mean((id.Y - y_id_appr') .^ 2, [1, 2])
mesh(id.X{1, 1}, id.X{2, 1}, y_id_appr', 'EdgeColor', '#0072BD'); hold off;
legend('Real Values', 'Approximated Values'); title('Identification Data');
%% Validation on a Different Data Set (not working)
y_val_appr = phi(val.X, m) * theta;
% MSE_val = mean((val.Y - y_val_appr') .^ 2, [1, 2])
% 
figure(2);
% mesh(val.X{1, 1}, val.X{2, 1}, val.Y, 'LineStyle', ':', 'EdgeColor', '#D95319'); hold on;
yvalapproxreduced = y_val_appr(:, round(linspace(1, 41, 31)));
[X1_grid, X2_grid] = meshgrid(val.X{1, 1}, val.X{2, 1});
scatter3(X1_grid, X2_grid, val.Y, 'filled'); hold on;
mesh(X1_grid, X2_grid, yvalapproxreduced', 'EdgeColor', '#0072BD'); hold off;
% mesh(val.X{1, 1}, val.X{2, 1}, y_val_appr(:, 1:length(val.Y))', 'EdgeColor', '#0072BD'); hold off;
%% Trying Various Degrees
m = 1 : 25;
MSE_id = [];
MSE_val = [];
for i = m
  theta = phi(id.X, i) \ id.Y';
  y_id_appr = phi(id.X, i) * theta;
  MSE_id = [MSE_id, mean((id.Y - y_id_appr') .^ 2, [1, 2])];

  % not working
  y_val_appr = phi(val.X, i) * theta;
  yvalapproxreduced = y_val_appr(:, round(linspace(1, 41, 31)));
  MSE_val = [MSE_val, mean((val.Y - yvalapproxreduced') .^ 2, [1, 2])];
end

figure(3);
plot(m, MSE_id); hold on;
plot(m, MSE_val);
legend("MSE_id", "MSE_val")
grid; hold off;

%% Function Definitions
% "Before R2024a: Local functions in scripts must be defined at the end of the file, after the last line of script code."
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
end
function res = phi(x, m)
  res = [];
  for i = 1 : length(x{1, 1})
    res = [res; appr([x{1, 1}(i), x{2, 1}(i)], m)];
  end
end
