load data/spam1k.txt
y = spam1k(:,2);
x = spam1k(:,3:end);
n = length(y);

%%
[coeff, score, latent] = princomp(x);
% Number of dimensions
ndim = 2;
x = score(:,1:ndim);
%%
x1 = x(1:500,:);
x0 = x(501:1000,:);
y1 = y(1:500,:);
y0 = y(501:1000,:);
%%
plot(x0(:,1),x0(:,2),'ro', x1(:,1),x1(:,2),'bx')
%%
figure, hist(sum(x0,2))
figure, hist(sum(x1,2),24)
%%

x_train = [x1(1:250,:); x0(1:250,:)];
y_train = [y1(1:250,:); y0(1:250,:)];
x_val = [x1(251:500,:); x0(251:500,:)];
y_val = [y1(251:500,:); y0(251:500,:)];
%% Kikkailuja
obvious = find(sum(x1,2) > 6);
nObvious = find(sum(x1,2) <= 6);
%%
pred2 = bmix_pred(x_train, y_train, x_val, 5, 13);
save results/test_251-500_751-1000/bmix2.pred pred2 -ASCII
pred = pred2;
%model = svmtrain(x_train, y_train, 'kernel_function','rbf', 'rbf_sigma', 0.3, 'autoscale', 'false');
%pred = svmclassify(model, x_val);

%pred = load('results/test_251-500_751-1000/libsvm.pred');
%pred = pred(:,2);

% Check for ties
if sum(pred == 0.5)
    actualClasses = y_val(pred == 0.5);
    fprintf('%d ties, %d of which are actually spam\n', ...
        sum(pred == 0.5), sum(actualClasses));
end

pred(pred < 0.5) = 0;
pred(pred >= 0.5) = 1;
wrongs = find(y_val ~= pred);

[mixing, acc] = mixing_matrix(y_val,pred)