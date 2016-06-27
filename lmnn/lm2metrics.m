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
if nargin==0, lmnn('do', 2,'parallel',0); return; else store=[]; obs=[]; end
ccall=data.features;
ccall(:,all(~ccall,1))=[];
labelinst=data.labelinst;
labeltype=data.labeltype;
load labelinst2
switch setting.metrics
    case 'raw'
        ccafter=ccall;
    case 'standarize'
        ccafter=featureNormalize(ccall);
    case 'stdandmedian'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            1
            ccafter=StdAndMedian(ccall);
        end
    case 'stdandmedianbigv'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            1
            ccafter=StdAndMedianbigv(ccall);
        end
    case 'lmnninst'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall);
        end
        [Linst,Det]=lmnnCG(ccafter',labelinst',5,'maxiter',1000);
        ccafter=(Linst*ccafter')';
        store.Linst=Linst;
    case 'lmnnmode'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall);
        end
        [labeltype2, res]=removelessthan5(labeltype,ccafter);
        [Ltype,Det]=lmnnCG(res',labeltype2',5,'maxiter',1000)
        ccafter=(Ltype*ccafter')';
        store.Ltype=Ltype;
    case 'lmnninst16'
        ccafter=ccall;
        load labelinst2
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall);
        end
        [Linst,Det]=lmnnCG(ccafter',labelinst2',5,'maxiter',1000);
        ccafter=(Linst*ccafter')';
        store.Linst16=Linst;
    case 'lmnninst16traintest'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall);
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
    case 'lmnninst16traintest50'
        ccafter=ccall;
        if strcmp(setting.features(1:4),'scat')
            ccafter=StdAndMedian(ccall);
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
        
        
end
dx=squareform(pdist(ccafter));
dx2=squareform(pdist(Xtest));
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
        resmode=rankingMetrics(dx,labelinst2);
        resmode2=rankingMetrics(dx2,labelinst2);
        obs.map=resmode.meanAveragePrecision*100
        obs.pat5=resmode.precisionAt5*100
        obs.map2=resmode2.meanAveragePrecision*100
        obs.pat52=resmode2.precisionAt5*100
end
