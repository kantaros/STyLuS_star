

function [B1] = NBAfeasibility (B1, AP, N, N_p)
%assumptions made:
% regions of interest are disjoint

%-------Buchi distance----------------
neig = zeros(length(B1.S))+Inf;                                             %adjacency matrix in pruned NBA
%neigInit=neig;
neigLoc = cell(length(B1.S),length(B1.S));
neigWord = neig;
for j1 = 1:length(B1.S)
    for j2 = 1:length(B1.S)
        if ~isempty(B1.trans{j1,j2})
            lenW = length(B1.trans{j1,j2});
            if lenW < 2^N_p
                for w = 1 : lenW
                    word = B1.trans{j1,j2}(w);
                    
                    %word=B1.trans{j1,j2}(1);
                    ap = findAP(word);
                    [Loc, flagFeas] = mySAT(ap, AP, N);
                    if flagFeas == 1                                        %if such a transition is possible to be enabled
                        neig(j1,j2) = 1;
                        neigWord(j1,j2) = w;                                % word that enables this transition
                        neigLoc{j1,j2} = Loc;
                        break
                    end
                end
            else                                                       % guard on NBA transition is logical 1, so the transition is feasible
                %flagFeas=1;
                neig(j1,j2) = 1;
                neigWord(j1,j2) = 0;                                % irrelavant what you observe
                neigLoc{j1,j2} = zeros(N,1);
            end
            
            %neigInit(j1,j2)=1;
        
        end
    end
end
B1.neig = neig;
B1.word = neigWord;
B1.Loc = neigLoc;

distanceB = zeros(length(B1.S))+Inf;                                        %buchi distance:
for s = 1:length(B1.S)
    r_cost = zeros(length(B1.F),1);
    for s2 = 1:length(B1.S) %f=1:length(B1.F)
     
        [r_path, r_cost] = dijkstra_1(s, s2, neig);
        distanceB(s,s2) = (r_cost);
    end  
end
B1.distanceB = distanceB;
%%
% 
% load('nba','B1','phi')
% N=10;
% N_p=8;
% %-------------Atomic Propositions--------
% AP=cell(N_p,N+2);
% num=-100;
% AP(:,:)={num};
% for i=1:N_p
%     AP(i,N+1)={2^(i-1)};
% end
% %phi= 'G(p1-> X(!p1 U p2)) & GF(p1) & GF(p3) & GF(p4) & (!p1 U p5) & G(!p6) & F(p7 | p8) & GF (p5)'
% %Specify where the APi [AP(i,N+1)] is satisfied
% %ap1=p1=AP(1,N+1)
% AP(1,8)={[20,190,1101]};%, 1000,2,6,7,8
% AP(1,9)={[1001,102,201,3051]};
% AP(1,1)={7007};
% 
% 
% AP(2,2)={610};
% AP(2,3)={54};%P2
% AP(2,4)={1439};
% 
% AP(3,4)={91};
% AP(3,5)={9957};
% 
% AP(4,5)={1001};
% AP(4,6)={381};
% AP(4,10)={821};
% 
% AP(5,6)={7851};
% AP(5,7)={8481};
% 
% AP(6,1)={[171,6006, 105, 311,805,2200, 5555,15,81]};
% AP(6,7)={[165,33, 110, 501,331]};
% 
% 
% AP(7,10)={17};
% AP(7,8)={6101};
% 
% 
% AP(8,9)={6541};
% AP(8,6)={9990};
% 
% 
% % AP(9,10)={2};
% % AP(9,8)={50};
% % AP(9,9)={88};
% 
% 
% AP(1,N+2)={[8*ones(1,1),9,1]};AP(2,N+2)={[2,3,4]};AP(3,N+2)={[4,5]};AP(4,N+2)={[5,6,10]}; AP(5,N+2)={[6,7]}; AP(6,N+2)={[1,7]}; AP(7,N+2)={[8,10]}; 
% % AP(7,N+2)={6};
% AP(8,N+2)={[9,6]}; %AP(9,N+2)={[8, 9, 10]};%indices of rbts involved in satisfaction of an AP
% AP(1,N+3)={0};AP(2,N+3)={0};AP(3,N+3)={0};AP(4,N+3)={0}; AP(5,N+3)={0}; AP(6,N+3)={1}; AP(7,N+3)={0}; 
% % AP(7,N+2)={6};
% AP(8,N+3)={0};%if 0=> "AND". If "1"=> OR
% %-------------------------------------
% 
