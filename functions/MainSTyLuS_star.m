function [BestPrefix, BestSuffix, ListOfPrefix, ListOfSuffix, wrongPre, wrongSuf] = MainSTyLuS_star(T, N, x0, N_p, B1, AP, Termination, w)
% Inputs: output of function "DefineInputs()"

% Outputs:

% BestPrefix: Best prefix plan defined as sequence of PTS states, i.e.,
% matrix HxN where H is the number of PTS states need to be visited and N
% is the number of robots. For instance, <BestPrefix(k,:)> refers to the
% k-th product state within the prefix step; in other words, it refers to
% the state of the multi-robot system at the k-th iteration.
% <BestPrefix(k,j)> refers to the state of robot j at the k-th iteration

% BestSuffix: Best suffix plan; defined as <BestPrefix>

% ListOfPrefix: cell array Fx1 collecting all prefix parts computed during
% the construction of the prefix tree. <ListOfPrefix{f}> corresponds to the
% f-th prefix path defined as <ListOfPrefix>.

% ListOfSuffix: cell array Fx1 collecting the best suffix part - found during
% the construction of the suffix tree - corresponding to the f-th prefix
% path <ListOfSuffix{f}> 

% wrongPre: vector collecting indices <f> to prefix parts that are possibly
% wrong. This is a result of a sanity check. It should be empty if all
% perfix parts pass the sanity check

% wrongSuf: defined exactly as <wrongPre>
%% ============ Pruning: Detect feasible NBA transitions ==================
disp('Pruning of NBA has started')
tic
B1 = NBAfeasibility (B1, AP, N, N_p); 
timePrune = toc;

textOut = ['Pruning of NBA has finished after ', num2str(timePrune), ' secs'];
disp(textOut)
% =========================================================================

%% =========================== compute prefix Tree ========================

disp('Construction of the prefix tree has started')
nMaxPre   = Termination.nMaxPre;
Qpba      = zeros(nMaxPre,N+1);     % matrix capturing set of tree nodes, column N+1 refers to the buchi state
Qpba(1,:) = [x0,B1.S0(1)];          % initialize set of tree nodes
qPr       = [x0,B1.S0(1)];          % root of the tree
ind       = 2;                      % index pointing to the next available (empty) entry of Qpba
parent    = zeros(nMaxPre,1);       % vector capturing edges in the tree. parent of n-th sample is parent(n)
CostNode  = zeros(nMaxPre,1);       % vector capturing cost of reaching sample/node n: CostNode(n)
%SizeTree = zeros(nMaxPre,1);       % vector capturing the size of tree at iteration n: SizeTree(n)

tic 
[Qpba, parent, CostNode, F, ~, ~, ~] = stylusPrefix(Qpba, B1, T, AP, parent, CostNode, N, qPr, ind, N_p, Termination); %synthesizes feasible plans (rewiring is commented out)
timePre = toc;                      % time required to compute prefix tree
textOut = ['Construction of prefix tree finished after ', num2str(timePre), 'secs'];
disp(textOut)
textOut = ['Number of computed prefix paths: ', num2str(length(F))];
disp(textOut)

ListOfPrefix = cell(length(F),1);    % prefix path as sequence of multi-robot TS states
CostPrefix  = Inf*ones(length(F),1);
errorPre    = zeros(length(F),1);
for f=1:length(F)

    [OptPathPrePTS, OptPathPrePBA] = Path2Root(F(f), parent,Qpba);
    ListOfPrefix{f}                 = OptPathPrePTS;                          % f-th prefix as a sequence of PTS states
    CostPrefix(f)                  = CostOfPath(OptPathPrePTS, T.Dist);         % equivalent to CostNode(F(f))
    errorPre(f)                    = VerifySol(OptPathPrePBA, T, B1, N, N_p, AP); % checks if the f-th prefix makes sense. if errorPre(f)=1, then something is wrong
end

disp('...sanity check for prefix paths...')
if sum(errorPre)==0
    disp('all prefix paths passed the sanity check')
    wrongPre = [];
else
    wrongPre = find( 1 == errorPre);
    warning('Something is wrong with the prefix parts. Type <wrongPre> to get the indices of these prefix parts. The actual f-th PTS prefix part can be accessed by typing <ListOfPrefix{f}>.')
end
% =========================================================================

%% =========================== compute suffix Trees =======================
QpbaPre     = Qpba;                  % store prefix data
nMaxSuf     = Termination.nMaxSuf;                  % max number of iterations to construct tree
ListOfSuffix = cell(length(F),1);     % cell array. ListOfSuffix{f} contains the best found suffix part corresponding to the f-th prefix part
CostSuffix  = Inf*ones(length(F),1); % cost of best found suffix plan
CostPlan    = Inf*ones(length(F),1); % cost of f-the prefix-suffix plan
errorSuf    = zeros(length(F),1);

