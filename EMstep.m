function [pi,T,O,LL]=EMstep(data,pi,T,O)
  D=size(data,1); N=size(data,2); K=length(O);
  [LL,alpha,beta,obs] = forwardBackward(data,pi,T,O); LL,

  % Compute the marginal probabilities
  Ez = zeros(K,N); Ez2 = zeros(K,K,N);
  for t=1:N,
    Ez(:,t) = alpha(:,t) .* beta(:,t);
    Ez(:,t) = Ez(:,t)./sum(Ez(:,t));  % normalize
  end;
  % and pairwise probabilities
  for t=2:N,
    Ez2(:,:,t) = T .* ((obs(:,t).*beta(:,t))*alpha(:,t-1)');% ... fill in pairwise probabilities (see slide)
    Ez2(:,:,t) = Ez2(:,:,t)./sum(sum(Ez2(:,:,t)));  % normalize
  end;

  % Maximize ECLL over parameters  
  for k=1:K,
    nK = sum(Ez(k,:));
		%tmp = ones(D,1)*Ez(k,:);
    O{k}.mu = sum( (ones(D,1)*Ez(k,:)) .* data ,2)/nK; % ...
		dtmp = data - repmat(O{k}.mu,[1,N]);
		O{k}.Sig = ((ones(D,1)*Ez(k,:)/nK).*dtmp)*dtmp';
    %O{k}.Sig = ((ones(D,1)*Ez(k,:)) .* data)*data'/nK; % ...
  end;
  T = sum(Ez2,3);  % ...
  T = T./repmat(sum(T,1),[K,1]);  % ...
end
