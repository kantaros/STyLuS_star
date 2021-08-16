function CostNode1=DistrCostOfTreeNode_MinCom(QpbaLocal,CostPar,qParent,curIndex,Dist)
%(QpbaLocal,parentLocal,curIndex,Dist,x0)
%computes the cost for traveling from node that was the curIndex-th sample
%to the root
N=size(QpbaLocal,2)-1;
CostNode1=0;
curState=QpbaLocal(curIndex,1:N);
%path0=curIndex;

if curIndex~=1
    %ParIndex=parentLocal(curIndex);%the parent node
    ParState=qParent(1:N);
    costTr=CostOfPTStransition(ParState,curState,Dist);
    CostNode1=CostPar+costTr;
end


% if curIndex~=1
%     while curIndex~=1
%         curIndex=parentLocal(curIndex);
%   
%        % path0=[path curIndex];
%         if curIndex~=1
%             prevState=QpbaLocal(curIndex,1:N);
%             costTr=CostOfPTStransition(curState,prevState,Dist);
%             CostNode1=CostNode1+costTr;
%             curState=prevState;
%         else %you will never enter this "else" case
%             costTr=CostOfPTStransition(curState,x0,Dist);
%             CostNode1=CostNode1+costTr;
%         end
%     end
% else
%     CostNode1=0;
% end

% CostNode1=DistrCostOfTreeNode_MinCom(Qpba,C,qParent,curIndex,Dist)