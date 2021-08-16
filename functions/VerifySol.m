function error=VerifySol(OptPathPBA,T,B1,N,N_p,AP)

%OptPathPBA=OptPathSufPBA
M=size(OptPathPBA,1);
error=0;
for e=1:M-1
    sat=observeInDiscreteEnvironment_v2(N,N_p,AP,OptPathPBA(e,1:N));
    qBPrev=OptPathPBA(e,N+1);
    qBnext=OptPathPBA(e+1,N+1);
    qPTSPrev=OptPathPBA(e,1:N);
    qPTSNext=OptPathPBA(e+1,1:N);
    costTr=CostOfPTStransition(qPTSPrev,qPTSNext,T.Dist);
    if isempty(find(sum(sat)==B1.trans{qBPrev,qBnext}, 1)) && ~isinf(costTr)
        error=1;
        break
    end
end
