function costTr=CostOfPTStransition(qa,qb,Dist)
%qa and qb are PTS states

%Dist(qa,qb)%keep only the diagonal entries of Dist(qa,qb). The i-th diag
%entry is the distance from qa(e) to qb(e)

costTr=sum(diag(Dist(qa,qb)));