disp('Construction of suffix paths has started')
for f = 1 : length(F)
    textOut = ['Construction of suffix path for the prefix path #', num2str(f), ' has started'];
    disp(textOut)

    %qPBA0 = QpbaPre(F(f),:);      % initial state of the tree (final state of prefix path #f) around which a suffix loop needs to be found
    qB    = QpbaPre(F(f),N+1);    % final NBA state around which a suffix loop needs to be found
    x0    = QpbaPre(F(f),1:N);    % PTS state around which a suffix loop needs to be found
    
    sat0     = observeInDiscreteEnvironment_v2(N, N_p, AP, x0); % observation at the root PTS of the tree
    stopTree = 0;
    if  ~isempty(find(sum(sat0)==B1.trans{qB, qB}, 1)) % if current observation enables a self loop
        S = 1;                % set that collects the indices of states that can close the loop around the root (final state)
        stopTree=1;           % trivial loop around the root (final state) has been found
    end
    
    %------------------- initialize f-th suffix tree ----------------------
    Qpba      = zeros(10, N+1);
    Qpba(1,:) = [x0, qB];
    qPr       = [x0, qB];           % root of the tree
    parent    = zeros(nMaxSuf, 1);  % parent of n-th sample
    CostNode  = zeros(nMaxSuf, 1);
    ind       = 2;                 % points to the next available (empty) entry of Qpba
    %----------------------------------------------------------------------
    
    tic
    if  stopTree == 0
        [Qpba,parent, CostNode, S, ~, ~, ~] = stylusSuffix(Qpba, B1, T, AP, parent, CostNode, N, qPr, ind, N_p, Termination);
    end
    timeSuf = toc;
    
    textOut = ['Construction of suffix tree #', num2str(f), ' finished after ', num2str(timeSuf), 'seconds'];
    disp(textOut)
    textOut = ['Number of computed suffix paths for the prefix part #', num2str(f), ' is ', num2str(length(S))];
    disp(textOut)

    if ~isempty(S) % if suffix paths have been found
        TempSuffix = cell(length(S),1);
        TempCost   = Inf*ones(length(S),1);

        for ff = 1 : length(S)
            [OptPathSufPTS, OptPathSufPBA] = Path2Root(S(ff), parent,Qpba);
            OptPathSufPTS(end+1,:)         = OptPathSufPTS(1,:);
            OptPathSufPBA(end+1,:)         = OptPathSufPBA(1,:);
            TempSuffix{ff}                 = OptPathSufPTS;
            TempCost(ff)                   = CostOfPath(OptPathSufPTS, T.Dist); % CostNode(S(1)) + cost of going from S(1) back to the root of the tree
        end
        [~, ind]                           = min(TempCost);
        ListOfSuffix{f}                     = TempSuffix{ind}; % f-th suffix as a sequence of multi-robot TS states
        CostSuffix(f)                      = TempCost(ind);
        textOut                            = ['Best suffix path for the prefix part #', num2str(f), ' has been selected'];
        disp(textOut)
    else
       disp('No suffix paths have been found for the current prefix part. If they exist, consider increasing the maximum number of iterations <nmaxsuf>.')
    end
    errorSuf(f) = VerifySol(OptPathSufPBA, T, B1, N, N_p, AP); % checks if the f-th suffix makes sense. if errorPre(f)=1, then something is wrong
    CostPlan(f) = (1-w)*CostPrefix(f) + w*CostSuffix(f);
end

disp('...sanity check for suffix paths...')

if sum(errorSuf)==0
    disp('all suffix paths passed the sanity check')
    wrongSuf = [];
else
    wrongSuf = find( 1 == errorPre);
    warning('Something is wrong with the suffix parts. Type <wrongSuf> to get the indices of these suffix parts. The actual f-th PTS suffix part can be accessed by typing <ListOfSuffix{f}>.')
end

disp('Construction of suffix paths has ended')

[~,indBestPlan] = min(CostPlan);
BestPrefix      = ListOfPrefix{indBestPlan};
BestSuffix      = ListOfSuffix{indBestPlan};
disp('The best prefix-suffix plan has been selected.')
disp('The suffix plan is executed indefinitely after the execution of the prefix part.')
disp('Type <BestPrefix> and <BestSuffix> to get the best found prefix and suffix plan, respectively.')
%disp('Prefix path:')
%BestPrefix
%disp('Suffix path:')
%BestSuffix