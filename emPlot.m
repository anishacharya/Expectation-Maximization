function emPlot(x,z,T,O)
  figure(1); axis([-2,2,-2,2]); hold off;   % plot the data in different colors
  colors = 'rgbmc';
  for t=1:size(x,2),
    plot(x(1,t),x(2,t),[colors(z(t)),'.']); 
	  hold on;
  end;
  
  theta = 0:.1:2*pi;                        % plot the current Gaussian models
  pts = 2*[sin(theta);cos(theta)];          % by showing the two-sigma radius
  for k=1:length(O),
    xy = sqrtm(O{k}.Sig)*pts + repmat(O{k}.mu,[1,length(pts)]);
	  plot(xy(1,:),xy(2,:),'k-');
  end;
end
