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

%% Get Filenames and the Path of stitched fields(only works if they are in one directory:
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
%if 0==1
lenChosenFrames=length(chosen_frames);
%loadedframes=cell(1,lenChosenFrames);
waitb = waitbar(0,'Please wait...');
for i = 1:lenChosenFrames
%loadedframes.(wframes_wo_ext{1,i})=load(chosen_frames{1,i});
 loadedframes.(wframes_wo_ext{1,i})=load(chosen_frames{1,i});
waitbar(i / lenChosenFrames);
end
close(waitb)
%end
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
% [xls_filen,xls_path]=uigetfile(fullfile('/home/bowkatz/Documents/MATLAB/BachelorThesis/08_DMSPos_xls','*.xls'),'Select .xls containing DMS info','MultiSelect','on');
% for i=1:length(xls_filen)
%     xls_filename=xls_filen{i};
%     xls_full=fullfile(xls_path,xls_filename)
%     [~,sheets{i},~]=xlsfinfo(xls_full)
%  
%     for j=1:length(sheets{i})
%         %load sheet before if 
%         if strfind(sheets{1,i}{1,j},'TnH')
%         [~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,j});
%         strgau_name_hor{i,j}=cur_sheet_txt{2:end,1}
%         elseif strfind(sheets{1,i}{1,j},'TnV')
%         [~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,j});
%         strgau_name_vert{i,j}=cur_sheet_txt{2:end,1};
%         end
%     end
%     
% end

%[xls_filen,xls_path]=uigetfile(fullfile('/home/bowkatz/Documents/MATLAB/BachelorThesis/08_DMSPos_xls','*.xls'),'Select .xls containing DMS info','MultiSelect','on');
% for i=1:length(xls_filen)
%     xls_filename=xls_filen{i};
%     xls_full=fullfile(xls_path,xls_filename)
%     [~,sheets{i},~]=xlsfinfo(xls_full)
%  
%     for j=1:length(sheets{i})
%          [~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,j});
%             for k=1:size(cur_sheet_txt,2)
%                 if strfind(sheets{1,i}{1,j},'TnH')
%                     [~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,j});
%                     strgau_name_hor{1,k}=cur_sheet_txt{k,1}
%                 elseif strfind(sheets{1,i}{1,j},'TnV')
%                     [~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,j});
%                     strgau_name_vert{1,k}=cur_sheet_txt{k,1};
%                 end
%             end
%     end
% end

% 
% for i=1:length(xls_filen)
%     xls_filename=xls_filen{i};
%     xls_full=fullfile(xls_path,xls_filename)
%     [~,sheets{i},~]=xlsfinfo(xls_full)
%     count_strgau=0;
%     for l=1:length(sheets{i})
%     [~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,l});
%     count_strgau=count_strgau+size(cur_sheet_txt,1)-1
%     end
%     for j=1:length(sheets{i})
%          [~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,j});
%             for k=2:count_strgau+1
%                 if strfind(sheets{1,i}{1,j},'TnH')
%                     %[~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,k});
%                     strgau_name_hor{1,k}=cur_sheet_txt{,1}
%                 elseif strfind(sheets{1,i}{1,j},'TnV')
%                     [~,cur_sheet_txt,~]=xlsread(xls_full,sheets{i}{1,k});
%                     strgau_name_vert{1,k}=cur_sheet_txt{k,1};
%                 end
%             end
%     end
% end

%% Evaluation of hor and vert straingauges 
% read xls dms position data
if exist('xls_filen','var') == 0 && exist('xls_path','var') == 0
[xls_filen,xls_path]=uigetfile(fullfile('/home/bowkatz/Documents/MATLAB/BachelorThesis/08_DMSPos_xls','*.xls'),'Select .xls containing DMS info','MultiSelect','on');
end
%how many xls files:
count_xls=length(xls_filen);

%how many sheets per xls:
for i=1:count_xls
    xls_filename=xls_filen{i};
    xls_full=fullfile(xls_path,xls_filename);
    [~,sheets{i},~]=xlsfinfo(xls_full);
    count_sheets(i)=length(sheets{i});

    %how many dms per sheet
    count_strgau_comp(i)=0;
    
    for j=1:count_sheets(i)
        
        count_strgau_sheet(i,j)=0;
        cur_sheet_name=sheets{1,i}{1,j};
        %cur_sheet_name=sheets{1,j}{1,count_dms_per_sheet}
        [~,cur_sheet_txt,~]=xlsread(xls_full,cur_sheet_name);
        count_strgau_comp(i)=count_strgau_comp(i)+size(cur_sheet_txt,1)-1
        count_strgau_sheet(i,j)=count_strgau_sheet(i,j)+size(cur_sheet_txt,1)-1
    end

end

