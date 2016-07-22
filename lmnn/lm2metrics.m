function [config, store, obs] = lm2metrics(config, setting, data)
% lm2metrics METRICS step of the expLanes experiment lmnn
%    [config, store, obs] = lm2metrics(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: florian
% Date: 01-Jun-2016

% Set behavior for debug mode
if nargin==0, lmnn('do', 2,'parallel',0,'mask',{[4] [3] 5}); return; else store=[]; obs=[]; end
if(isempty(data))
   
    send_mail_message('gonantesfr','notyet','by inst',fullfile('report','figures','mtable.pdf'));
else

ccall=data.features;
ccall(:,all(~ccall,1))=[];
labelinst=data.labelinst;
labeltype=data.labeltype;
load labelinst2
switch setting.metrics
    case 'raw'
        ccafter=ccall;
%%%%%%%%%%%%%%%%%%%%%%%%%-2-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    case 'standarize'
        ccafter=featureNormalize(ccall);
 %%%%%%%%%%%%%%%%%%%%%%%%%-3-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    case 'stdandmedian'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,13);
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%-4-%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    case 'stdandmedianbigv'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedianbigv(ccall);
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%-5-%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
    case 'lmnninst'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,83);
        end
        [Linst,Det]=lmnnCG(ccafter',labelinst',5,'maxiter',1000);
        ccafter=(Linst*ccafter')';
%%%%%%%%%%%%%%%%%%%%%%%%%%%-6-%%%%%%%%%%%%%%%%%%%%%%%%%%%%  store.Linst=Linst;
        
    case 'lmnnmode'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,83);
        end
        [labeltype2, res]=removelessthan5(labeltype,ccafter);
        [Ltype,Det]=lmnnCG(res',labeltype2',5,'maxiter',1000)
        ccafter=(Ltype*ccafter')';
        store.Ltype=Ltype;
%%%%%%%%%%%%%%%%%%%%%%%%%%%-7-%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    case 'lmnninst16'
        ccafter=ccall;
        load labelinst2
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,83);
        end
        [Linst,Det]=lmnnCG(ccafter',labelinst2',5,'maxiter',1000);
        ccafter=(Linst*ccafter')';
        store.Linst16=Linst;
%%%%%%%%%%%%%%%%%%%%%%%%%%%-8-%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    case 'lmnninst16traintest'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,83);
        end
        X=ccafter';
        [d,n] = size(X);
        P       = randperm(n);
        
        Xtrain  = X(:,P(1:floor(0.8 * n)))';
        Ytrain  = labelinst2(P(1:floor(0.8*n)));
        Xtest   = X(:,P((1+floor(0.8*n)):end))';
        Ytest   = labelinst2(P((1+floor(0.8*n)):end));
        [Linst,Det]=lmnnCG(Xtrain',Ytrain',5,'maxiter',1000);
        ccafter=(Linst*Xtest')';
        store.Linst16traintest=Linst;
        store.xtest50=Xtest;
        store.ytest50=Ytest
        store.xtrain50=Xtrain;
        store.ytrain50=Ytrain
        labelinst2=Ytest;
%%%%%%%%%%%%%%%%%%%%%%%%%%%-9-%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    case 'lmnninst16traintest50'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,83);
        end
        X=ccafter';
        [d,n] = size(X);
        P       = randperm(n);
        
        Xtrain  = X(:,P(1:floor(0.5 * n)))';
        Ytrain  = labelinst2(P(1:floor(0.5*n)));
        Xtest   = X(:,P((1+floor(0.5*n)):end))';
        Ytest   = labelinst2(P((1+floor(0.5*n)):end));
        [Linst,Det]=lmnnCG(Xtrain',Ytrain',5,'maxiter',1000);
        ccafter=(Linst*Xtest')';
        store.Linst16traintest50=Linst;
        store.xtest50=Xtest;
        store.ytest50=Ytest
        store.xtrain50=Xtrain;
        store.ytrain50=Ytrain
        labelinst2=Ytest;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%-10-%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    case 'lmnnserieGT'
        
        ccafter=ccall;
        load groupSol
        labelinstGT=(a.clusters);
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,2);
        end
        ccafter2=ccafter;
        
        for nGT=1:33
            [label2, res]=removelessthan2(labelinstGT(nGT,:),ccafter);
            [Linst,Det]=lmnnCG(ccafter2',label2',5,'maxiter',1000);
            ccafter2=(Linst*ccafter2')';
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%-11-%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    case 'lmnnmappingG'
        
        
        load groupSol
        ccafter=ccall(:,1:(size(ccall,2)-1));
        
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccafter,2);
        end
        ccafter2=ccafter;
        %%%%%%%%%%%%%%%%%%%ù
        cluster=a.clusters;
        b=0;;
        for k=1:78
            
            rep=sum(ccall(:,size(ccall,2))==k);
            for m=1:rep
                b=b+1;
                cluster2(:,b)=cluster(:,k);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        labelinstGT=cluster2([1:27,29:33],:);
        [v,Lmap]=mapping(labelinstGT);
        
        [Linst,Det]=lmnnCG(ccafter2',Lmap',5,'maxiter',1000);
        ccafter2=(Linst*ccafter2')';
%%%%%%%%%%%%%%%%%%%%%%%%%%%-12-%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    case 'lmnnsumGT'
        load groupSol
        
        ccafter=ccall(:,1:(size(ccall,2)-1));
        
        %%%%%%%%%%%%%%%%%%%ù
        cluster=a.clusters;
        b=0;;
        for k=1:78
            
            rep=sum(ccall(:,size(ccall,2))==k);
            for m=1:rep
                b=b+1;
                cluster2(:,b)=cluster(:,k);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        labelinstGT=cluster2([1:27,29:33],:);
        L=zeros(12);
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,2);
            L=zeros((size(ccafter,2)));
        end
        ccafter2=ccafter;
        
        for nGT=1:32
            
            [label2, res]=removelessthan2(labelinstGT(nGT,:),ccafter);
            [Linst,Det]=lmnnCG(res',label2',5,'maxiter',1000);
            
            L=L+Linst;
            
        end
        store.labelLsum.mat=L;
        ccafter2=(L*ccafter2')';
%%%%%%%%%%%%%%%%%%%%%%%%%%%-13-%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    case 'lmnnpsumGT'
        load groupSol
        ccafter=ccall(:,1:(size(ccall,2)-1));
        
        %%%%%%%%%%%%%%%%%%%ù
        cluster=a.clusters;
        b=0;;
        for k=1:78
            
            rep=sum(ccall(:,size(ccall,2))==k);
            for m=1:rep
                b=b+1;
                cluster2(:,b)=cluster(:,k);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        labelinstGT=cluster2([1:27,29:33],:);
        [sucessrate,Labelmap]= mapping(labelinstGT)
        L=zeros(12);
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,2);
            L=zeros((size(ccafter,2)));
        end
        ccafter2=ccafter;
        
        
        for nGT=1:32
            [label2, res]=removelessthan2(labelinstGT(nGT,:),ccafter);
            [Linst,Det]=lmnnCG(res',label2',5,'maxiter',1000);
            
            L=L+(repmat(sucessrate(nGT)/max(sucessrate),length(L),length(L)).*Linst);
            
        end
        store.labelLsum.mat=L;
        ccafter2=(L*ccafter2')';
%%%%%%%%%%%%%%%%%%%%%%%%%%%-14-%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    case 'lmnnsumdis'
        load groupSol
        
        ccafter=ccall(:,1:(size(ccall,2)-1));
        save('ccafter.mat','ccafter')
       
       cluster=a.clusters;
        cluster=cluster([1:27,29:33],:);
        b=0;;
        for k=1:78
            
            rep=sum(ccall(:,size(ccall,2))==k);
            for m=1:rep
                b=b+1;
                cluster2(:,b)=cluster(:,k);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        labelinstGT=cluster2;
        L=zeros(12);
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,2);
            L=zeros((size(ccafter,2)));
        end
        ccafter2=ccafter;
         dx2=zeros(length(ccafter2),length(ccafter2));
        for nGT=1:32
            
            [label2, res]=removelessthan2(labelinstGT(nGT,:),ccafter);
            [Linst,Det]=lmnnCG(res',label2',5,'maxiter',1000);
            ccafter2=(Linst*ccafter')'
            dx2=dx2+squareform(pdist(ccafter2));
        end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%-15-%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    case 'lmnnpsumdis'
        load groupSol
        
        ccafter=ccall(:,1:(size(ccall,2)-1));
        
        %%%%%%%%%%%%%%%%%%%ù
        cluster=a.clusters;
        cluster=cluster([1:27,29:33],:);
        b=0;;
        for k=1:78
            
            rep=sum(ccall(:,size(ccall,2))==k);
            for m=1:rep
                b=b+1;
                cluster2(:,b)=cluster(:,k);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        labelinstGT=cluster2;
      
        L=zeros(12);
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,2);
            L=zeros((size(ccafter,2)));
        end
        ccafter2=ccafter;
           dx2=zeros(length(ccafter2),length(ccafter2));
        for nGT=1:32
            clusv=0;
          
                for kclus2=1:32
                    if(nGT~=kclus2)
                        [accuracyv, classMatching] = accuracy(labelinstGT(nGT,:), labelinstGT(kclus2,:));
                        clusv=clusv+accuracyv;
                    end
                end
            [label2, res]=removelessthan2(labelinstGT(nGT,:),ccafter);
            [Linst,Det]=lmnnCG(res',label2',5,'maxiter',1000);
            ccafter2=(Linst*ccafter')';
            dx2=dx2+repmat(clusv,length(ccafter2),length(ccafter2)).*squareform(pdist(ccafter2));
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%-16-%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    case  'lmnnclassmatching'
        load groupSol
          %%%%%%%%%%%%%%%%%%%ù
        cluster=a.clusters;
        cluster=cluster([1:27,29:33],:);
        b=0;;
        for k=1:78
            
            rep=sum(ccall(:,size(ccall,2))==k);
            for m=1:rep
                b=b+1;
                cluster2(:,b)=cluster(:,k);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        labelinstGT=cluster2;
      
         
        ccafter=ccall(:,1:(size(ccall,2)-1));
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,2);     
        end
        maxv=0;
        kfinal=0;
        for kclus=1:32
            clusv=0;
          
                for kclus2=1:32
                    if(kclus~=kclus2)
                        [accuracyv, classMatching] = accuracy(labelinstGT(kclus,:), labelinstGT(kclus2,:));
                        clusv=clusv+accuracyv;
                    end
                end
            
            if (clusv>maxv)
                kfinal=kclus;
                maxv=clusv;
            end
            
        end
        for kclus=1:32
         [accuracyv, classMatching] = accuracy(labelinstGT(20,:), labelinstGT(kclus,:));
        
         labeltemp=labelinstGT(kclus,:);
         labeltemp2=labelinstGT(kclus,:);
         for kcm=1:size(classMatching,1)
             n=classMatching(kcm,:)
              vcm=find(n);
             if(~isempty(vcm))
                
              labeltemp(labeltemp2==kcm)=vcm;
             end
         end
        labelinstGT2(kclus,:)=labeltemp;
       
        end
         M = mode(labelinstGT2);
         [label2, res]=removelessthan2(M,ccafter);
            [Linst,Det]=lmnnCG(res',label2',5,'maxiter',1000);
            ccafter2=(Linst*ccafter')';
            
   case 'stdandmedian'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall,13);
        end         
            
