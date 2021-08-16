function T=createFTS(S,md)

%
T.Q=1:S;
b=S; a=1;
T.x=(b-a).*rand(S,1) + a;%1:S;
T.y=(b-a).*rand(S,1) + a;%zeros(1,S);
%T.adj=ones(S,S);
T.adj=zeros(S,S);
% 

% for j=1:S
%     %T.adj(j,j)=1;
%     if j<S
%         T.adj(j,j+1)=1;
%         T.adj(j+1,j)=1;
%         
%     end
%     if j>1
%         T.adj(j,j-1)=1;
%         T.adj(j-1,j)=1;
%     end
% %     T.adj(1,md)=1;
% %     T.adj(md,1)=1;
% %     if mod(j,md)==0
% %         if j+md<=S
% %             T.adj(j,j+md)=1;
% %             T.adj(j+md,j)=1;
% %         end
% %         if j-md>0
% %             T.adj(j,j-md)=1;
% %             T.adj(j-md,j)=1;
% %         end
% %     end
% end

T.adj=T.adj+diag(ones(S,1));% add self loops
% 
K=md;%max(floor(S/md),1);% num of random transitions
for j=1:S
rr=randi(S,K,1);
    T.adj(j,rr)=1;
    T.adj(rr,j)=1;
end
