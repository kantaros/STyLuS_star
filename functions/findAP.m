%num=15

function ap=findAP(num)
e=1;
ap=[];
while num~=0
    k=1;
    while 2^(k-1)<num
        k=k+1;
    end
    if 2^(k-1)>num
        k=k-1;
    end
    ap(e)=k;
    num=num-2^(k-1);
    e=e+1;
end
    
    