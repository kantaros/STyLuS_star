
%N=5
function outputTStxt(T,N,x0, fileID)

for i=1:N
    fprintf(fileID,'%9s%d\n', 'MODULE TS',i);
    fprintf(fileID,'%3s\n', 'VAR');
    fprintf(fileID,'%6s %d %2s %d%1s\n', 's:',1, '..', length(T.Q),';');
    fprintf(fileID,'%6s\n', 'ASSIGN');
    fprintf(fileID,'%14s %5d%1s\n', 'init(s) :=', x0(i),';');
    fprintf(fileID,'%19s\n', 'next(s) := case');
    for e=1:length(T.Q)
        %e=1
        next=find(T.adj(e,:)>0);
        %s=1 : {1, 2, 3, 8};
        %fprintf(fileID,'%6s %12s\n','s=','exp(x)');
        fprintf(fileID,'%6s%d %2s%d%1s','s=',e, ': {', next(1),',');
        for n=2:length(next)-1
            fprintf(fileID,'%d%1s ', next(n),',');
        end
        fprintf(fileID,'%d%2s\n',next(end), '};');
    end
    fprintf(fileID,'%5s\n', 'esac;');
    fprintf(fileID,'\n');
end
%MODULE main
%VAR
%rbt1: TS1; rbt2: TS2; rbt3: TS1; rbt4: TS2; rbt5: TS1; rbt6: TS2; rbt7: TS1; rbt8: TS2; rbt9: TS1;  rbt10: TS2;  rbt11: TS1; 

fprintf(fileID,'%11s\n', 'MODULE main');
fprintf(fileID,'%3s\n',  'VAR');
for i=1:N
    fprintf(fileID,'%1s%d%1s% 2s%d%1s\n', 'r',i,':','TS',i,';');
end



fclose(fileID);