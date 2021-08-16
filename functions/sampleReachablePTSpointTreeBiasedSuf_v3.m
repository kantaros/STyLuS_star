function [xRand,distRand]=sampleReachablePTSpointTreeBiasedSuf_v3(Qpba,B1,N,T,ind,AP, N_p, finalState,distanceB,SetMinDist)

%picks a random node of the tree. Samples a state that is reachable in PTS
%from the selected node
randThr=0.9;
newThr=0.9;
nextBThr=1;%(0.5,1)set it to 1. the result still holds
%select qPrand
%ap=findAP(word);
xRand=zeros(1,N);
probRand=rand;
if probRand>randThr
    pickInd=randi(ind-1);
else
    RandInd=randi(length(SetMinDist));
    pickInd=SetMinDist(RandInd);
end
%ReachablePoints=T.adj(Qpba(pickInd,1:N),:);%=matrix (call it A...) NxQ. A(i,j)=1 if from current position of robot i, location j can be reached reachable locations for each in
qPTSrand=Qpba(pickInd,1:N);
qBrand=Qpba(pickInd,end);
distRand=distanceB(qBrand,finalState);

satRand=observeInDiscreteEnvironment_v2(N,N_p,AP,qPTSrand);
QBNext=NextNBAState(qBrand,satRand,B1);% reachable set of NBA states from qBrand

notExpandable=0;%if 0 nonempty reachable set
if ~isempty(QBNext)
    
    distQBNext=distanceB(QBNext,finalState);
    probNextB=rand;
    %if probNextB<nextBThr
    Set=find(min(distQBNext)==distQBNext);
    flagGS=cell(length(Set),1);
    ap=flagGS;
    flagOneStepFromFinal=ap;
    
    for q=1:length(Set)
        qBminCand=QBNext(Set(q));
        distqBnext=distanceB(qBminCand,finalState);
        GoalLevel=distqBnext-1;
        distB=distanceB(:,finalState);
        if GoalLevel~=0
            goal=find(GoalLevel==distB);%"R_b^decr(q_B^min) without feasibility"
            flagOneStepFromFinal{q}=0;
        else
            goal=finalState;
            flagOneStepFromFinal{q}=1;
        end
        
        %compute AP that need to be satisfied in order to move from qBminCand to any state (qBfeas) with
        %distance from finalState equal to GoalLevel
        
        for g=1:length(goal)
            if  ~isinf(B1.neig(qBminCand,goal(g)))%~isempty(B1.trans{qBr,goal(g)})
                %if isempty(find(2^N_p==B1.trans{qBr,goal(g)}))
                word=B1.trans{qBminCand,goal(g)}(1);
                ap{q}=findAP(word);
                flagGS{q}=[flagGS{q},g];
                break
                % else
                %     ap=N_p+1;%
                % end
            end
        end
        if ~isempty(flagGS{q})
            randq=q;
            break
        end
    end
    cand=find(~cellfun('isempty', flagGS), 1);
    %randq=randi(length(cand));
    flagOneStepFromFinal1=flagOneStepFromFinal{randq};
    %nextNBA=QBNext(Set(cand(randq))); %selected qBmin 
    
    
    %RandIndNBA=randi(length(Set));
    %nextNBA= QBNext(Set(RandIndNBA));%q_B^min
    %distqBnext=distanceB(nextNBA,finalState);
    %else%never be activated given this threshold
    %    RandIndNBA=randi(length(QBNext));
    %    nextNBA= QBNext(RandIndNBA);
    %    distqBnext=distanceB(nextNBA,finalState);
    %end
    
   
    
    
 
    
    %find the rbts that are associated with this AP
    error1=0; 
    if ~isempty(cand)
        rbts=[];
        ap1=ap{randq};
        for a=1:length(ap{randq})
            rbts=[rbts,AP{ap1(a),N+2}];
        end
    else
        qPTSrand
        qBrand
        %goal(g)
        error1=1; % (R_b^feas(q_B^min)=empty)
        %error('something is wrong')
    end
else
    notExpandable=1;
    error1=1;%    
end



%select qPnew (biased towards the locations that satisfy the above AP)

