%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                     .--,                      
%     .-''-,--.                                   .--,-``-.          :   /\                     
%   .`     \   \      ,---,.            ,---,.   /   /     '.       /   ,  \           ,----,   
%  ;        \.. \   ,'  .' |          ,'  .'  \ / ../        ;     /   /    \        .'   .' \  
% `    -'.  /'' / ,---.'   |        ,---.' .' | \ ``\  .`-    '   ;   /  ,   \     ,----,'    | 
% :   /   \/___/  |   |   .'        |   |  |: |  \___\/   \   :  /   /  / \   \    |    :  .  ; 
% |   :   /       :   :  :          :   :  :  /       \   :   | /   ;  /\  \   \   ;    |.'  /  
% ;   |  |        :   |  |-,        :   |    ;         |  |   ; \"""\ /  \  \ ;    `----'/  ;   
% .   '  .        |   :  ;/|        |   :     \        .  `   .  `---`    `--`       /  ;  /    
% |   :   \ ___   |   |   .'        |   |   . |   ___ /   :   |                     ;  /  /-,   
% :   \   /\   \  '   :  '          '   :  '; |  /   /\   /   :                    /  /  /.`|   
% .    -,`  \,, \ |   |  |    ___   |   |  | ;  / ,,/  ',-    .                  ./__;      :   
%  ;        /`` / |   :  \   /  .\  |   :   /   \ ''\        ;                   |   :    .'    
%   `.     /   /  |   | ,'   \  ; | |   | ,'     \   \     .'                    ;   | .'       
%     `-,,-'--'   `----'      `--"  `----'        `--`-,,-'                      `---'          
% Florian Brugnara & Felix Bugl 2015-12-10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get Filenames and the Path of stitched fields(only works if they are in one directory:
workingdir=mfilename('fullpath');
workingdir=fileparts(workingdir);
[beam_scale_filen,beam_scale_path]=uigetfile(fullfile(workingdir,'../01_rawData','*.tif'),'Select .tif 01_rawData','MultiSelect','off');
scale_beam(fullfile(beam_scale_path,beam_scale_filen),45)
% workingdir=mfilename('fullpath');
% workingdir=fileparts(workingdir);
[DICfilen,DICpath]=uigetfile(fullfile(workingdir,'../04_StitchedFields','*.mat'),'Select .mat 04_StitchedFields','MultiSelect','on');
    if isequal(DICfilen, 0)
        disp('User selected Cancel')
        return;
    end
    
    %If only one .mat file is selected uigetfile returns a str.
    %and in the next for loop there is a reference to a cell array
    DICfilen = cellstr(DICfilen);
    
    for i = 1:length(DICfilen)
        disp(fullfile(DICpath, DICfilen{i}))
    end
%%gui to reduce data in frames
gui_red = figure('Visible','off','Position',[360,500,450,285]);


    
%% Load the frames in to the workspace
for i= 1:length(DICfilen)
loadedDIC{i}=load(fullfile(DICpath,DICfilen{i}));
end


%% Default values for fieldextraction
% which frames = first loaded frame
% which fields = e_xx & e_yy
%strain gauge center strgau_center=(ypx,xpx)
% radius = rectangle , length = 100px width =50px

% %wframes[1,3,4]  
%  wframes=[1,2];
%     for i=1:length(wframes)
%        [~,wframes_filen{1,i},~]=fileparts(DICfilen{1,wframes(i)})
%    end

[wframes,wframes_indices]=wframes_gui(DICfilen)
wfields={'exx','eyy'};
%strgau_center=(ypx,xpx);
strgau_center=[300,6040];
%radius('r'/'c',width,length);
radius={'r',20,80};
%result=fieldextraction(loadedDIC,wframes,wframes_filen,wfields,strgau_center,radius);
result=fieldextraction(loadedDIC,wframes_indices,wframes,wfields,strgau_center,radius);