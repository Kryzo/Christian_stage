function ccm= mfccSave(FileDirectory)
%------------------------------------------------------------------------------------------------
% mfccSave is a function called by SaveAllDataCoeff it calculate
% for each directory containing wave files the MFCC
%This function needs rastamat toolbox and for each wave file one row representing the 
%averaging in time is calculated
%------------------------------------------------------------------------------------------------



WavFiles = dir(FileDirectory);%load all the wav files in the directory
dirWavFiles={WavFiles.name}';
dirWavFiles = char(dirWavFiles);
nameOfWavFile=strtrim(dirWavFiles(3,:));


ccm=zeros(size(dirWavFiles,1)-2,40);
%amelm=zeros(size(dirWavFiles,1)-2,27);

for w=3:size(dirWavFiles,1)
    [pathstr,name,ext] = fileparts(nameOfWavFile);
    if(strcmp(ext,'.wav'))
        
        clear idx;
        nameOfWavFile=strtrim(dirWavFiles(w,:));
        %---------------------------------------------------------------------------------------------
        %mfcc calculated for T=25ms reffer to melfcc.m for more info.
        
        [a,sr] = audioread(fullfile(FileDirectory,nameOfWavFile));
        [cc,amel,pspectrum] = melfcc(a(:,1), sr);
      %  cc=nanmean(cc,2)';
       amel=nanmean(amel,2)';
       % if(isfinite(cc(2)))
      %     ccm(w-2,:)=cc(:,:);
     %  end
       if(isfinite(amel(2)))
            ccm(w-2,:)=amel(:,:);
        end
     %-------------------------------------------------------------------   
    end
end

if(not(isempty(ccm)))
    sep = filesep;
    C = strsplit(FileDirectory,sep);
    LC=length(C);
   % S=fullfile('mfcc',C(LC-2),C(LC-1),C(LC))
  %  mkdir(S{1});
    %save([S{1} sep 'mfcc25.mat'], 'ccm');
else
    ccm=0;
end
