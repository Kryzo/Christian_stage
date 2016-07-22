function [config, store, obs] = lm1features(config, setting, data)
% lm1features FEATURES step of the expLanes experiment lmnn
%    [config, store, obs] = lm1features(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: florian
% Date: 01-Jun-2016

% Set behavior for debug mode
if nargin==0, lmnn('do', 1,'parallel',1,'mask',{[2 3 4] 0 0}); return; else store=[]; obs=[]; end

switch setting.features
    
    case 'mfcc'
        [ccall,labelinst,labeltype]=SaveAllDattaCoeffplusload('/home/florian/SOL_0.9_HQ','mfcc');
        send_mail_message('gonantesfr','done mfcc','done mfcc','/report/figures/mtable.pdf');
    case 'scattering25'
        [ccall,labelinst,labeltype]=SaveAllDattaCoeffplusload('/home/florian/SOL_0.9_HQ','scat',0.025);
                send_mail_message('gonantesfr','done scat25','done mfcc','/report/figures/mtable.pdf');

    case 'scatterding128'
        [ccall,labelinst,labeltype]=SaveAllDattaCoeffplusload('/home/florian/SOL_0.9_HQ','scat',0.128);
                send_mail_message('gonantesfr','done scat128','done mfcc','/report/figures/mtable.pdf');

    case 'scattering250'
        [ccall,labelinst,labeltype]=SaveAllDattaCoeffplusload('/home/florian/SOL_0.9_HQ','scat',0.25);
                send_mail_message('gonantesfr','done scat250','done mfcc','/report/figures/mtable.pdf');
    case 'mfccGT'
    case 'scatteringGT' 
    case 'mfccGTmult' 
    case 'scatteringGTmult'
end
store.features=ccall;
store.labelinst=labelinst;
store.labeltype=labeltype;

