function [Dist]=DistanceMatrixA(T)

M = length(T.Q);
Dist = Inf*ones(M,M);

for e1 = 1:M
    
    pos1 = [T.x(e1) T.y(e1)];
    vec = find(T.adj(e1,:)>0);
    
    for v = 1 : length(vec)
        
      e2 = vec(v);
      if T.adj(e1,e2) == 1
      pos2 = [T.x(e2) T.y(e2)];
      Dist(e1,e2) = norm(pos1-pos2);
      end
      
    end
    
end

% 
% 
% M=length(T.Q);
% Dist=zeros(M,M);
% vec=[T.x' T.y'];
% for e=1:M
%     pos=repmat([T.x(e) T.y(e)],M, 1); 
%     vecdist=vec(:,1)-pos(:,1)+i*(vec(:,2)-pos(:,2));
%     Dist(e,:)=abs(vecdist).*T.adj(:,e);
%     tempIndex=find(Dist(e,:)>0);
%     tempDist=Dist(e,tempIndex);
%     [minDist(e),index]=min(tempDist);
%     IndexMinDist(e)=tempIndex(index);
%     temp1=find(Dist(e,:)==0);Dist(e,temp1)=BigNum;
% end
% for e=1:M
%     Dist(e,e)=0;%Dist-eye(M)*BigNum;
% end
% 
