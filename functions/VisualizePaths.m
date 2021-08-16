function VisualizePaths (T, BestPrefix, BestSuffix)

plotTS_mm(T);
axis([min(T.x)-0.5 max(T.x)+0.5 min(T.y)-0.5 max(T.y)+0.5])
title('Execution of prefix part')
%plot robots

Paths =[BestPrefix; repmat(BestSuffix,5,1)]; % prefix + five executions of suffix path
col=repmat('r',N,1);


for j=1:N
    plot(p(1,j),p(2,j),'ro','MarkerSize',6,'MarkerFaceColor',col(j))%'r')
end
plot(p(1,1),p(2,1),'ro','MarkerSize',6,'MarkerFaceColor',col(1))%'r')
pause(14)
k=2;
NextState=Paths(k,:);
TravDist=diag(Dist(PrevState,NextState));
TravelTime=10;%iterations
Step=TravDist/TravelTime
xloc=T.x(Paths(k,:));
yloc=T.y(Paths(k,:));
pNext=[xloc;yloc];
iter=0;
%direction=pNext-p

r=0.5;
ang=0:0.01:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
plotTS_mm(T);
axis([min(T.x)-0.5 max(T.x)+0.5 min(T.y)-0.5 max(T.y)+0.5])
colorR='r'
while 1
    
    
    for j=1:N
        z=pNext(1,j)-p(1,j)+(pNext(2,j)-p(2,j))*1i;
        p(1,j)=p(1,j)+cos(angle(z))*Step(j);
        p(2,j)=p(2,j)+sin(angle(z))*Step(j);
        %p(:,j)=Step(j).*(pNext(:,j)-p(:,j))+ p(:,j);
        %plot(p(1,j),p(2,j),'ro','MarkerSize',6,'MarkerFaceColor','r')
    end
    clf
    plotTS_mm(T);
    axis([min(T.x)-0.5 max(T.x)+0.5 min(T.y)-0.5 max(T.y)+0.5])
    for j=1:N
        %p(:,j)=Step(j)*(pNext(:,j)-p(:,j))
        plot(p(1,j),p(2,j),'ko','MarkerSize',7,'MarkerFaceColor',col(j))%'r')
        text(p(1,j)+0.1,p(2,j),num2str(j));
    end
    iter=iter+1;
    if k<=IterPre
        title('Execution of prefix part')
    else
        title('Execution of suffix part')
    end
    %-------------Only for Interm Connectivity----------------
    
%     %Team 1
%     if abs(p(1,1)-p(1,2))<=10^(-5) && abs(p(1,1)-T.x(5))<=10^(-5) && abs(p(2,1)-p(2,2))<=10^(-5) && abs(p(2,1)-T.y(5))<=10^(-5)
%         plot(T.x(5)+xp,T.y(5)+yp);
%         text(T.x(5)-0.3, T.y(5)+0.7,'Team 1')
%         if any(col(1:2)==colorR)
%             col(1:2)=colorR;
%         end
%         pause(0.5)
%     end
%     %Team 2
%     if abs(p(1,2)-p(1,3))<=10^(-5) && abs(p(1,3)-p(1,4))<=10^(-5) && abs(p(1,4)-T.x(1))<=10^(-5) && abs(p(2,2)-p(2,3))<=10^(-5) && abs(p(2,3)-p(2,4))<=10^(-5) && abs(p(2,4)-T.y(1))<=10^(-5)
%         plot(T.x(1)+xp,T.y(1)+yp);
%         text(T.x(1)-0.3, T.y(1)+0.7,'Team 2')
%         if any(col(2:4)==colorR)
%             col(2:4)=colorR;
%         end
%         pause(0.5)
%     end
%     %Team 3
%     if abs(p(1,4)-p(1,4))<=10^(-5) && abs(p(1,5)-p(1,6))<=10^(-5) && abs(p(1,6)-T.x(7))<=10^(-5) && abs(p(2,4)-p(2,4))<=10^(-5) && abs(p(2,5)-p(2,6))<=10^(-5) && abs(p(2,6)-T.y(7))<=10^(-5)
%         plot(T.x(7)+xp,T.y(7)+yp);
%         text(T.x(7)-0.3, T.y(7)+0.7,'Team 3')
%         if any(col(4:6)==colorR)
%             col(4:6)=colorR;
%         end
%         pause(0.5)
%     end
%     %Team 4
%     if abs(p(1,6)-p(1,7))<=10^(-5) && abs(p(1,7)-T.x(8))<=10^(-5) && abs(p(2,6)-p(2,7))<=10^(-5) && abs(p(2,7)-T.y(8))<=10^(-5)
%         plot(T.x(8)+xp,T.y(8)+yp);
%         text(T.x(8)-0.3, T.y(8)+0.7,'Team 4')
%         if any(col(6:7)==colorR)
%             col(6:7)=colorR;
%         end
%         pause(0.5)
%     end
%     %Team5
%     if abs(p(1,7)-p(1,8))<=10^(-5) && abs(p(1,7)-T.x(4))<=10^(-5) && abs(p(2,7)-p(2,8))<=10^(-5) && abs(p(2,7)-T.y(4))<=10^(-5)
%         plot(T.x(4)+xp,T.y(4)+yp);
%         text(T.x(4)-0.3, T.y(4)+0.7,'Team 5')
%         if any(col(7:8)==colorR)
%             col(7:8)=colorR;
%         end
%         pause(0.5)
%     end
%     %Team 6
%     if  abs(p(1,8)-p(1,9))<=10^(-5) && abs(p(1,9)-T.x(3))<=10^(-5) &&  abs(p(2,8)-p(2,9))<=10^(-5) && abs(p(2,9)-T.y(3))<=10^(-5)
%         plot(T.x(3)+xp, T.y(3)+yp);
%         text(T.x(3)-0.3, T.y(3)+0.7,'Team 6')
%         if any(col(8:9)==colorR)
%             col(8:9)=colorR;
%         end
%         pause(0.5)
%     end
%     
    %---------------------------------------------------------
    
    
    
    if all(col=='r')
        col(2)='r';%y
        colorR='r';%y
    end
    pause(0.06)
    if mod(iter,TravelTime)==0
        k=k+1;
        xloc=T.x(Paths(k,:));
        yloc=T.y(Paths(k,:));
        pNext=[xloc;yloc];
        PrevState=NextState;
        NextState=Paths(k,:);
        TravDist=diag(Dist(PrevState,NextState));
        Step=TravDist/TravelTime;
    end
end
% =========================================================================