%transmat=T.Dist;
%transmat=T.adj;%
%transmat(~transmat) = inf;
if error1==0 && notExpandable==0
    x0=Qpba(1,1:N);
    probNew=rand;
    for j=1:N
        if isempty(find(j==rbts, 1))
            if probNew<newThr && flagOneStepFromFinal1==1
                temp=find(T.adj(:,x0(j))>0);
                goalLoc=temp(1);%=x0(j);
                [~,r_path, ~] = graphshortestpath(T.adjList,qPTSrand(j),goalLoc);
                if length(r_path)==1
                    xRand(j) = r_path(1);
                else
                    xRand(j) = r_path(2);
                end
            else
                reachable=find(T.adj(qPTSrand(j),:)>0);
                pos = randi(length(reachable));
                xRand(j)=reachable(pos);
            end
        else

            if probNew<newThr
                for a=1:length(ap1)
                    if ~isempty(find(j==AP{ap1(a),N+2}, 1))
                        break
                    end
                end
                goalLoc=AP{ap1(a),j}(1);
                %[r_path, cost2] = dijkstra_1(state(j), goalLoc, transmat);
                %[r_path, ~] = shortestpath(T.adjList,state(j),goalLoc);
                %[cost1,r_path, ~] = graphshortestpath(T.adjList,state(j),goalLoc);
                [~,r_path, ~] = graphshortestpath(T.adjList,qPTSrand(j),goalLoc);
                if length(r_path)==1
                    xRand(j) = r_path(1);
                else
                    xRand(j) = r_path(2);
                end
            else%random reachable point
                reachable=find(T.adj(qPTSrand(j),:)>0);
                pos = randi(length(reachable));
                xRand(j)=reachable(pos);
            end
        end
    end
end




%%
% if error==0
%     probNew=rand;
%     for j=1:N
%         if isempty(find(j==rbts, 1))
%             reachable=find(T.adj(state(j),:)>0);
%             pos = randi(length(reachable));
%             xRand(j)=reachable(pos);
%         else
%             
%             for a=1:length(ap)
%                 if ~isempty(find(j==AP{ap(a),N+2}, 1))
%                     break
%                 end
%             end
%             
%             if probNew<newThr
%                 goalLoc=AP{ap(a),j};
%                 %[r_path, cost2] = dijkstra_1(state(j), goalLoc, transmat);
%                 %[r_path, ~] = shortestpath(T.adjList,state(j),goalLoc);
%                 %[cost1,r_path, ~] = graphshortestpath(T.adjList,state(j),goalLoc);
%                 [cost1,r_path, ~] = graphshortestpath(T.adjList,state(j),goalLoc);
%                 if length(r_path)==1
%                     xRand(j) = r_path(1);
%                 else
%                     xRand(j) = r_path(2);
%                 end
%             else%random reachable point
%                 reachable=find(T.adj(state(j),:)>0);
%                 pos = randi(length(reachable));
%                 xRand(j)=reachable(pos);
%             end
%         end
%     end
% end
%xRand
%cost=0
%for rbt=1:N
%     cost=cost+Dist(xRand(rbt),x0(:,rbt))'
%     rbt
%     pause
% end
%[cost1,r_path, ~] = graphshortestpath(T.adjList,1,582);
%%
%
% for j=1:N    
%     if isempty(find(j==rbts, 1))
%         reachable=find(T.adj(state(j),:)>0);
%         pos = randi(length(reachable));
%         xRand(j)=reachable(pos);
%     else
%         
%         for a=1:length(ap)
%             if ~isempty(find(j==AP{ap(a),N+2}, 1))
%                 break
%             end
%         end
%        
%         prob=rand;
%         if prob<0.8
%             goalLoc=AP{ap(a),j};
%             [r_path, ~] = dijkstra_1(state(j), goalLoc, T.adj);
%             feasSpace=zeros(max(r_path(2:end)),1);
%             for e=2:length(r_path)
%                 feasSpace(r_path(e))=1/(e^3);
%             end
%             xRand(j) = randp(feasSpace,1,1);
%         else%random reachable point
%             reachable=find(T.adj(state(j),:)>0);
%             pos = randi(length(reachable));
%             xRand(j)=reachable(pos);
%         end
%     end
% end
