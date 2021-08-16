
function T = ts_mm(N_p,Ng)
%grid :Ng x Ng
%number of atomic propositions: N_p

T.Q=1:Ng*Ng;
T.Q0 = 1;
% Preallocate cells for 5224 labels
T.labels=cell(Ng*Ng,1);

[x,y,adj]=create_TS(Ng);
adj=adj+eye(Ng*Ng);
T.x=x;
T.y=y;
% Number of propositions is T.N_p
T.N_p = N_p;
% Generating the powerset (alphabet) (for 3: p1, p2, p3, p1p2, p1p3, p2p3, p1p2p3, {}
T.alphabet= alphabet_set(obtainAlphabet(T.N_p));
% p2 (bitMask value: 2) -> r1Upload
% p3 (bitMask value: 4) -> r2Gather
% p4 (bitMask value: 8) -> r2Upload
% p5 (bitMask value: 16) -> Upload
% p6 (bitMask value: 32) -> Sync
% p1 (bitMask value: 1) -> r1Gather
% For 'none' use bit 6 (64)
% p1 p2 p1p2 p3
%p1: being in vertex 6
%p2 being in vettex 4
%p3 for "none" use. it wll be always the last member of the alphabet set,
%i.e its index is 2^N_p
% Adjacencies

T.adj = adj;%[1 1 0 1 0 0; 1 1 1 0 1 0 ; 0 1 1 0 0 1 ;1 0 0 1 1 0;0 1 0 1 1 1;0 0 1 0 1 1];
T.obs = 2^(T.N_p)*ones(Ng*Ng,1);
T.obs(6)=1;% state 3 "observes" if you are in p1 
T.obs(3)=2;