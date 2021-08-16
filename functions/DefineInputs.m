function [T, N, x0, phi, N_p, B1, AP, Termination, w] = DefineInputs()
% outputs:

% T: weighted Transition System (TS); current implementation assumes that all
% robots have the same TS
    % T.Q: set of states, i.e., a vector with dimensions <numOfStates x 1>
    % (user specified)
    % T.x: vector containing the x-coordinate of the the location of each
    % TS state  (user specified)
    % T.y: vector containing the y-coordinate of the the location of each
    % TS state  (user specified)
    % NOTE: the function createFTS generates the above three components randomly.
    % Comment it out if they should determined by a user;

% N: number of robots

% x0: vector Nx1, initial state of each robot in their TS

% phi: LTL formula

% N_p: number of atomic propositions that appear in phi

% B1: NBA corresponding to the LTL formula \phi

% AP: cell array defining where each atomic proposition in \phi is satisfied  

% w: parameter in [0,1] determining the weight between the prefix and suffix cost.



%% ---------------------Define transition system---------------------------
numOfStates    = 1000;                            % number of states in the TS
degree         = 28;                              % average degree per node in the TS
T              = createFTS(numOfStates,degree/2); % generates a graph-based representation of a random transition system with <numOfStates> 
                                                  % number of states and average degree per node <degree>
