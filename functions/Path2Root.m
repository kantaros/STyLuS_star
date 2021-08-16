function [pathPTS,pathPBA, seqOfSamples]=Path2Root(IndexNode, parent,Qpba)
%Root has index 1 in Qpba and represent the initial configuration of robots
%in the workspace
seqOfSamples=IndexNode;
N=size(Qpba,2)-1;
path=[];
path=IndexNode;
index=IndexNode;
if parent(index)~=0
    while parent(index)~=1
        path=[path parent(index)];
        index=parent(index);
        seqOfSamples=[index,seqOfSamples];
    end
end
seqOfSamples=[1 seqOfSamples]';
path=[path 1];
pathPTS=[];
pathPBA=[];
for p=length(path):-1:1
    pathPTS=[pathPTS;Qpba(path(p),1:N)];
    pathPBA=[pathPBA;Qpba(path(p),:)];
end
