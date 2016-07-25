function config = lmReport(config)                  
% lmReport REPORTING of the expLanes experiment lmnn
%    config = lmInitReport(config)                  
%       config : expLanes configuration state       
                                                    
% Copyright: florian                                
% Date: 01-Jun-2016                                 
                                                    
if nargin==0, lmnn('report', 'r'); return; end      
                                                    

config = expExpose(config, 't', 'mask',{[7 8] [11 12 13 14 15 16 17 18 19] [5]}, 'save', 'mtable','label','me');
%send_mail_message('gonantesfr','resby6','by inst',fullfile('report','figures','mtable.pdf'));
