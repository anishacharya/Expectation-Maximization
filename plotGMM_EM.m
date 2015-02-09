function plotGMM_EM(X,Qz,O)
% plot Gaussian mixture modeld defined by data X, membership prob Qz, and parameters O
[nil Z] = max(Qz,[],2);
% get "hard" assigments for plotting
cmap=jet(256); vals=unique(Z)';
for c=vals,
% for each Gaussian mixutre component
col= fix((c-min(vals))/(max(vals)-min(vals))*255+1);
% plot the data assigned to that component in color
idx = find(Z==c);
plot(X(idx,1),X(idx,2),'o','markersize',7,'color',cmap(col,:),'markerfacecolor',cmap(col,:));
% plot Gaussian ellipse shape for this component
hold on; theta = [0:.01:2*pi]'; circle = [sin(theta),cos(theta)];
ell = circle * sqrtm(O{c}.Sig) + repmat(O{c}.mu,[length(theta),1]);
plot( O{c}.mu(1),O{c}.mu(2),'x',ell(:,1),ell(:,2),'','color',cmap(col,:),'linewidth',3);
end;
