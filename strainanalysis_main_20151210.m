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

%%Get Filenames and the Path of stitched fields(only works if they are in one directory:
workingdir=mfilename('fullpath');
workingdir=fileparts(workingdir);

%% Only run calibration if the variable cal_scale_beam does not exist
if exist('cal_scale_beam','var') == 0
    [cal_scale_beam,x_origin,y_origin]=scale_beam(workingdir);
end

% %% Replaced by next section
% [DICfilen,DICpath]=uigetfile(fullfile(workingdir,'../04_StitchedFields','*.mat'),'Select .mat 04_StitchedFields','MultiSelect','on');
%     if isequal(DICfilen, 0)
%         disp('User selected Cancel')
%         return;
%     end
%     
%     %If only one .mat file is selected uigetfile returns a str.
%     %and in the next for loop there is a reference to a cell array
%     DICfilen = cellstr(DICfilen);
%     
%     for i = 1:length(DICfilen)
%         disp(fullfile(DICpath, DICfilen{i}))
%     end
% %%gui to reduce data in frames
% gui_red = figure('Visible','off','Position',[360,500,450,285]);

%% Choose which Frames to use 
dir_stitchedfields = fullfile(workingdir,'../04_StitchedFields','*.mat');
contents_stitchedfields=dir(dir_stitchedfields);

fieldnames_stitchedfields={contents_stitchedfields(:).name};
 [wframes,wframes_wo_ext,wframes_indices]=wframes_gui(fieldnames_stitchedfields);
chosen_frames=fullfile(workingdir,'../04_StitchedFields/',wframes);
    
% %% Load the frames in to the workspace Replace by next section
% for i= 1:length(DICfilen)
% loadedDIC{i}=load(fullfile(DICpath,DICfilen{i}));
% end

%% Load frames
lenChosenFrames=length(chosen_frames);
%loadedframes=cell(1,lenChosenFrames);
waitb = waitbar(0,'Please wait...');
for i = 1:lenChosenFrames
loadedframes.(wframes_wo_ext{1,i})=load(chosen_frames{1,i});
waitbar(i / lenChosenFrames);
end
close(waitb)
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

%[wframes,wframes_indices]=wframes_gui(DICfilen);
%wfields={'exx','eyy'};
%strgau_center=(ypx,xpx);
%strgau_center=[300,6040];
%radius('r'/'c',width,length);
%radius={'r',20,80};
%result=fieldextraction(loadedDIC,wframes,wframes_filen,wfields,strgau_center,radius);
%result=fieldextraction(loadedframes,wframes_wo_ext,wframes_wo_ext,wfields,strgau_center,radius);
%result=fieldextraction2(loadedframes,wframes_wo_ext,wfields,strgau_center,radius);

%% read xls dms position data
filename='/home/bowkatz/Documents/MATLAB/BachelorThesis/08_DMSPos_xls/DMShor_kor.xls';
[~,sheets]=xlsfinfo(filename);
for i=1:length(sheets)
[num{1,i},txt{1,i},raw{1,i}]=xlsread(filename,sheets{1,i});
end

for i=1:length(raw)
    for j=2:size(raw{1,i},2)
        for k=2:size(raw{1,i},1)
            if j==2
raw_px{1,i}{k,j}=raw{1,i}{k,j}*cal_scale_beam-(165*cal_scale_beam-x_origin);

            else 
raw_px{1,i}{k,j}=abs(y_origin-raw{1,i}{k,j}*cal_scale_beam);
            end
        end
    end
end

%% Evaluation of Data Variant 1 Strauss fixed length of radius (20mm,15mm,10mm)

radius_width=1;
radius_length=[2*cal_scale_beam,1.5*cal_scale_beam,1.0*cal_scale_beam];
strgau_x=raw_px{1,1}{2,2}
strgau_y=raw_px{1,1}{2,3}
strgau_center=[strgau_x,strgau_y];
for i=1:length(radius_length)
radius{1,i}={'r',radius_width,radius_length(1,i)}
%radius={'r',radius_width,107.5056}
res_hor_strauss(i)=fieldextraction2(loadedframes,wframes_wo_ext,{'exx'},strgau_center,radius{1,i})
end

% % corr2(res_hor_strauss)
 plot(res_hor_strauss(3).Beam3Processed_00364_s.exx(1,:))
% plot(  