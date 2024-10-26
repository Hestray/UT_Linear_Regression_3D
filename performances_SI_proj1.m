%% test of concatenation
% A = [];
% eq = @(x) (x^3 - 89/7 * x^2 + 5.13);
% for i = 1 : 10000
%     A = [A; eq(i*(-1))];
% end % for
% 
% plot(1:10000, A);

%% test of replacing
% A = zeros(10000, 1);
% eq = @(x) (x^3 - 89/7 * x^2 + 5.13);
% for i = 1 : 10000;
%     A(i) = eq(i*(-1));
% end % for
% 
% plot(1:10000, A);

%% load the datasets
load('./proj_fit_38.mat');

%% test of concatenation using the functions
m       = 1 : 25;
MSE_id  = [];
MSE_val = [];

Y_id_reshape = (reshape(id.Y', [width(id.Y)*height(id.Y), 1]));
Y_val_reshape = (reshape(val.Y', [width(val.Y)*height(val.Y), 1]));

for i = m
  % calculating the MSE for Identification dataset
  theta = phi(id.X, i) \ Y_id_reshape;
  y_id_appr = phi(id.X, i) * theta;
  MSE_id = [MSE_id, mean((Y_id_reshape - y_id_appr) .^ 2, [1 2])];

  % calculating the MSE for Validation dataset
  y_val_appr = phi(val.X, i) * theta;
  MSE_val = [MSE_val, mean((Y_val_reshape - y_val_appr) .^ 2, [1 2])];
end

%% test of pre-allocations using the functions
% m       = 1 : 25; size_m = length(m);
% MSE_id  = zeros(1, size_m);
% MSE_val = zeros(1, size_m);
% 
% Y_id_reshape = (reshape(id.Y', [width(id.Y)*height(id.Y), 1]));
% Y_val_reshape = (reshape(val.Y', [width(val.Y)*height(val.Y), 1]));
% 
% for i = m
%   % calculating the MSE for Identification dataset
%   theta = phi(id.X, i) \ Y_id_reshape;
%   y_id_appr = phi(id.X, i) * theta;
%   MSE_id(i) = mean((Y_id_reshape - y_id_appr) .^ 2, [1 2]);
% 
%   % calculating the MSE for Validation dataset
%   y_val_appr = phi(val.X, i) * theta;
%   MSE_val(i) = mean((Y_val_reshape - y_val_appr) .^ 2, [1 2]);
% end


%% functions
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
      for j = 1 : length(x{2, 1})
        res = [res; appr([x{1, 1}(i), x{2, 1}(j)], m)];
      end 
  end
end % function for phi (regressor)
