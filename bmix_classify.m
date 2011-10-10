load data/spam1k.txt
y = spam1k(:,2);
x = spam1k(:,3:end);
n = length(y);

%x_train = x(1:n/2,:);
%x_test = x(n/2+1:end,:);
%y_train = y(1:n/2,:);
%y_test = y(n/2+1:end,:);

x1 = x(1:500,:);
x0 = x(501:1000,:);
y1 = y(1:500,:);
y0 = y(501:1000,:);

%%
% N-fold cross-validation
n_folds = 10;
components_spam = [1];%[13:19];
components_ham = [1];%[1 2 3 5 7 10 12 15];
nRepetitions = 5;

tic
for l = 1:length(components_spam)
for j = 1:length(components_ham)
    mixings = zeros(2,2,n_folds);
    accuracies = zeros(n_folds,nRepetitions);
    %mixings = zeros(2,2,n_folds);
    %accuracies = zeros(n_folds,1);
    for k = 1:nRepetitions
        fprintf('\nRepetition %d, fold ', k);
        for i = 1:n_folds
            fprintf('%d,',i);
            val_indices = 1+(i-1)*floor(n/(2*n_folds)):i*floor(n/(2*n_folds));
            x_val = [x1(val_indices,:); x0(val_indices,:)];
            x1_train = x1;
            x1_train(val_indices,:) = [];
            x0_train = x0;
            x0_train(val_indices,:) = [];
            x_train = [x1_train; x0_train];

            y_val = [y1(val_indices,:); y0(val_indices,:)];
            y1_train = y1;
            y1_train(val_indices,:) = [];
            y0_train = y0;
            y0_train(val_indices,:) = [];
            y_train = [y1_train; y0_train];

            c_ham = components_ham(j);
            c_spam = components_spam(l);
            pred = bmix_pred(x_train, y_train, x_val, c_ham, c_spam);

            % Check for ties
            if sum(pred == 0.5)
                actualClasses = y_val(pred == 0.5);
                fprintf('%d ties, %d of which are actually spam\n', ...
                    sum(pred == 0.5), sum(actualClasses));
            end

            pred(pred < 0.5) = 0;
            pred(pred >= 0.5) = 1;

            [mixing, acc] = mixing_matrix(y_val,pred);
            mixings(:,:,i) = mixings(:,:,i) + mixing;
            accuracies(i,k) = acc;
        end
    end
    save(['data/mixings_c' num2str(c) '.mat'], 'mixings')
    save(['data/accuracies_c' num2str(c) '.mat'], 'accuracies')
    fprintf('\nAccuracy: %.4f with %d ham components and %d spam components.\n', mean(mean(accuracies)), components_ham(j), components_spam(l));
    mean(mixings*n_folds/500,3) / 2
end
end
toc