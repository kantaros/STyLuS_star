
%N=5
%fileID = fopen('/Users/yiannis/Dropbox/research/Duke/RRT and global LTL/Main/txtOutput/test.txt','w')

function outputSPINTStxt(T, fileID)
fprintf(fileID,'%4s%d', 'bool');
numOfAPs = length(T.Q);
numOfStates=numOfAPs;
adj=T.adj;
for i = 1 : numOfAPs-1
    
    fprintf(fileID,'%2s%d%1s', 'a',i,',');
end
fprintf(fileID,'%2s%d%1s\n', 'a',numOfAPs,';');

fprintf(fileID,'%4s\n', 'init');
fprintf(fileID,'%1s\n', '{');
%...
for e = 1 : numOfStates
    next=find(adj(e,:)>0);
    fprintf(fileID,'%3s%d%1s\n', 's',e,':');
    fprintf(fileID,'%10s%1s%1s\n', 'atomic','','{');
    fprintf(fileID,'%7s%1d%1s%5s\n', 'a',e,'=','true;');
    
    for zz = 1 : numOfStates
        if zz~=e
            fprintf(fileID,'%7s%1d%1s%6s\n', 'a',zz,'=','false;');
        end
    end
    
    fprintf(fileID,'%5s\n', '}');
    %fprintf(fileID,'%8s%1s%1s%1d%1s', 'goto','','s',next(1),';');
    for nn = 1: length(next)
        fprintf(fileID,'%8s%1s%1s%1d%1s\n', 'goto','','s',next(nn),';');
        %fprintf(fileID,'%1s%1d%1s', 's',next(nn),',');
    end
    %fprintf(fileID,'%1s%1d%1s\n', 's',next(end),';');
end
%...
fprintf(fileID,'%1s\n', '}');

fclose(fileID);
