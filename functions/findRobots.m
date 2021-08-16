function AP = findRobots(AP, N, N_p)

for ap = 1 : N_p
    %tempcell = AP(ap, :)  
    AP{ap, N+2} = find(~cellfun('isempty',AP(ap, 1:N)));
end