for i=1:count_xls
    xls_filename=xls_filen{i};
    xls_full=fullfile(xls_path,xls_filename);
    [~,sheets{i},~]=xlsfinfo(xls_full);
    count_sheets(i)=length(sheets{i});
    k=0;
    for j=1:count_sheets(i)
        cur_sheet_name=sheets{1,i}{1,j}
        
            %for k=1:count_strgau_comp(i)
                for l=1:count_strgau_sheet(i,j)
             k=k+1;   
            if strfind(cur_sheet_name,'TnH')
                [~,cur_sheet_txt,~]=xlsread(xls_full,cur_sheet_name);
                strgau_name_hor{1,k}=cur_sheet_txt{l+1,1}
        
            elseif strfind(cur_sheet_name,'TnV')
                [~,cur_sheet_txt,~]=xlsread(xls_full,cur_sheet_name);
                strgau_name_vert{1,k}=cur_sheet_txt{l+1,1}
                
            else
                disp('Horizontal or Vertical Straingauge not found');
            end
                end
            %break
           %end
            
    end
    
end


% for i=1:count_xls
%     xls_filename=xls_filen{i};
%     xls_full=fullfile(xls_path,xls_filename);
%     [~,sheets{i},~]=xlsfinfo(xls_full);
%     count_sheets(i)=length(sheets{i});
%     
%     for j=1:count_sheets(i)
%         cur_sheet_name=sheets{1,i}{1,j}
%             for k=1:count_strgau_comp(i)
%                 
%             if strfind(cur_sheet_name,'TnH')
%                 [~,cur_sheet_txt,~]=xlsread(xls_full,cur_sheet_name);
%                 strgau_name_hor{i,j}=cur_sheet_txt{count_strgau_sheet(i,j)+1,1}
%         
%             elseif strfind(cur_sheet_name,'TnV')
%                 [~,cur_sheet_txt,~]=xlsread(xls_full,cur_sheet_name);
%                 strgau_name_vert{i,j}=cur_sheet_txt{count_strgau_sheet(i,j)+1,1}
%                 
%             else
%                 disp('Horizontal or Vertical Straingauge not found');
%             end
%                 
%             break 
%             end
%     end
%     
% end


%%
% for i=1:length(xls_filen)
%    
% end

% for i=1:length(sheets)
%     if strfind(sheets{i},'TnV')==1
%         strgau_align=
%     elseif strfind(sheets{i},'TnH')==1
%         
%     else
%         disp('komm oida fick dich welche daten schiebst ma rein!?');
%     end
% end

%% coordinates in xls files converted from absolute cad-plan to dic panorama picture

%filename='/home/bowkatz/Documents/MATLAB/BachelorThesis/08_DMSPos_xls/DMShor_kor.xls';

for i=1:count_xls
filename=xls_filen{i};
xls_full=fullfile(xls_path,filename);
[~,sheets{i},~]=xlsfinfo(xls_full);
[~,xls_filen_wo_ext,~]=fileparts(xls_full);
for j=1:length(sheets{i})
[num{1,j},txt{1,j},raw{1,j}]=xlsread(xls_full,sheets{1,i}{1,j});
end

for k=1:length(raw)
    for l=2:size(raw{1,k},2)
        for m=2:size(raw{1,k},1)
            if l==2
raw_px.(xls_filen_wo_ext){1,k}{m,l}=raw{1,k}{m,l}*cal_scale_beam-(165*cal_scale_beam-x_origin);

            else 
raw_px.(xls_filen_wo_ext){1,k}{m,l}=abs(y_origin-raw{1,k}{m,l}*cal_scale_beam);
            end
        end
    end
end
clearvars raw txt num
end
%% Evaluation of Data Variant 1 Strauss fixed length of radius (20mm,15mm,10mm)

% radius_width=1;
% radius_length=[2*cal_scale_beam,1.5*cal_scale_beam,1.0*cal_scale_beam];
% strgau_x=raw_px{1,1}{2,2}
% strgau_y=raw_px{1,1}{2,3}
% strgau_center=[strgau_x,strgau_y];
% for i=1:length(radius_length)
% radius{1,i}={'r',radius_width,radius_length(1,i)}
% %radius={'r',radius_width,107.5056}
% res_hor_strauss(i)=fieldextraction2(loadedframes,wframes_wo_ext,{'exx'},strgau_center,radius{1,i})
% end

%% get results of strauss purposed method (fixed radii of 10mm 15mm 20mm)

