function sat=observeInDiscreteEnvironment_v2(N,N_p,AP,xNew)


    sat=[];%collects the APs that are satisfied at xNew
    for ap=1:N_p
        %check if AP: AP_ap=AP(ap,N+1) is satisfied
        robots=AP{ap,N+2};
        checkAP=0;
        for indexRbt=1:length(robots)
            rbt=robots(indexRbt);
            loc=AP{ap,rbt};            
            if find(xNew(rbt)==loc)%abs(xNew(rbt)-AP{ap,rbt})<epsilon
                checkAP=checkAP+1;
                if AP{ap, N+3}==1
                    %this AP is satisfied if at least one of the statements in
                    %[AP{ap,N+2}, AP{ap,rbt}] is satisfied
                    checkAP=length(robots);
                    break
                end
            end
        end
        if checkAP==length(robots)
             sat=[sat AP{ap,N+1}];
        end
    end
    if isempty(sat)
        sat=2^N_p;
    end