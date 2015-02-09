function [LL,alph,beta,obs]=forwardBackward(data,pi,T,O)
  nStates = length(O); nTime = size(data,2);
  obs = zeros(nStates,nTime); alph=obs; beta=obs; prob=obs;
  for i=1:nStates
    obs(i,:) = mvnpdf(data',O{i}.mu',O{i}.Sig); % evaluate data for Gaussian i: N(data(:,j) ; O{i}.mu, O{i}.Sig)
  end;
  TT=T';
  alph(:,1) = pi .* obs(:,1); %... initialize alpha recursion, alpha = p(z1)*p(x1|z1)
  tmp=sum(alph(:,1));  % calculate p(x_1) = \sum p(x_1|z_1) p(z_1)
  LL=log(tmp); alph(:,1) = alph(:,1)./tmp;  % and normalize for numerical reasons
  for t=2:nTime        % compute p(zt|x1..xt) and logl = p(X).
    alph(:,t) = (T*alph(:,t-1)) .* obs(:,t); % ... continue alpha recursion
    tmp=sum(alph(:,t));
    LL = LL + log(tmp); alph(:,t) = alph(:,t)./tmp;
  end;
  beta(:,nTime) = ones(size(pi)); %... initialize beta recursion
  for t=nTime-1:-1:1    % compute p(xT...xt+1|zt) 
    beta(:,t) = TT*(beta(:,t+1).*obs(:,t+1)); %... continue beta recursion
    beta(:,t) = beta(:,t)./sum(beta(:,t));  % normalize 
  end;
end
