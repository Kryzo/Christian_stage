function ccf = ScatStdMedian(ccall,per)
%---------------------------------------------------------------
%ScatStdMedian remove the variance bigger than 83% of the maximum of the
%cumulated sum of the variance.
%-------------------------------------------------------------------------
 if(nargin<1)
load ccafter
ccall=ccafter;
load groupSol
 cluster=a.clusters;
 label=cluster(1,:);
 end

NumObs=size(ccall,1);
NumFeat=size(ccall,2);

%calculate variance, and sort the observation matrix by ascending order
var=nanstd(ccall);
var=var/(sum(var));
[vars,I]=sort(var,2,'ascend');
ccall=ccall(:,I); 
x=1:NumFeat;
x=x(:,I);

%calculate the cumlative sum
sumvar=cumsum(vars);


%Uncomment to plot the variance of the sorted observation matrix
%figure(1);
%plot(nanstd(cc2)/sum(nanstd(cc2)))

%Keep 83% of the small valriance 




cc=ccall(:,1:per);%comment and uncomment the following line to keep the big variance
%cc=ccall(:,ix:NumFeat);


%x=(x(1,1:ix));%for plotting




%
eps=1e-3;
medcc=repmat(eps*median(cc,1),NumObs,1);
ccf=log1p(cc./medcc);


 

 
%calculate the mean average precsion and the precisionAt5
%dx=pdist(ccf);
%dx=squareform(dx);
%resav=rankingMetrics(dx,labelinst);

%sr=strcat('resavip@5 = ', num2str(resav.precisionAt5),'resavipMap = ', num2str(resav.meanAveragePrecision))
%xr=zeros(1,NumFeat);
%for(i=1:length(x))
 %   xr(x(i))=1;   
%end
%xr=var.*xr;
%figure(1);
% plot(1:NumFeat,var,1:NumFeat,xr)
% title(sr)
% save(strcat(name4,'varmed'), 'ccf','resav','x');
