function [config, store] = lmInit(config)                          
% lmInit INITIALIZATION of the expLanes experiment lmnn            
%    [config, store] = lmInit(config)                              
%      - config : expLanes configuration state                     
%      -- store  : processing data to be saved for the other steps 
                                                                   
% Copyright: florian                                               
% Date: 01-Jun-2016                                                
                                                                   
if nargin==0, lmnn(); return; else store=[];  end                  
