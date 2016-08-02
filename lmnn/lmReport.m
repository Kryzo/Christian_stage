function config = lmReport(config)                  
% lmReport REPORTING of the expLanes experiment lmnn
%    config = lmInitReport(config)                  
%       config : expLanes configuration state       
                                                    
% Copyright: florian                                
% Date: 01-Jun-2016                                 
                                                    
if nargin==0, lmnn('report', 'r'); return; end      
                                                    

config = expExpose(config, 't', 'mask',{[0] [0] [0]}, 'save', 'mtable','label','you');
 send_mail_message('gonantesfr','0 0 0','by inst',fullfile('report','tables','mtable.tex'));
send_mail_message('gonantesfr','0 0 0','by inst',fullfile('report','figures','mtable.pdf'));