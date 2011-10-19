function [likelihoods] = bmix_pred(x_train, y_train, x_val, c_ham, c_spam)

% Write data to file for bmix
x_ham = x_train(y_train == 0,:);
x_spam = x_train(y_train == 1,:);

id = num2str(rand);

write_file(['data/train_ham' id '.data'], x_ham)
write_file(['data/train_spam' id '.data'], x_spam)
write_file(['data/validation' id '.data'], x_val)

system(['./bmix-1.11/bin/bmix_train --data data/train_ham' id '.data --clusters ' ...
    num2str(c_ham) ' -t 100 -r 0.000001 -q --model-out models/train_ham' id '.model']);
system(['./bmix-1.11/bin/bmix_train --data data/train_spam' id '.data --clusters ' ...
    num2str(c_spam) ' -t 100 -r 0.000001 -q --model-out models/train_spam' id '.model']);
system(['./bmix-1.11/bin/bmix_like --data data/validation' id '.data --model-in models/train_ham' id '.model -s > data/ham_likelihoods' id '.txt']);
system(['./bmix-1.11/bin/bmix_like --data data/validation' id '.data --model-in models/train_spam' id '.model -s > data/spam_likelihoods' id '.txt']);

ham_ls = load(['data/ham_likelihoods' id '.txt']);
spam_ls = load(['data/spam_likelihoods' id '.txt']);

%size(spam_ls)
%size(ham_ls)
likelihoods = exp(spam_ls)./(exp(ham_ls) + exp(spam_ls));

system(['rm data/train_ham' id '.data']);
system(['rm data/train_spam' id '.data']);
system(['rm data/validation' id '.data']);
system(['rm models/train_ham' id '.model']);
system(['rm models/train_spam' id '.model']);