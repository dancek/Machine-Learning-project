function [likelihoods] = bmix_pred(x_train, y_train, x_val, c_ham, c_spam)

% Write data to file for bmix
x_ham = x_train(y_train == 0,:);
x_spam = x_train(y_train == 1,:);

write_file('data/train_ham.data', x_ham)
write_file('data/train_spam.data', x_spam)
write_file('data/validation.data', x_val)

system(['./bmix-1.11/bin/bmix_train --data data/train_ham.data --clusters ' ...
    num2str(c_ham) ' -t 100 -r 0.000001 -q --model-out models/train_ham.model']);
system(['./bmix-1.11/bin/bmix_train --data data/train_spam.data --clusters ' ...
    num2str(c_spam) ' -t 100 -r 0.000001 -q --model-out models/train_spam.model']);
system('./bmix-1.11/bin/bmix_like --data data/validation.data --model-in models/train_ham.model -s > data/ham_likelihoods.txt');
system('./bmix-1.11/bin/bmix_like --data data/validation.data --model-in models/train_spam.model -s > data/spam_likelihoods.txt');

ham_ls = load('data/ham_likelihoods.txt');
spam_ls = load('data/spam_likelihoods.txt');
likelihoods = exp(spam_ls)./(exp(ham_ls) + exp(spam_ls));