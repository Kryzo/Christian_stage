
lmnn('do', 2,'parallel',1,'mask',{[7 8] [18 19] [5]});
lmnn('do', 2,'parallel',1,'mask',{[8] [15] [5]});
 lmReport;
 send_mail_message('gonantesfr','resby6','by inst',fullfile('report','tables','mtable.tex'));