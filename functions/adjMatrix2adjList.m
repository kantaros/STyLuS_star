function T=adjMatrix2adjList(T)
%Dist=T.Dist;
node1=[];
node2=[];
weight=[];
for q1=1:length(T.Q)
    for q2=1:length(T.Q)
        if T.adj(q1,q2)~=0
            node1=[node1,q1];
            node2=[node2,q2];
            weight=[weight,1];
            %weight=[weight,T.Dist(q1,q2)];
        end
    end
end

%T.adjList=digraph(node1,node2,weight);
T.adjList=sparse(node1,node2,weight);