T              = adjMatrix2adjList(T);            % adjacency list of the TS
T.Dist         = DistanceMatrixA(T);              % weight/cost matrix for each transition in the TS; selected to be the Euclidean distance between two TS states
%fileID = fopen('/Users/yiannis/Dropbox/research/Duke/RRT and global
%LTL/Main/txtOutput/TS1000N100.txt','w') % specify the path where the txt
%file should be saved
%outputTStxt(T,N,x0, fileID) %outputs the TS in a format that can be
%recognized by NuSMV and nuXmv

%--------------------------------------------------------------------------


%% ---------------------------Team of robots-------------------------------
N             = 100;                              % number of robots
x0            = (1:100);                          % initial states of robots within their TS
%  ------------------------------------------------------------------------


%% ---------------------------Buchi Automaton------------------------------
phi           = 'G(p1-> X(!p1 U p2)) & GF(p1) & GF(p3) & GF(p4) & (!p1 U p5) & G(!p6) & F(p7 | p8) & GF (p5)'; % LTL formula
N_p           = 8;                                          % number of atomic prositions that appear in phi
alphabet      = alphabet_set(obtainAlphabet(N_p));          % Generating the powerset (alphabet) 
                                                            % (e.g., if N_p=3 then: alphabet = p1, p2, p3, p1p2, p1p3, p2p3, p1p2p3, {empty word} )
disp('Translation of the LTL formula into a NBA has started')
tic
B1            = create_buchi(phi,alphabet);
time = toc;
textOut = ['The LTL formula was successfully translated into a NBA after ', num2str(time), 'secs'];
disp(textOut)
%numOfBuchiEdges =length(find(~cellfun(@isempty,B1.trans))); %number of edges in the NBA B1

% -------------------------------------------------------------------------


%% ----------------------------Atomic Propositions-------------------------
AP            = cell(N_p,N+2);
for i = 1 : N_p
    AP(i,N+1) = {2^(i-1)}; % atomic proposition p_i corresponds to the 2^(i-1) entry in "alphabet"
end

%pi_k (or xi__k in the IJRR paper) is defined as either the conjuction (AND) or
%disjuction (OR) of Boolean formulas b_i^k. Specifically, it is AND if 
%AP(k,N+3)={0} and it is OR if AP(k,N+3)={0}. 

%atomic proposition p1 (\xi_1 in the paper)
AP(1,4)       = {[720,340]}; %robot 4 has to be in either region 720 or 340 (boolean formula: b_1^1)
AP(1,3)       = {[110,330]}; %robot 3 has to be in either region 110 or 330 (boolean formula: b_2^1)
AP(1,1)       = {[110,980]}; %robot 1 has to be in either region 110 or 980 (boolean formula: b_3^1)
AP(1,2)       = {210};       %robot 2 has to be in region 210 (boolean formula: b_4^1) ...
AP(1,5)       = {172};       %...
AP(1,6)       = {10};
AP(1,7)       = {107};
AP(1,8)       = {501};
AP(1,9)       = {104};
AP(1,10)      = {71};
AP(1,11)      = {[900, 800]};
AP(1,12)      = {11};

%atomic proposition p2 (\xi_2 in the paper)
AP(2,12) = {191}; AP(2,13) = {101}; AP(2,14)={110}; AP(2,15)={20}; AP(2,16)={100};
AP(2,17) = {419}; AP(2,18) = {770}; AP(2,19)={990}; AP(2,20)={500}; AP(2,21)={920};
AP(2,22) = {77}; AP(2,23) = {820}; AP(2,24) = {43}; AP(2,25) = {100};
AP(2,26) = {210}; AP(2,27)={710}; AP(2,28)={890}; AP(2,29)={581};

%atomic proposition p3 (\xi_3 in the paper)
AP(3,29) = {201}; AP(3,30) = {950}; AP(3,31) = {29}; AP(3,32) = {63};
AP(3,33) = {391}; AP(3,34) = {265}; AP(3,35) = {827}; AP(3,36) = {738};
AP(3,37) = {661}; AP(3,38) = {562}; AP(3,39) = {489}; AP(3,40) = {111};
AP(3,41) = {171}; AP(3,42) = {320}; AP(3,43) = {21}; AP(3,44) = {3};
AP(3,45) = {105}; AP(3,46) = {801}; AP(3,47) = {199}; AP(3,48) = {101};
AP(3,49) = {770}; AP(3,50) = {690}; AP(3,51) = {44};

%atomic proposition p4 (\xi_4 in the paper)
AP(4,52) = {34}; AP(4,53) = {350}; AP(4,54) = {390}; AP(4,55) = {430}; 
AP(4,56) = {510}; AP(4,57) = {155}; AP(4,58) = {157}; AP(4,59) = {180};
AP(4,60) = {1}; AP(4,61) = {620}; AP(4,62) = {890}; AP(4,63) = {911};
AP(4,64) = {974}; AP(4,65) = {112}; AP(4,66) = {191}; AP(4,67) = {232};
AP(4,68) = {252}; AP(4,69) = {281}; AP(4,70) = {178}; AP(4,71) = {229};
AP(4,72) = {373}; AP(4,73) = {591}; AP(4,74) = {548};

%atomic proposition p5 (\xi_5 in the paper)
AP(5,74) = {841}; AP(5,75) = {732}; AP(5,76) = {409}; AP(5,77) = {931};
AP(5,78) = {510}; AP(5,79) = {651}; AP(5,80) = {167}; AP(5,81) = {178};
AP(5,82) = {640}; AP(5,83) = {221}; AP(5,84) = {905}; AP(5,85) = {111}; 
AP(5,86) = {675}; AP(5,87) = {312}; AP(5,88) = {215}; AP(5,89) = {229};
AP(5,90) = {607}; AP(5,91) = {800}; AP(5,92) = {911}; AP(5,93) = {982};
AP(5,94) = {710}; AP(5,95) = {719}; AP(5,96) = {772};

%atomic proposition p6 (\xi_6 in the paper)
AP(6,97) = {[7, 183, 850, 1010]}; 
AP(6,98) = {[650,777,888,999, 111, 222,333,444,555]};

%atomic proposition p7 (\xi_7 in the paper)
AP(7,96) = {2}; AP(7,97) = {110}; AP(7,98) = {831};

%atomic proposition p8 (\xi_8 in the paper)
AP(8,99) = {254}; AP(8,100) = {690};

AP = findRobots(AP, N, N_p); % computes which robots are involved in \xi_k for all k (see: AP{k,N+2})

%if 0=> "AND". If "1"=> OR
AP(1,N+3) = {0}; AP(2,N+3) = {0}; AP(3,N+3) = {0}; AP(4,N+3) = {0}; 
AP(5,N+3) = {0};  AP(6,N+3) = {1}; AP(7,N+3) = {0}; AP(8,N+3) = {0};
%--------------------------------------------------------------------------

%% ======================== Termination Criterion =========================
Termination.MaxIter = 0; % if the tree construction has to stop after maximum number of iterations, then set it to 1. 
% If the tree construction should stop once the first feasible (prefix/suffix) path is detected, then set it to 0
Termination.nMaxPre = 5000; % maximum number of iterations for the construction of the prefix tree
Termination.nMaxSuf = 5000; % maximum number of iterations for the construction of the suffix trees
% =========================================================================

%% ============================ Cost Function =============================
w = 0.9;                   % cost of prefix-suffix plan is (1-w)* costPrefix + w*(costSuffix)
% =========================================================================