radius_width=1;
radius_length=[2*cal_scale_beam,1.5*cal_scale_beam,1.0*cal_scale_beam];
radius_name={'r20','r15','r10'};
count_radii=length(radius_length);
for i=1:length(xls_filen)
    [~,filename,~]=fileparts(xls_filen{i});
    m=1;
    for j=1:count_sheets(i)
        for k=2:count_strgau_sheet(i,j)+1
            strgau_x.(filename)(k,j)=raw_px.(filename){1,j}{k,2}
            strgau_y.(filename)(k,j)=raw_px.(filename){1,j}{k,3}
            
               % for l=1:count_radii
                    if strfind(filename,'hor') >=1
                            for l=1:count_radii
                                cur_strgau_x=raw_px.(filename){1,j}{k,2};
                                cur_strgau_y=raw_px.(filename){1,j}{k,3};
                                radius{1,l}={'r',radius_width,radius_length(1,l)}
                                strgau_center=[cur_strgau_x,cur_strgau_y];
                                %m=m+1;
                                res_hor_strauss.(wframes_wo_ext{1}).(strgau_name_hor{1,m}).(radius_name{l})=fieldextraction2(loadedframes,wframes_wo_ext,{'exx'},strgau_center,radius{1,l});
                            end
                            m=m+1;
                    elseif strfind(filename,'vert') >=1
                            for n=1:count_radii
                                cur_strgau_x=raw_px.(filename){1,j}{k,2};
                                cur_strgau_y=raw_px.(filename){1,j}{k,3};
                                radius{1,n}={'r',radius_length(1,n),radius_width}
                                strgau_center=[cur_strgau_x,cur_strgau_y];
                                %m=m+1;
                                res_vert_strauss.(wframes_wo_ext{1}).(strgau_name_vert{1,m}).(radius_name{n})=fieldextraction2(loadedframes,wframes_wo_ext,{'eyy'},strgau_center,radius{1,n});
                            end
                            m=m+1;
                    else
                        disp('Neither vert nor hor String found');
                    end
               % end
        end
    end

end

%% save results as .mat file
mat_filen=fullfile(workingdir,'../09_results/',wframes);
save(mat_filen{1},'res_hor_strauss','res_vert_strauss');
% varnames = {'workingdir','chosen_frames','wframes_wo_ext','wframes','cal_scale_beam','cal_scale_beam','y_origin','x_origin','xls_filen','xls_path'};
% clearvars('-except',varnames{:});
%end
% % corr2(res_hor_strauss)
% hold on
% figure
% ax=subplot(1,1,1)
% x=(1:1:size(res_hor_strauss(1).Beam3Processed_00000_s.exx(1,:),2));
% plot(ax,x,res_hor_strauss(1).Beam3Processed_00000_s.exx(1,:),x,res_hor_strauss(1).Beam3Processed_00000_s.exx(2,:))
%  lsline


% %ax=subplot(1,1,1)
% x=(1:1:size(res_hor_strauss(2).Beam3Processed_00364_s.exx(1,:),2));
% scatter(ax,x,res_hor_strauss(2).Beam3Processed_00364_s.exx(1,:))
%  lsline
% 
% %ax=subplot(1,1,1)
% x=(1:1:size(res_hor_strauss(3).Beam3Processed_00364_s.exx(1,:),2));
% scatter(ax,x,res_hor_strauss(3).Beam3Processed_00364_s.exx(1,:))
% lsline

% plot(  



%  varnames = {'cal_scale_beam','cal_scale_beam','y_origin','x_origin', 'res_hor_strauss'};
%  clearvars('-except',varnames{:});

%  %% plot exx on TnD2 
% [data_filen,data_path]=uigetfile(fullfile('/home/bowkatz/Documents/MATLAB/BachelorThesis/09_results','*.mat'),'Select .mat for results','MultiSelect','on');
% [beam_filen,beam_path]=uigetfile(fullfile('/home/bowkatz/Documents/MATLAB/BachelorThesis/04_StitchedFields','*.mat'),'Select .mat for results','MultiSelect','on');
% for i=1:length(data_filen)
%       %without .mat    
%       [~,data_filen_wo_ext{1,i},~]=fileparts(data_filen{1,i});
%       [~,beam_filen_wo_ext{1,i},~]=fileparts(beam_filen{1,i});
%       
% end
%  for t=1:length(data_filen)
%     fileName=data_filen_wo_ext{t}
%     fieldName=beam_filen_wo_ext{t}
%     resultStruct.(fileName) = load(['/home/bowkatz/Documents/MATLAB/BachelorThesis/09_results/' data_filen{t}])
%     
%     hold on
%     %ax1=subplot(2,1,1)
%     %ax2=subplot(2,1,2)
%     %if le(t,8) == 1
%     %m = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
%     %set(gca(), 'LineStyleOrder',m, 'ColorOrder',[0 0 0])
%     plot(resultStruct.(fileName).res_hor_strauss(1).(fieldName).exx(1,:))
%     
%     %else
%        % plot(ax2,resultStruct.(fileName).res_hor_strauss(1).(fieldName).exx(1,:))
%     %end
%  end
%   hold off  
%  
%      legend(data_filen_wo_ext)
% for t=1:length(data_filen);
%     figure
%     fileName=data_filen_wo_ext{t};
%     fieldName=beam_filen_wo_ext{t};
% plot(resultStruct.(fileName).res_hor_strauss(1).(fieldName).exx(1,:))
% ylim([-2.5*10^(-3) 0.5*10^(-3)])
% title(fileName)
% t
% end

%% evaluating xls file 

