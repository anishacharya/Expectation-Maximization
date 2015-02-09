 rand('state',0); randn('state',0);
 K = 5; 
 Ttrue = [
     0.5757    0.0248    0.0208    0.0003    0.3153
     0.0187    0.3267    0.3863    0.0001    0.5612
     0.0390    0.1143    0.3810    0.1040    0.0067  
     0.1056    0.0946    0.0490    0.5666    0.0000
     0.2610    0.4396    0.1629    0.3290    0.1168
     ];
 pi = ones(K,1)/K;
 
 Otrue{1}.mu = [ 1  1]'; Otrue{1}.Sig=[.25   0 ;   0 .25];
 Otrue{2}.mu = [-1  1]'; Otrue{2}.Sig=[.25  .15 ;  .15 .25];
 Otrue{3}.mu = [ 1 -1]'; Otrue{3}.Sig=[.25 -.18 ; -.18 .25];
 Otrue{4}.mu = [ 0  0]'; Otrue{4}.Sig=[.07    0 ;   0 .07];
 Otrue{5}.mu = [-1 -1]'; Otrue{5}.Sig=[.25   -.1 ;   -.1 .25];
 
 % Simulate hidden states:
 N=1000; D=2;
 z=zeros(1,N); x=zeros(D,N);
 z(1) = find( cumsum(pi)>rand , 1,'first');
 
 for t=2:N,
   z(t) = find( cumsum(Ttrue(:,z(t-1))) > rand, 1,'first');
 end;
 
 for t=1:N,
   x(:,t) = Otrue{z(t)}.mu + sqrtm( Otrue{z(t)}.Sig )*randn(2,1);
 end;
 
 % If you want to visualize the data set, you can use:
 %
 %figure(3); axis([-2,2,-2,2]); hold on;
 %colors = 'rgbmc';
 %for t=1:N,
 %  plot(x(1,t),x(2,t),[colors(z(t)),'.']); %pause(.25);
 %end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 T = rand(K,K); T=T./repmat(sum(T,1),[K,1]);
 O = Otrue;
 for k=1:K, O{k}.mu=randn(2,1); O{k}.Sig=2*eye(2); end;
 nIter=50; LL=zeros(1,nIter);
 for iter=1:nIter,
   [pi,T,O,LL(iter)] = EMstep(x,pi,T,O);
   emPlot(x,z,T,O);
   figure(2); plot(1:iter,LL(1:iter)); ax=axis; ax(2)=nIter; axis(ax);
 end;
pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 T = rand(K,K); T=T./repmat(sum(T,1),[K,1]);
 for k=1:K, O{k}.mu=Otrue{k}.mu+.25*randn(D,1); O{k}.Sig=.25*eye(2); end;
 nIter=50; LL=zeros(1,nIter);
 for iter=1:nIter,
   [pi,T,O,LL(iter)] = EMstep(x,pi,T,O);
   emPlot(x,z,T,O);
   figure(2); plot(1:iter,LL(1:iter)); ax=axis; ax(2)=nIter; axis(ax);
 end;
 
