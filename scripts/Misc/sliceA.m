function xs = sliceA(x, dim, idx)

s = size(x);
not_dim = [1:dim-1 dim+1:ndims(x)];
x = permute(x, [dim not_dim]);
xs = reshape(x(idx,:), s(not_dim));