function ccm= scatteringSave(FileDirectory,Ts)
%------------------------------------------------------------------------------------------------
% Scatteringsave is a function called by SaveAllDataCoeff it calculate
% for each directory containing wave files the scattering coefficients
%This function needs scatnet toolbox and for each wave file one row representing the 
%averaging in time is calculated.
%Ts in seconds
%------------------------------------------------------------------------------------------------
if(nargin==1)
    Ts=0.128;
end


WavFiles = dir(FileDirectory);%load all the wav files in the directory
dirWavFiles={WavFiles.name}';
dirWavFiles = char(dirWavFiles);
nameOfWavFile=strtrim(dirWavFiles(3,:));



ccm=zeros(size(dirWavFiles,1)-2,50000);
for w=3:size(dirWavFiles,1)
    [pathstr,name,ext] = fileparts(nameOfWavFile);
    if(strcmp(ext,'.wav'))
        clear idx;
        nameOfWavFile=strtrim(dirWavFiles(w,:));
        
        
        
        
        %-------------------------------------------------------------------------
        [y3,Fs] = audioread(fullfile(FileDirectory,nameOfWavFile));
        N = length(y3);
        T = Fs*Ts;
        filt_opt = default_filter_options('audio', T);
        filt_opt.Q(1) = 12;
        scat_opt.M = 2;
        scat_opt.oversampling = 4;
        scat_opt.path_margin = 4;
        [Wop3, banks] = wavelet_factory_1d(N, filt_opt, scat_opt);
        S = scat(y3(:,1), Wop3);
        [S,meta]=format_scat(S,'order_table');
        cc=[S{1+1}' S{1+2}'];
%        ccm=ccm(:,1:length(cc));
        cc=nanmean(cc);
        if(isfinite(cc(2)))
            ccm(w-2,1:length(cc))=cc;
        end
        %------------------------------------------------------------------------------------------
    end
end
if(not(isempty(ccm)))
    sep = filesep;
    C = strsplit(FileDirectory,sep);
    LC=length(C);
   % S=fullfile('scat2',C(LC-2),C(LC-1),C(LC))
    %mkdir(S{1});
   % save([S{1} sep strcat('scat',num2str(Ts*1000)) '.mat'], 'ccm');
else
    ccm=0;
end


