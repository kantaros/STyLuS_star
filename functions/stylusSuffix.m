function [Qpba,parent, CostNode, S, DistRand, DistNew, n]=stylusSuffix(Qpba, B1, T, AP, parent, CostNode, N, qPr, ind, N_p, Termination)

Dist = T.Dist;
neig = B1.neig;
BigNum = Inf;
distanceB = B1.distanceB;
qBr=qPr(end);
distB=distanceB(:,qBr);
finalState=qBr;
sat0=observeInDiscreteEnvironment_v2(N,N_p,AP,qPr(1:N));

minDistF=distB(qBr);%min distance of t]he current tree towards finalState
SetMinDist=1;%root
DistRand=zeros(100,1);%(nmaxpre,1)%distance of selected qBrand from final state at iteration n
DistNew=100*ones(100,1);%(nmaxpre,1)%(minimum) distance of qBnew from final state at iteration n

stopTree=0;

states=B1.S;
S=[];
n=1;
%tic
RootFinal=[];
%%
while stopTree==0%if stopTree==0
  
    [xNew,DistRand(n)]=sampleReachablePTSpointTreeBiasedSuf_v3(Qpba,B1,N,T,ind,AP, N_p, finalState,distanceB,SetMinDist);
   
    
    %sat=observeInDiscreteEnvironment(N,N_p,AP,xNew,epsilon);
    if sum(xNew)>0
        %sat=observeInDiscreteEnvironment_v2(N,N_p,AP,xNew);
        
        for q2=1:length(states)%for every possible state of Buchi automaton
            qBnext=states(q2);%next possible Buchi state for xNew
            indexSample=myismember(Qpba,[xNew,qBnext]);%[~,indexSample]=ismember([xNew,qBnext],Qpba, 'rows');%check if this node already exists in the tree
            if isempty(indexSample)
                candParents=find(neig(:,qBnext)>0);% states in candParents that can reach qBnext
                indices=[];
                for jj=1:length(candParents)%for each possible qBprev
                    qBPrev=candParents(jj);
                    indices=[indices; find(Qpba(:,N+1)==qBPrev)];%indices of states in Qpba that point at states in Qba that reach the Buchi state qBnext
                end
                if ~isempty(indices)
                    % Find the nearest node to xNew among all states in Qpba q=(?,qBprev):
                    Qpts=Qpba(indices,1:N);
                    Qb=Qpba(indices,N+1);
                    %[xPrev,indexQpts]=heuristicPrevPoint_v2(Qpts,Qb,xNew,qBnext,Dist,BigNum,B1,AP,N_p);
                    [xPrev,indexQpts]=heuristicPrevPoint_v4(Qpts,Qb,xNew,qBnext,Dist,BigNum,B1,AP,N_p);
                    qBPrev=Qb(indexQpts);
                    qPrev=[xPrev,qBPrev];
                    %check if such a transition is feasible
                    %sat=observe(N,N_p,AP,xNew,epsilon);
                    %[~,indexSample]=ismember([xNew,qBnext], Qpba, 'rows');
                    if   ~isempty(qPrev)%indexSample==0 &&
                        % fprintf('accept1\n')
                        % sat=observeInDiscreteEnvironment(N,N_p,AP,xNew,epsilon);
                        sat=observeInDiscreteEnvironment_v2(N,N_p,AP,xPrev);
                        if ~isempty(find(sum(sat)==B1.trans{qBPrev,qBnext}, 1))%if there is a transition in PBA
                            %    fprintf('accept2\n')
                            %if sum((xPrev-xNew))~=0 || abs(qBPrev-qBnext)>0.01%do not wait at the same state
                            Qpba(ind,:) = [xNew,qBnext];
                            [~,indexInQpba]=ismember(qPrev,Qpba, 'rows');
                            parent(ind)=indexInQpba; CostPar=CostNode(indexInQpba);
                            CostNode(ind)=DistrCostOfTreeNode_MinCom(Qpba,CostPar,qPrev, ind,Dist);
                            %CostNode(ind)=CostOfTreeNode(Qpba,parent,ind,Dist);
                            %[parent,CostNode]=Rewire_fast_v3(ind,Qpba,CostNode,parent,BigNum,neig,Dist,B1,AP,N_p,epsilon);
                            tempDist=distanceB(qBnext,finalState);
                            if tempDist<minDistF
                                minDistF=tempDist;
                                SetMinDist=ind;
                            elseif tempDist==minDistF
                                SetMinDist=[SetMinDist,ind];
                            end
                            ind = ind+1;
                            %if mod(ind,1000)==0
                                %fprintf('sample number: %i\n', ind)
                            %end
                            if distanceB(qBnext,qBr)<DistNew(n)
                                DistNew(n)=distanceB(qBnext,qBr);
                            end
                            if qBnext==finalState
                                RootFinal=[RootFinal,ind-1];
                            end
                            flagPTS=feasibleTransitionBetween2PTSstates(xNew,qPr(1:N),T);
                            satNew=observeInDiscreteEnvironment_v2(N,N_p,AP,xNew);
                            if ~isempty(find(sum(satNew)==B1.trans{qBnext,qBr}, 1)) && flagPTS==1
                                %fprintf('The goal set reached!\n')
                                S=[S;ind-1];
                                %stopTree=1;
                                break
                            end
 
                        end
                    end
                    
                end
            end
        end
    end
    ind;
    n=n+1;
    DistNew(n)=1000;
    time=toc;
    if Termination.MaxIter && n>=Termination.nMaxSuf
        stopTree = 1;
    elseif ~Termination.MaxIter && length(S)>=1
        stopTree = 1;
    end

    %flag=GoalSet(Qpba(ind-1,N+1),goal);
    %sizeTreeSuf(n)=ind;
    % end
end
%toc
