function List=sucessors(Node,parentLocal)
List=[];
flag=0;
%example: parentLocal=[0;1;1;3;3;2;6;7;7;4;6;5]
while flag==0
   index=find(ismember(parentLocal,Node));%one-step suuccessors of node "Node"
   List=[List index'];
   Node=index;
   if isempty(Node)
       flag=1;
   end
end