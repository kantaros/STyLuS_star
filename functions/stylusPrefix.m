function [Qpba,parent, CostNode, F, DistRand, DistNew, n]=stylusPrefix(Qpba, B1, T, AP, parent, CostNode, N, qPr, ind, N_p, Termination)

% here we only take into account the "first" NBA initial state B1.S0(1).
Dist = T.Dist;
distanceB = B1.distanceB;
neig = B1.neig;
states = B1.S;
BigNum = Inf;
accept(1) = 0;

%if you have more than one final states you need to pick a final state that
%is reachable from the initial state
flagFeasFinal       = 0;
while flagFeasFinal == 0
    for f = 1:length(B1.F)
        if ~isinf(distanceB(B1.S0(1),B1.F(f)))
            flagFeasFinal = f;
            break
        end
    end
end
%
stop = 0;
if flagFeasFinal==0
    warning('Infeasible task or there is a bug...')
    stop = 1;
end
%

finalState = B1.F(flagFeasFinal); % biased towards this final state
distB = distanceB(:,finalState);
qBr = qPr(end);
minDistF = distB(qBr);%min distance of t]he current tree towards finalState
SetMinDist = 1;%root

%
DistRand = zeros(100,1);%(nmaxpre,1)%distance of sampled qBrand from final state at iteration n
DistNew = 100*ones(100,1);%(nmaxpre,1)%(minimum) distance of qBnew from final state at iteration n
%states=[qBr, goal'];

F=[]; %set of indices of detected final states
%tic
n=1; %iter counter
while stop==0%
    % Generate a random point inside free domain:
    %points at the indexRandom-th entry of vector candTspoints(j,:) for robot j
 
    [xNew,DistRand(n)]      = sampleReachablePTSpointTreeBiasedPre_v3(Qpba,B1,N,T,ind,AP,N_p, finalState,distanceB,SetMinDist);%L(xPrev)

    if sum(xNew)>0 %if a sample was selected
      
        % for collision avoidance
        % while size(unique(xNew))~=N
        %     xNew=samplePTSpoint(nextTSpoints,N);
        %end
        %-------------------------------
        
        for q2 = 1:length(states)                         % for every possible state of Buchi automaton
            
            qBnew           = states(q2);                          % next possible Buchi state for xNew
            indexSample     = myismember(Qpba,[xNew,qBnew]); % check if this node already exists in the tree
            if isempty(indexSample)
                candParents = find(neig(:,qBnew)>0);     % states in candParents can reach qBnew
                indices     = [];
                for jj = 1:length(candParents)           %for each possible qBprev
                    qBPrev  = candParents(jj);
                    indices = [indices; find(Qpba(:,N+1)==qBPrev)];     %indices of states in Qpba that reach the Buchi state qBnew
                end
                
                
                if ~isempty(indices) % Find the nearest node to xNew among all states in Qpba q=(?,qBprev):
                    
                    Qpts               = Qpba(indices,1:N);
                    Qb                 = Qpba(indices,N+1);
                    %[xPrev,indexQpts]=heuristicPrevPoint_v2(Qpts,Qb,xNew,qBnext,Dist,BigNum,B1,AP,N_p);%based
                    %on PBA transition rule (L(next))
                    [xPrev, indexQpts] = findPrevPTSpoint_star_V4(Qpts,Qb,Qpba,xNew,qBnew,Dist,BigNum,parent,B1,AP,N_p); %L(prev) (best parent)
                    qBPrev             = Qb(indexQpts);
                    qPrev              = [xPrev,qBPrev]; %parent node

                    if ~isempty(qPrev) % if there exists a parent node (this will always be true; just a sanity check)
                        sat = observeInDiscreteEnvironment_v2(N,N_p,AP,xPrev);
                        if ~isempty(find(sum(sat)==B1.trans{qBPrev,qBnew}, 1))
                            accept(n)            = accept(n)+1;
                            Qpba(ind,:)          = [xNew,qBnew];
                            [~,indexInQpba]      = ismember(qPrev,Qpba, 'rows');
                            parent(ind)          = indexInQpba; 
                            CostPar              = CostNode(indexInQpba);
                            CostNode(ind)        = DistrCostOfTreeNode_MinCom(Qpba,CostPar,qPrev, ind,Dist); %CostOfTreeNode(Qpba,parent,ind,Dist);
                            tempDist             = distanceB(qBnew,finalState);
                            %part that guarantees biasing to only feasible
                            %transitions
                            satNew               = observeInDiscreteEnvironment_v2(N,N_p,AP,xNew);
                            tempqBNext           = find(B1.neig(qBnew,:)~=Inf);
                            DminUpd              = 0;
                            for q = 1 : length(tempqBNext)
                                qBnextnext       = tempqBNext(q);
                                if ~isempty(find(satNew==B1.trans{qBnew,qBnextnext}, 1))
                                    DminUpd      = 1;
                                    break
                                end
                            end
                            %%%%%%%%%%%%%%%%%%%
                            if tempDist < minDistF && DminUpd==1
                                minDistF         = tempDist;
                                SetMinDist       = ind;
                            elseif tempDist==minDistF && DminUpd==1
                                SetMinDist       = [SetMinDist,ind];
                            end
                            if distanceB(qBnew,finalState)<DistNew(n)
                                DistNew(n)       = distanceB(qBnew,finalState);
                            end                          
                            ind = ind+1;
                            %if mod(ind,1000)==0
                                % n
                            %    fprintf('sample number: %i\n', ind)
                            %end
                            %flag=GoalSet(Qpba(ind-1,N+1),goal);
                            if ~isempty(intersect(B1.F,Qpba(ind-1,N+1)))%flag%Goal(xNew)
                                %fprintf('The goal set reached!\n')
                                F=[F;ind-1];
                                %stop=1;
                            end
                            %end
                            %else %reject
                            %rejectInf(n)=rejectInf(n)+1;
                            %else
                            %    disp('rejected');
                        end
                        %elseif indexSample>0 %rewire
                        %[~,indexSample]=ismember([xNew,qBnext],Qpba, 'rows');
                        %[parent,CostNode]=Rewire_fast_v3(indexSample,Qpba,CostNode,parent,BigNum,neig,Dist,B1,AP,N_p,epsilon);
                        %else
                        %   disp('rejected');
                    end
                    %else
                    %   disp('rejected');
                end
            end
        end
    end
    ind;
    %toc
    %SizeTree(n)=ind;
    n = n+1;
   
    accept(n)=0;
    DistNew(n)=1000;
    %update goal if current goal has been reached
    if Termination.MaxIter && n>=Termination.nMaxPre
        stop = 1;
    elseif ~Termination.MaxIter && length(F)>=1
        stop = 1;
    end
end
%toc