end

dx=squareform(pdist(ccafter));

switch setting.type
    case 'instrument'
        resinst=rankingMetrics(dx,labelinst);
        obs.map=resinst.meanAveragePrecision*100
        obs.pat5=resinst.precisionAt5*100
    case 'mode'
        resmode=rankingMetrics(dx,labeltype);
        obs.map=resmode.meanAveragePrecision*100
        obs.pat5=resmode.precisionAt5*100
    case 'instrument16'
        resmode=rankingMetrics(dx,labelinst2);
        obs.map=resmode.meanAveragePrecision*100
        obs.pat5=resmode.precisionAt5*100
    case 'instrument162'
        dx2=squareform(pdist(Xtest));
        resmode=rankingMetrics(dx,labelinst2);
        resmode2=rankingMetrics(dx2,labelinst2);
        obs.map=resmode.meanAveragePrecision*100
        obs.pat5=resmode.precisionAt5*100
        obs.map2=resmode2.meanAveragePrecision*100
        obs.pat52=resmode2.precisionAt5*100
    case 'instrument16GT'
        map=0;
        pat5=0;
        map2=0;
        pat52=0;
        if(exist('dx2'))
        else
            dx2=squareform(pdist(ccafter2));
        end
        for nGT=1:32
            resmode=rankingMetrics(dx,labelinstGT(nGT,:));
            resmode2=rankingMetrics(dx2,labelinstGT(nGT,:));
            map=map+resmode.meanAveragePrecision*100;
            pat5=pat5+resmode.precisionAt5*100 ;
            map2=map2+resmode2.meanAveragePrecision*100;
            pat52=pat52+resmode2.precisionAt5*100 ;
        end
        obs.map=map/32
        obs.pat5=pat5/32
        obs.mapafter=map2/32
        obs.pat5after=pat52/32
      
        lmReport;
       lmReport;
end        
        
end
