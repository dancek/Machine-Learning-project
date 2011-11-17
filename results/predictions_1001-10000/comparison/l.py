def load(filename):
    with open(filename) as f:
        return map(int, f.readlines())

correct = load('correct')
bmix = load('bmix')
svm = load('svm')
rndf = load('rndf')

def errors(l):
    return sum(x[0] != x[1] for x in zip(correct, l))

def accuracy(l):
    return (len(l) - errors(l)) / float(len(l))
