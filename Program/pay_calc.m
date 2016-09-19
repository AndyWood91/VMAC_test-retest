% spatial
% 
% points = [62674 10945 55545];
% 
% raw_pay = points / 100;
% 
% pay = ceil(raw_pay * 5);
% 
% final_pay = pay / 5;

start = 6.09;

points = zeros(11, 2);
increment = 0.01;

for a = 1:numel(points(:, 1))
    
    points(a, 1) = start + increment * a
    
    points(a, 2) = ceil(points(a, 1) * 20) / 20
end
