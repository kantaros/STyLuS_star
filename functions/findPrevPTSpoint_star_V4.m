function [xPrev,indexQpts]=findPrevPTSpoint_star_V4(Qpts,Qb,Qpba,xNew,qBnext,Dist,BigNum,parent,B1,AP,N_p)
%here we pick xPrev so that the total cost from xNew to the root is the
%minimum (so we dont necessarily pick the closest point)

%Qsubpba=[Qpts,Qb];
xPrev=[];
indexQpts=[];
N=size(Qpts,2);
M=size(Qpts,1);
cost=zeros(M,1);%cost of each possible global transition in the PTS
% for j=1:M
%     for rbt=1:N
%     sum(j)=sum(j)+Dist(xRand(rbt),Qpts(j,rbt));
%     end
% end
% for rbt=1:N
%     cost=cost+Dist(xNew(rbt),Qpts(:,rbt))';
% end
for line=1:size(Qpts,1)
    for rbt=1:N
        cost(line)=cost(line)+Dist(Qpts(line,rbt),xNew(rbt))';
        % rbt
        %pause
    end
end
%cost contains the cost to from from xNew to any xPrev

indexFeasiblePTSTrans=find(cost<BigNum);%indices that point at states (xPrev) 
%in Qpts from which there is a direct feasible transition in the PBA to xNew
IndexFeasibleTrans=[];
for e=1:length(indexFeasiblePTSTrans)
 %sat=observeInDiscreteEnvironment(N,N_p,AP,xNew,epsilon);
    xCandPrev=Qpts(indexFeasiblePTSTrans(e),:);
    %sat=observeInDiscreteEnvironment_v2(N,N_p,AP,xNew);
    sat=observeInDiscreteEnvironment_v2(N,N_p,AP,xCandPrev);
    qBprev=Qb(indexFeasiblePTSTrans(e));%qBcandBrev
    if ~isempty(find(sum(sat)==B1.trans{qBprev,qBnext}, 1))
        IndexFeasibleTrans=[IndexFeasibleTrans, e];
    end
end
                    

if ~isempty(IndexFeasibleTrans)%if there are feasible PTS transitions from xNew to another PTS state
    CostPath=zeros(length(IndexFeasibleTrans),1);
    for e=1:length(IndexFeasibleTrans)
        %check the cost (total travel distance) of going from state
        %with indexQpts=indexFeasiblePTSTrans((indexFeasibleTrans(e))) (points  @ Qpts) to the root (not necesarily include in Qpts)
        indexQpts=indexFeasiblePTSTrans((IndexFeasibleTrans(e)));
        statePBA=[Qpts(indexQpts,:),Qb(indexQpts)];%possible candidate to be connected to xNew
        [~,indQpba]=ismember(statePBA,Qpba, 'rows');
        CostPath(e)=CostOfPTStransition(statePBA(1:N),xNew,Dist);
        %find the path, add cost from line 16...find the minimum(shortest path)..
        curState=statePBA(1:N);
        curIndex=indQpba;
        %if parent(curIndex)~=0
        while curIndex~=1
            curIndex=parent(curIndex);
            prevState=Qpba(curIndex,1:N);
            costTr=CostOfPTStransition(curState,prevState,Dist);
            CostPath(e)=CostPath(e)+costTr;
            curState=prevState;
        end
        %end
    end
    [minCostPath,indexPath]=min(CostPath);
    xPrev=Qpts(indexFeasiblePTSTrans(IndexFeasibleTrans(indexPath)),:);
    indexQpts=indexFeasiblePTSTrans(IndexFeasibleTrans(indexPath));
end
% 
% path=indGoal;
% index=indGoal;
% while parent(index)~=1
%     path=[path parent(index)];
%     index=parent(index);
% end
% path=[path 1];
% pathPTS=[];
% for p=length(path):-1:1
%     pathPTS=[pathPTS;Qpba(path(p),1:N)];
% end
% 




% %  
% % xxRand=repmat(xRand,M,1);
% % sum=sum+Dist(xRand,Qpts);
  










