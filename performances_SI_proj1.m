%% test of concatenation
% A = [];
% eq = @(x) (x^3 - 89/7 * x^2 + 5.13);
% for i = 1 : 10000
%     A = [A; eq(i*(-1))];
% end % for
% 
% plot(1:10000, A);

%% test of replacing
A = zeros(10000, 1);
eq = @(x) (x^3 - 89/7 * x^2 + 5.13);
for i = 1 : 10000;
    A(i) = eq(i*(-1));
end % for

plot(1:10000, A);
