function [M, accuracy] = mixing_matrix(y, pred)

M = zeros(2);
M(1,1) = sum(y == 0 & pred == 0);
M(1,2) = sum(y == 0 & pred == 1);
M(2,1) = sum(y == 1 & pred == 0);
M(2,2) = sum(y == 1 & pred == 1);

accuracy = sum(y == pred) / length(y);