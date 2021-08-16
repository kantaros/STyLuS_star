%function genMovie

% Function to generate the animation of the network over time. The function
% marches over time and traverses the designed paths of agents accordingly.

% Initialization:
 
%store.domain=domain;
%store.C=C;
%store.N=N;
%store.M=M;
%store.parameters=parameters;
%store.colors=colors;
%store.smax=smax;

%%%initial (offline)
%iter=1;
%store.k(iter,:)=k;
%store.message(iter,:)=zeros(N,1);
%store.Path{iter}=path; %store paths
%store.pos{iter}=x;    % store current poisitions
%store.updTeam(iter,:)=zeros(M,1); %indices if teams are updated
%store.teams{iter}=T;
%store.ComPt(iter,:)=CurComPt;
%store.com(iter,:)=zeros(M,1); %store if team m communicated at iterCom
%store.ComPtCircle(iter,:)=zeros(M,1);%com point (red circles)

clear all
clc
load('store.mat','store')
domain=store.domain;
C=store.C; N=store.N; M=store.M; colors=store.colors;
parameters=store.parameters;
 user=store.user;
 userRec=0

clf
figH=1;
figure(figH)
plotEnv(store.domain,figH)


pause

hold on
iter=1;
Dir = 'Video/';
movie = VideoWriter([Dir, 'videoDyn1.avi']);
movie.Quality = 100;
movie.FrameRate = 18;
open(movie);

while iter<= store.iter-5000
    clf
    figure(figH)
    plotEnv(domain,figH)
    hold on
   iter
    path=store.Path{iter};
    x=store.pos{iter};
    k=store.k(iter,:);
    message=store.message(iter,:);
    updTeam=store.updTeam(iter,:);
