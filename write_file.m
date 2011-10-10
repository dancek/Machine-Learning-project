function write_file(file, data)

data = uint8(data);
f = fopen(file, 'wt');
for i = 1:size(data,1)
    fprintf(f, '%d ', data(i,:));
    fprintf(f, '\n');
end
fclose(f);