% QpbaLocal=Qpba;
% CostNodeLocal=CostNode;
% parentLocal=parent;
% indexS=ind
function [parentLocal,CostNodeLocal]=Rewire_fast_v3(indexS,QpbaLocal,CostNodeLocal,parentLocal,BigNum,neig,Dist,B1,AP,N_p,epsilon)
N=size(QpbaLocal,2)-1;
%for loop "for e"
%indexS is the index of the current sample around which we will rewire
%parentLocal=parent;CostNodeLocal=CostNode;
% NumOfSamples=213;%size(Qpba,1);
qB=QpbaLocal(indexS,N+1);
qPTS=QpbaLocal(indexS,1:N);


%Next we find all reachable (within one hop) states from (qPTS,qB) that already exist in
%the tree
candChildren=find(neig(qB,:)>0);%feasible next Buchi states
for jj=1:length(candChildren)%for each possible qBprev
    qBNext=candChildren(jj);
    %===================================
    %Given qBprev, we will find all PBA states that are reachable within
    %one hop
    indices=find(QpbaLocal(:,N+1)==qBNext);
    Qpts=QpbaLocal(indices,1:N);
    Qb=QpbaLocal(indices,N+1);%% matrix with qBNext in all entries
    %transitions from (qPTS,qB) to any state in [Qpts,Qb] is feasible
    %from Buchi perspective.
    %Choose those that are feasible according to PTS, as well:
    %----------------
    M=size(Qpts,1);
    cost=zeros(M,1);%cost of each possible global transition in the PTS
    
    for rbt=1:N
        cost=cost+Dist(qPTS(rbt),Qpts(:,rbt))';
    end
    indexFeasibleTrans=find(cost<BigNum);
    %Qpts(indexFeasibleTrans(1),:)
    %--------------
    %======================================
    
    %compute the cost from state (qPTS,qB) to (Qpts(indexFeasibleTrans(w),:),qBprev)
    if ~isempty(indexFeasibleTrans)
        for w=1:length(indexFeasibleTrans)
            %sat=observeInDiscreteEnvironment(N,N_p,AP,Qpts(indexFeasibleTrans(w),:),epsilon);
            sat=observeInDiscreteEnvironment(N,N_p,AP,Qpts(indexFeasibleTrans(w),:),epsilon);
            if ~isempty(find(sum(sat)==B1.trans{qB,qBNext}, 1))
                [~,indexPBA]=ismember([Qpts(indexFeasibleTrans(w),:),qBNext],QpbaLocal,'rows');
                CostPath=CostNodeLocal(indexS)+CostOfPTStransition(QpbaLocal(indexPBA,1:N),qPTS,Dist);%cost of new path in the tree
                if CostPath+10^(-8)<CostNodeLocal(indexPBA)
                   % minCost=CostPath;
                    indexMin=indexPBA;
                    %update parents:
                    parentLocal(indexMin)=indexS;
                    tempC=CostNodeLocal(indexMin);
                    CostNodeLocal(indexMin)=CostPath;
                    %fprintf('Rewire %i\n',indexS)
                    %fprintf('Rewire %i\n',indexMin)
                    suc=sucessors(indexMin,parentLocal);
                    
                    CostNodeLocal(suc)=CostNodeLocal(suc)-(tempC-CostPath);                
                end
            end
        end
        %prefixPBA(e,:)=Qpba(indexMin,:);
    end
end

% %UPDATE PARENTS 
% if ~isempty(indexMin)
%     parent(indexMin)=ind;
%     fprintf('Rewire\n')
%     %update costs of nodes....here we update costs of all nodes..a
%     %smarter/faster way is required
%     for ee=1:ind
%         CostNode(ee)=CostOfTreeNode(Qpba,parent,ee,Dist);
%     end
% end
