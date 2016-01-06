function varargout = dealA(x, axis)

if nargin < 2
	axis = 1;
end
n = size(x, axis);
for i = 1:n
   varargout{i} = sliceA(x, axis, i);
end