function Cost=CostOfTSPath(PathOfPTS,Dist)
%PathOfPTS=OptPathPrePTS
Cost=0;

for e=1:size(PathOfPTS,1)-1
    
 Cost=Cost+CostOfPTStransition(PathOfPTS(e,:),PathOfPTS(e+1,:),Dist);
 %pause
end