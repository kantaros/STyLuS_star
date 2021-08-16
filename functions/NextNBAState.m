function QBNext=NextNBAState(qBprev,satPrev,B1)
%given observation satPrev, current NBA state qBprev find the set QBNext of NBA
%states that can be reached in one hop

QBNext=[];

for b=1:length(B1.S)
    qBnext=B1.S(b);
if ~isempty(find(sum(satPrev)==B1.trans{qBprev,qBnext}, 1))
    QBNext=[QBNext,qBnext];
end
end
