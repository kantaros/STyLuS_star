function plotTS_mm(T)
x=T.x;y=T.y;
figure(1)

axis([min(x)-1 max(x)+1 min(y)-1 max(y)+1])
hold on

for i=1:length(T.Q)
    for j=i:length(T.Q)
        if T.adj(i,j)>0 
             plot([x(i),x(j)],[y(i),y(j)],'b--')
        end
      
    end
end
m=(1:length(T.Q));
plot(x(m),y(m),'blacko','markersize',8,'markerfacecolor','black');

for m=1:length(T.Q)
%text(x(m)+0.2,y(m)+0.2,num2str(m));
%text(x(m)+0.2,y(m)+0.2,sprintf('$\\tilde{r}_m=%s$',num2str(var_name)),'fontsize',14,'Interpreter','latex');
str = sprintf('$\\ell_{%d}$',m);
text(x(m)+0.2,y(m)+0.2,str,'Interpreter','latex','FontSize', 16)
end
axis equal
box on
axis([min(T.x)-1 max(T.x)+1 min(T.y)-1 max(T.y)+1])


% text(x(1)+0.05,y(1)+0.1,'1')
% text(x(2)+0.05,y(2)+0.1,'2')
% text(x(3)+0.05,y(3)+0.1,'3')
% text(x(4)+0.05,y(4)+0.1,'4')
% text(x(5)+0.05,y(5)+0.1,'5')
% text(x(6)+0.05,y(6)+0.1,'6')
% text(x(7)+0.05,y(7)+0.1,'7')
% text(x(8)+0.05,y(8)+0.1,'8')
% text(x(9)+0.05,y(9)+0.1,'9')
% text(x(10)+0.05,y(10)+0.1,'10')
% text(x(11)+0.05,y(11)+0.1,'11')
% text(x(12)+0.05,y(12)+0.1,'12')
% text(x(13)+0.05,y(13)+0.1,'13')
% text(x(14)+0.05,y(14)+0.1,'14')
% text(x(15)+0.05,y(15)+0.1,'15')
% text(x(16)+0.05,y(16)+0.1,'16')
% 
% 