%     if iter-1>0
%     Tnow=store.teams{iter-1};
%     else
%     Tnow=store.teams{1};
%     end
    T=store.teams{iter};
    CurComPt=store.ComPt(iter,:);
    
    %plot paths and robots
    for j=1:N
        %plot(x(j,1),x(j,2),'ko')
        
        if strcmp(parameters.pattern(j),'p')
            plot(path{j}(k(j):end,1),path{j}(k(j):end,2),'k:s','markersize',4,'markerfacecolor',colors(j,:))
        else
            plot(path{j}(k(j):end,1),path{j}(k(j):end,2),'k:s','markersize',4,'markerfacecolor',colors(j,:))
        end
        plot(x(j,1),x(j,2),'blacko','markersize',8,'markerfacecolor',colors(j,:));
        str=num2str(j);
        text(x(j,1)-0.15,x(j,2)+0.1,str)
        
        if message(j)==1
            plot(x(j,1)+0.1,x(j,2)+0.1,'red*','markersize',6)
        end 
    end
    
    if norm(x(N,:)-user)<=10^(-3)
        %robot N communicates with the user 
        if message(N)==1%if robot N received the message
           userRec=1;
        end
    end
    
    
    flagCom=0;
    
    %plot com points
    for m=1:M
        str=num2str(m);
        if ~isempty(T{m})
            str2=num2str(T{m}');%for the teams that communicate, it holds Tnext=Tnow
        else
            str2='empty';
        end
        %str2=['Team  ',str, ' =','[',str2,']'];
        str3= ['[',str2,']'];  
        
        if store.com(iter,m)==1
%            pause
            flagCom=1;
            index=store.ComPtCircle(iter,m);          
            %  text(C(index,1)-0.25,C(index,1)+0.25,str3,'Color','red')
            %text(C(index,1)-0.2,C(index,1)+0.4,strTeam,'Color','b')
            plot(C(index,1),C(index,2),'kd','markersize',6,'markerfacecolor','r')
        elseif updTeam(m)==1 && ~isempty(T{m})
            text(C(CurComPt(m),1)-0.25,C(CurComPt(m),2)+0.25,str3,'Color','red')
            plot(C(CurComPt(m),1),C(CurComPt(m),2),'md','markersize',6,'markerfacecolor','m')
        elseif updTeam(m)==1 && isempty(T{m})
            text(C(CurComPt(m),1)-0.25,C(CurComPt(m),2)+0.25,str3,'Color','cyan')
            plot(C(CurComPt(m),1),C(CurComPt(m),2),'cd','markersize',6,'markerfacecolor','c')
        elseif ~isempty(T{m})
            text(C(CurComPt(m),1)-0.25,C(CurComPt(m),2)+0.25,str3,'Color','red')
            plot(C(CurComPt(m),1),C(CurComPt(m),2),'gd','markersize',6,'markerfacecolor','g')
        end
    end
     
    plot(user(1),user(2),'blued','markersize',9,'markerfacecolor','blue')
    text(user(1)-0.3,user(2)+0.1,'User','Color','b')
    if userRec==1
        plot(user(1)+0.1,user(2)+0.1,'red*','markersize',6)
    end
    frame = getframe(figH); writeVideo(movie, frame);
    %plot circles for teams that communicate 
    for m=1:M
        if store.com(iter,m)==1
            index=store.ComPtCircle(iter,m); 
            strTeam=['Team ',num2str(m),' communicates'];
            text(C(index,1)-0.45,C(index,2)+0.4,strTeam,'Color','r')
            h=circle2(C(index,1),C(index,2),0.1,4);
            pause(0.01)
            frame = getframe(figH); writeVideo(movie, frame);
            delete(h);
            
            h=circle2(C(index,1),C(index,2),0.2,3);
            pause(0.01); frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            delete(h)
            h=circle2(C(index,1),C(index,2),0.3,2.5);
            pause(0.01); frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            delete(h)
            h=circle2(C(index,1),C(index,2),0.4,1.5);
            pause(0.01); frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            frame = getframe(figH); writeVideo(movie, frame);
            delete(h)
            %pause
        end
    end
     %plot polygons for teams that changed
    for m=1:M
         if updTeam(m)==1 && ~isempty(T{m})
             strTeam=['Team ',num2str(m),' changed'];
             text(C(CurComPt(m),1)-0.45,C(CurComPt(m),2)+0.4,strTeam,'Color','magenta')
             h=polygon2(C(CurComPt(m),1),C(CurComPt(m),2),0.4,4,'m');  pause(0.01);  frame = getframe(figH); writeVideo(movie, frame);
             frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); 
             frame = getframe(figH); writeVideo(movie, frame);delete(h); 
             h=polygon2(C(CurComPt(m),1),C(CurComPt(m),2),0.3,3,'m'); pause(0.01);  frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame);  
             frame = getframe(figH); writeVideo(movie, frame);delete(h); 
             h=polygon2(C(CurComPt(m),1),C(CurComPt(m),2),0.2,2.5,'m'); pause(0.01); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); 
             frame = getframe(figH); writeVideo(movie, frame);delete(h); 
             h=polygon2(C(CurComPt(m),1),C(CurComPt(m),2),0.1,1.5,'m'); pause(0.01); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); 
             frame = getframe(figH); writeVideo(movie, frame); delete(h); 
         end
         if updTeam(m)==1 && isempty(T{m})
             strTeam=['Team ',num2str(m),' deleted'];
             %strTeam=['Team deleted'];
             text(C(CurComPt(m),1)-0.45,C(CurComPt(m),2)+0.4,strTeam,'Color','c')
             h=polygon2(C(CurComPt(m),1),C(CurComPt(m),2),0.4,4,'c'); pause(0.01); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); 
             frame = getframe(figH); writeVideo(movie, frame); delete(h); 
             h=polygon2(C(CurComPt(m),1),C(CurComPt(m),2),0.3,3,'c'); pause(0.01); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); 
             frame = getframe(figH); writeVideo(movie, frame); delete(h); 
             h=polygon2(C(CurComPt(m),1),C(CurComPt(m),2),0.2,2.5,'c'); pause(0.01); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame);  
             frame = getframe(figH); writeVideo(movie, frame);delete(h); 
             h=polygon2(C(CurComPt(m),1),C(CurComPt(m),2),0.1,1.5,'c'); pause(0.01); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame); frame = getframe(figH); writeVideo(movie, frame);  
             frame = getframe(figH); writeVideo(movie, frame);delete(h); 
             
         end
    end
    
    if flagCom==1
        pause(0.01)
    else
        pause(0.01)
    end
    iter=iter+1;
    % Write the video frame:
    frame = getframe(figH); writeVideo(movie, frame);
   % pause
end


close(movie);
close(figH);



