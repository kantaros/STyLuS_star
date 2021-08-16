function loc=myismember(M,x)

n=size(M,2);
loc= find(any(all(bsxfun(@eq,reshape(x.',1,n,[]),M),2),3));
return
%--------
%input
%matrix M: m \times n
%matrix x: e \times n (can be a vector as well)

%output:
%loc: indices of rows of matrix M. M(loc,:)=the rows of x that appear as
%rows in M as well.


% Much faster than ismember
%EXAMPLE
% m = 1000000; % ... number of rows
% n = 20; % ... dimension of vector
% M = randi([1 n],m,n);
%  testloc = 123456;
%  testloc=testloc:testloc+5;
%  testloc(end+1)=1
% x = M(testloc,:); 
% tic;
% [~,loc1] = ismember(x,M,'rows'); 
% toc; 