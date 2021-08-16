function [Loc, flagFeas]=mySAT(ap, AP, N)


flagFeas = 1;       %feasible transition
Loc = zeros(N,1);  %zero means your location is irrelavnt to satisfy ap
for p = 1 : length(ap)
    %e.g., ap=p2p4; need to satisfy both p2 and p4
    rbt = AP{ap(p),N+2}; % rbts involved in e.g., ap(p)=p2
    
    if  AP{ap(p),N+3} == 1 %OR operator
        availRbts=rbt(Loc(rbt)==0); %robots who havenot been assigned a location to be
        if ~isempty(availRbts)
        Loc(availRbts(1)) = AP{ap(p),availRbts(1)}(1);
        else
            flagFeas = 0;
            break
        end
    else % AND
        for j = 1 : length(rbt)
        
            if Loc(rbt(j))>0
                flagFeas = 0; %infeasible transition
                break
            else
                Loc(rbt(j))=AP{ap(p),rbt(j)}(1);
            end
            
        end
    end
    
 
end


%%
% % % from accoustic impedance code
% % N_p=4;
% % alphabet= alphabet_set(obtainAlphabet(N_p));
% % 
% % 
% % phi='F(p1 & p2) & F(p3 & p4)'
% % B1=create_buchi(phi,alphabet);
% % 
% % 
% % 
% % AP(1,1)={20};   %record at 7
% % AP(1,2)={20};
% % AP(1,3)={20};
% % 
% % AP(2,1)={27};   %play 9
% % AP(2,2)={27};   %P2
% % AP(2,3)={27};   %P2
% % 
% % AP(3,1)={44};   %record at 15
% % AP(3,2)={44};
% % AP(3,3)={44};
% % 
% % AP(4,1)={27};   %play at 9
% % AP(4,2)={27};
% % AP(4,3)={27};
% % 
% % 
% % 
% % 
% % AP(1,N+2)={[1,2,3]};AP(2,N+2)={[1,2,3]};AP(3,N+2)={[1,2,3]};AP(4,N+2)={[1,2,3]}; %AP(5,N+2)={[1,2]}; AP(6,N+2)={[1,7]}; AP(7,N+2)={[8,10]};
% % % AP(7,N+2)={6}; AP(8,N+2)={[9,6]}; %AP(9,N+2)={[8, 9, 10]};%indices of rbts involved in satisfaction of an AP
% % 
% % AP(1,N+3)={1};AP(2,N+3)={1};AP(3,N+3)={1};AP(4,N+3)={1}; %AP(5,N+3)={0}; AP(6,N+3)={0};%if 0=> "AND". If "1"=> OR
% % 
% % %%word=B1.trans{j1,j2}(w);
% %                 %word=B1.trans{j1,j2}(1);
% %                 ap=findAP(3);
            