function [xx, yy] = getfact(fis, inputIndex, value, npoints)

input = fis.input(inputIndex);
range 

if nargin < 3
  npoints = 200;
end

xx = linspace(input.range(1), input.range(2), npoints)';
yy = zeros(npoints, 1);
for i = 1:size(input.mf,2)
  params = input.mf(i).params;
  type = input.mf(i).type;
  ymax = evalmf(value, params, type);
  yy = max(yy, min(evalmf(xx, params, type), ymax));
end
