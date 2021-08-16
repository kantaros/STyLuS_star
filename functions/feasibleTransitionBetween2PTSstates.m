function flagPTS=feasibleTransitionBetween2PTSstates(qa,qb,T)
flagPTS=1;%if qa-->_{PTS} qb is feasible=> flagPTS=1
N=length(qa);
for e=1:N
flagPTS=flagPTS*T.adj(qa(e),qb(e));
if flagPTS==0
    break
end
end