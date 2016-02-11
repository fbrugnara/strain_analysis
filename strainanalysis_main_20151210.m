 if 0==1
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

%% Initial values 
cal_scale_beam=53.6311;
cal_x_origin=3133;
cal_y_origin=172;
cal_height_beam=45;

%% Get Filenames and the Path of stitched fields(only works if they are in one directory:
%Path inclusive filename of running script
workingdir=mfilename('fullpath');
%just the path to the running script
workingdir=fileparts(workingdir);


%% Only run calibration if the variable cal_scale_beam does not exist
if exist('cal_scale_beam','var') == 0 || exist('cal_y_origin','var') == 0 || exist('cal_x_origin','var') == 0
    [cal_scale_beam,cal_x_origin,cal_y_origin,cal_height_beam]=scale_beam(workingdir);
end


%% Choose which Frames to use 
% create path to StitchedFields 
dir_stitchedfields = fullfile(workingdir,'../04_StitchedFields','*.mat');
% get contents of path
contents_stitchedfields=dir(dir_stitchedfields);
if exist('res_hor_strauss','var') == 0 || exist('res_vert_strauss','var') == 0 || exist('res_hor_castillo','var') == 0 || exist('res_vert_castillo','var') == 0
% get names of contents
fieldnames_stitchedfields={contents_stitchedfields(:).name};
%run gui to select frames
[wframes,wframes_wo_ext,wframes_indices]=wframes_gui(fieldnames_stitchedfields);
%store path and filenames with extension of chosen frames in a variable
chosen_frames=fullfile(workingdir,'../04_StitchedFields/',wframes);
    

%% Evaluation of hor and vert straingauges 
% read xls dms position data
% if path and filename of dms postion xls does not exist get it via gui
if exist('xls_filen','var') == 0 || exist('xls_path','var') == 0
[xls_filen,xls_path]=uigetfile(fullfile(workingdir,'../08_DMSPos_xls','*.xls'),'Select .xls containing DMS Position info','MultiSelect','on');
end
%how many xls files:
count_xls=length(xls_filen);

%how many sheets per xls:
for counter1_xls=1:count_xls
    xls_filename=xls_filen{counter1_xls};
    xls_full=fullfile(xls_path,xls_filename);
    [~,sheets{counter1_xls},~]=xlsfinfo(xls_full);
    count_sheets(counter1_xls)=length(sheets{counter1_xls});

    %how many dms per sheet
    count_strgau_comp(counter1_xls)=0;
    
    for counter1_sheets=1:count_sheets(counter1_xls)
        
        count_strgau_sheet(counter1_xls,counter1_sheets)=0;
        cur_sheet_name=sheets{1,counter1_xls}{1,counter1_sheets};
        [~,cur_sheet_txt,~]=xlsread(xls_full,cur_sheet_name);
        count_strgau_comp(counter1_xls)=count_strgau_comp(counter1_xls)+size(cur_sheet_txt,1)-1;
        count_strgau_sheet(counter1_xls,counter1_sheets)=count_strgau_sheet(counter1_xls,counter1_sheets)+size(cur_sheet_txt,1)-1;
    end

end
%% Save Hor and Vert Straingauge names in strgau_name_hor/vert
for counter2_xls=1:count_xls
    xls_filename=xls_filen{counter2_xls};
    xls_full=fullfile(xls_path,xls_filename);
    [~,sheets{counter2_xls},~]=xlsfinfo(xls_full);
    count_sheets(counter2_xls)=length(sheets{counter2_xls});
    counter1_strgau_name=0;
    for counter2_sheets=1:count_sheets(counter2_xls)
        cur_sheet_name=sheets{1,counter2_xls}{1,counter2_sheets};
        
            %for k=1:count_strgau_comp(i)
                for counter1_strgau_sheet=1:count_strgau_sheet(counter2_xls,counter2_sheets)
             counter1_strgau_name=counter1_strgau_name+1;   
            if strfind(cur_sheet_name,'TnH')
                [~,cur_sheet_txt,~]=xlsread(xls_full,cur_sheet_name);
                strgau_name_hor{1,counter1_strgau_name}=cur_sheet_txt{counter1_strgau_sheet+1,1};
        
            elseif strfind(cur_sheet_name,'TnV')
                [~,cur_sheet_txt,~]=xlsread(xls_full,cur_sheet_name);
                strgau_name_vert{1,counter1_strgau_name}=cur_sheet_txt{counter1_strgau_sheet+1,1};
                
            else
                disp('Horizontal or Vertical Straingauge not found');
            end
                end
            %break
           %end
            
    end
    
end

%% coordinates in xls files converted from absolute cad-plan to dic panorama picture

for counter3_xls=1:count_xls
filename=xls_filen{counter3_xls};
xls_full=fullfile(xls_path,filename);
[~,sheets{counter3_xls},~]=xlsfinfo(xls_full);
[~,xls_filen_wo_ext,~]=fileparts(xls_full);
for counter2_sheets=1:length(sheets{counter3_xls})
[num{1,counter2_sheets},txt{1,counter2_sheets},raw{1,counter2_sheets}]=xlsread(xls_full,sheets{1,counter3_xls}{1,counter2_sheets});
end

for counter3_sheets=1:length(raw)
    for counter2_strgau_sheet=2:size(raw{1,counter3_sheets},2)
        for counter1_columns=2:size(raw{1,counter3_sheets},1)
            if counter2_strgau_sheet==2
raw_px.(xls_filen_wo_ext){1,counter3_sheets}{counter1_columns,counter2_strgau_sheet}=raw{1,counter3_sheets}{counter1_columns,counter2_strgau_sheet}*cal_scale_beam-(165*cal_scale_beam-cal_x_origin);

            else 
raw_px.(xls_filen_wo_ext){1,counter3_sheets}{counter1_columns,counter2_strgau_sheet}=abs(cal_y_origin-raw{1,counter3_sheets}{counter1_columns,counter2_strgau_sheet}*cal_scale_beam);
            end
        end
    end
end
clearvars raw txt num
end

%% Get DMS-Data  

% read xls dms position data
if exist('dms_filen','var') == 0 || exist('dms_path','var') == 0
[dms_xls_filen,dms_xls_path]=uigetfile(fullfile(workingdir,'../07_DMSDATA','*.xlsx'),'Select .xlsx containing DMS Data','MultiSelect','off');
end
dms_xls_full=fullfile(dms_xls_path,dms_xls_filen);
[num_dms_data,~,raw_dms_data]=xlsread(dms_xls_full,'Measurement - strain monitors');
[num_dms_data_atena,~,raw_dms_data_atena]=xlsread(dms_xls_full,'DMS_VERGLEICH');
[highest_load_dms,row_highest_load_dms]=max(num_dms_data(:,1));

% Converting Units
num_dms_data_converted=num_dms_data./1000000;
num_dms_data_atena_converted=num_dms_data_atena./1000000;
%% Load frames
lenChosenFrames=length(chosen_frames);
tic
for counter1_chosenframes = 1:lenChosenFrames
loadedframes.(wframes_wo_ext{1,counter1_chosenframes})=load(chosen_frames{1,counter1_chosenframes});
cur_frame=wframes_wo_ext(counter1_chosenframes);


%% get results of strauss purposed method (fixed radii of 10mm 15mm 20mm)

radius_width=1;
radius_length=[2*cal_scale_beam,1.5*cal_scale_beam,1.0*cal_scale_beam];
radius_name={'r20','r15','r10'};
count_radii=length(radius_length);
for counter4_xls=1:length(xls_filen)
    [~,filename,~]=fileparts(xls_filen{counter4_xls});
    counter2_strgau_names=1;
    for counter4_sheets=1:count_sheets(counter4_xls)
        for counter3_strgau_sheet=2:count_strgau_sheet(counter4_xls,counter4_sheets)+1
            %strgau_x.(filename)(counter3_strgau_sheet,counter4_sheets)=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2};
            %strgau_y.(filename)(counter3_strgau_sheet,counter4_sheets)=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3};
            
               % for l=1:count_radii
                    if strfind(filename,'hor') >=1
                            for count1_radii=1:count_radii
                                cur_strgau_x=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2};
                                cur_strgau_y=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3};
                                radius{1,count1_radii}={'r',radius_width,radius_length(1,count1_radii)};
                                strgau_center=[cur_strgau_x,cur_strgau_y];
                                %m=m+1;
                                res_hor_strauss.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_hor{1,counter2_strgau_names}).(radius_name{count1_radii})=fieldextraction2(loadedframes,cur_frame,{'exx'},strgau_center,radius{1,count1_radii});
                            end
                            counter2_strgau_names=counter2_strgau_names+1;
                    elseif strfind(filename,'vert') >=1
                            for count2_radii=1:count_radii
                                cur_strgau_x=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2};
                                cur_strgau_y=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3};
                                radius{1,count2_radii}={'r',radius_length(1,count2_radii),radius_width};
                                strgau_center=[cur_strgau_x,cur_strgau_y];
                                %m=m+1;
                                res_vert_strauss.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_vert{1,counter2_strgau_names}).(radius_name{count2_radii})=fieldextraction2(loadedframes,cur_frame,{'eyy'},strgau_center,radius{1,count2_radii});
                            end
                            counter2_strgau_names=counter2_strgau_names+1;
                    else
                        disp('Neither vert nor hor String found');
                    end
               % end
        end
    end

end
%% save results as .mat file
result_filen=strcat('res_hor_strauss',wframes);
mat_filen=fullfile(workingdir,'../09_results/','res_hor_strauss/',result_filen);
save(mat_filen{counter1_chosenframes},'res_hor_strauss','res_vert_strauss');


%% Calculate max radii from the different dms to the border of the beam
max_radius_strgau=max_radius(loadedframes,raw_px,cal_height_beam,xls_filen,count_sheets,count_strgau_sheet,strgau_name_hor,strgau_name_vert,cur_frame,cal_scale_beam)


%% get results of castillo purposed method (max radius at correlation of .7)
for counter4_xls=1:length(xls_filen)
    [~,filename,~]=fileparts(xls_filen{counter4_xls});
    counter2_strgau_names=1;
    %radius{1,count1_radii}={'r',radius_width,radius_length(1,count1_radii)};
    for counter4_sheets=1:count_sheets(counter4_xls)
        for counter3_strgau_sheet=2:count_strgau_sheet(counter4_xls,counter4_sheets)+1
           
                    if strfind(filename,'hor') >=1
                            
                            cur_strgau_x=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2};
                            cur_strgau_y=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3};
                            strgau_center=[cur_strgau_x,cur_strgau_y];
                            stepsize=20
                            count_stepsize=floor(max_radius_strgau.hor.(strgau_name_hor{counter2_strgau_names}).max/stepsize)
                            counter_stepsize_iteration=1;
                            for counter_stepsize=1:count_stepsize
                                cur_max_radius=stepsize*counter_stepsize
                                radius={'r',cur_max_radius,cur_max_radius}
                                res_hor_pablo.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_hor{counter2_strgau_names}).exx{counter_stepsize_iteration,1}=fieldextraction2(loadedframes,cur_frame,{'exx'},strgau_center,radius);
                                res_hor_pablo.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_hor{counter2_strgau_names}).mean{counter_stepsize_iteration,1}=mean2(res_hor_pablo.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_hor{counter2_strgau_names}).exx{counter_stepsize_iteration,1}.exx);
                                res_hor_pablo.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_hor{counter2_strgau_names}).radius{counter_stepsize_iteration,1}=cur_max_radius;
                                counter_stepsize_iteration=counter_stepsize_iteration+1;

                            %cor=corr2(mean_exx_max_radius,cur_max_radius)
                            end
                            counter2_strgau_names=counter2_strgau_names+1;
                    elseif strfind(filename,'vert') >=1
                            cur_strgau_x=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2};
                            cur_strgau_y=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3};
                            strgau_center=[cur_strgau_x,cur_strgau_y];
                            stepsize=20
                            count_stepsize=floor(max_radius_strgau.vert.(strgau_name_vert{counter2_strgau_names}).max/stepsize)
                            counter_stepsize_iteration=1;
                            for counter_stepsize=1:count_stepsize
                                cur_max_radius=stepsize*counter_stepsize
                                radius={'r',cur_max_radius,cur_max_radius}
                                res_vert_pablo.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_vert{counter2_strgau_names}).eyy{counter_stepsize_iteration,1}=fieldextraction2(loadedframes,cur_frame,{'eyy'},strgau_center,radius);
                                res_vert_pablo.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_vert{counter2_strgau_names}).mean{counter_stepsize_iteration,1}=mean2(res_vert_pablo.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_vert{counter2_strgau_names}).eyy{counter_stepsize_iteration,1}.eyy)
                                res_vert_pablo.(wframes_wo_ext{1,counter1_chosenframes}).(strgau_name_vert{counter2_strgau_names}).radius{counter_stepsize_iteration,1}=cur_max_radius;
                                %cor=corr2(mean_exx_max_radius,cur_max_radius)
                                counter_stepsize_iteration=counter_stepsize_iteration+1;

                            end
                            
                            counter2_strgau_names=counter2_strgau_names+1;
                    else
                        disp('Neither vert nor hor String found');
                    end
        end
    end

end




varnames = {'workingdir','chosen_frames','counter1_chosenframes','waitb','lenChosenFrames','wframes_wo_ext','wframes','cal_scale_beam','cal_y_origin','cal_x_origin','cal_height_beam','xls_filen','xls_path','res_hor_strauss','res_vert_strauss','count_sheets','count_strgau_sheet','raw_px','strgau_name_hor','strgau_name_vert','max_radius_strgau','res_hor_pablo','res_vert_pablo','row_highest_load_dms','num_dms_data','num_dms_data_converted','num_dms_data_atena','num_dms_data_atena_converted'};
clearvars('-except',varnames{:});
end
timerval=toc

end

%end

%% evaluate the correlation between radii and mean value of exx/eyy of the area corresponding to the position of the straingauges
%horizontal

count_frames=length(chosen_frames)
for counter_frames=1:count_frames
    count_strgau=size(fieldnames(res_hor_pablo.(wframes_wo_ext{counter_frames})),1);
    for counter_strgau=1:count_strgau
        count_radii_mean=size(res_hor_pablo.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).mean,1);
        for counter_radii_mean=1:count_radii_mean
            mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).mean{1,counter_radii_mean}=res_hor_pablo.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).mean(1:counter_radii_mean,1);
            mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).radii{1,counter_radii_mean}=res_hor_pablo.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).radius(1:counter_radii_mean,1);
        end
    end
end

count_frames=length(chosen_frames);
for counter_frames=1:count_frames
    count_strgau=size(fieldnames(res_hor_pablo.(wframes_wo_ext{counter_frames})),1);
    for counter_strgau=1:count_strgau
        count_radii_mean=size(res_hor_pablo.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).mean,1);
        for counter_radii_mean=1:count_radii_mean
A=cell2mat(mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).mean{1,counter_radii_mean});
B=cell2mat(mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).radii{1,counter_radii_mean});
%C=gpuArray(A);
%D=gpuArray(B);

mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).corr(1,counter_radii_mean)=corr2(A,B);
        end
        %figure()
        %scatter(A,B)
    end
end
for counter_frames=1:count_frames
    count_strgau=size(fieldnames(res_hor_pablo.(wframes_wo_ext{counter_frames})),1);
    for counter_strgau=1:count_strgau
    [~,corr_indices_greater{counter_frames,counter_strgau}]=find(mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).corr >= 0.7);
    [~,corr_indices_less{counter_frames,counter_strgau}]=find(mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).corr <= -0.7);
    
    corr_indices_comp=cat(2,corr_indices_greater{counter_frames,counter_strgau},corr_indices_less{counter_frames,counter_strgau})
    max_radius_corr_accept=max(corr_indices_comp)
    res_max_radius_corr.hor.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).max_radius=mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).radii{1,max_radius_corr_accept}{max_radius_corr_accept,1}
    res_max_radius_corr.hor.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).mean_exx=mean.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).mean{1,max_radius_corr_accept}{max_radius_corr_accept,1}
    end
end

%vertical

count_frames=length(chosen_frames)
for counter_frames=1:count_frames
    count_strgau=size(fieldnames(res_vert_pablo.(wframes_wo_ext{counter_frames})),1)
    for counter_strgau=1:count_strgau
        count_radii_mean=size(res_vert_pablo.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).mean,1)
        for counter_radii_mean=1:count_radii_mean
            mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).mean{1,counter_radii_mean}=res_vert_pablo.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).mean(1:counter_radii_mean,1);
            mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).radii{1,counter_radii_mean}=res_vert_pablo.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).radius(1:counter_radii_mean,1);
        end
    end
end

count_frames=length(chosen_frames)
for counter_frames=1:count_frames
    count_strgau=size(fieldnames(res_vert_pablo.(wframes_wo_ext{counter_frames})),1);
    for counter_strgau=1:count_strgau
        count_radii_mean=size(res_vert_pablo.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).mean,1);
        for counter_radii_mean=1:count_radii_mean
A=cell2mat(mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).mean{1,counter_radii_mean});
B=cell2mat(mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).radii{1,counter_radii_mean});
%C=gpuArray(A);
%D=gpuArray(B);

mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).corr(1,counter_radii_mean)=corr2(A,B);
        end
        %figure()
        %scatter(A,B)
    end
end

for counter_frames=1:count_frames
    count_strgau=size(fieldnames(res_vert_pablo.(wframes_wo_ext{counter_frames})),1);
    for counter_strgau=1:count_strgau
    [~,corr_indices_greater{counter_frames,counter_strgau}]=find(mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).corr >= 0.7);
    [~,corr_indices_less{counter_frames,counter_strgau}]=find(mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).corr <= -0.7);
    
    corr_indices_comp=cat(2,corr_indices_greater{counter_frames,counter_strgau},corr_indices_less{counter_frames,counter_strgau});
    max_radius_corr_accept=max(corr_indices_comp)
    res_max_radius_corr.vert.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).max_radius=mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).radii{1,max_radius_corr_accept}{max_radius_corr_accept,1};
    res_max_radius_corr.vert.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).mean_eyy=mean.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).mean{1,max_radius_corr_accept}{max_radius_corr_accept,1};
    end
end
%% plot res hor strauss exx/eyy for each pixel each straingauge each radius

loadlev=1:1:count_frames
strgau_name=fieldnames(res_hor_strauss.(wframes_wo_ext{1}));
radii_name=fieldnames(res_hor_strauss.(wframes_wo_ext{1}).(strgau_name{1}));
count_frames=length(fieldnames(res_hor_strauss));
count_strgau=length(fieldnames(res_hor_strauss.(wframes_wo_ext{1})));
count_radii=length(fieldnames(res_hor_strauss.(wframes_wo_ext{1}).(strgau_name{1})));

load_levels=[58,86,115,143,168,199,230,287,306];
plot_res_hor_strauss=figure();
position_plot=1;
for counter_strgau=1:count_strgau
    for counter_radii=1:count_radii
        for counter_frames=1:count_frames
    
    subplot(count_strgau,count_radii,position_plot)
    hold on
    plot_title=strcat('Straingauge: ',strgau_name{counter_strgau,1},' horizontal ',radii_name{counter_radii,1});
    title(plot_title);
    xlabel('Pixel [px]');
    ylabel('exx [-]');
    legend_entry{counter_frames}=strcat('Loadlevel: ',num2str(load_levels(counter_frames)),' kN');

    plot(res_hor_strauss.(wframes_wo_ext{counter_frames}).(strgau_name{counter_strgau,1}).(radii_name{counter_radii,1}).exx(1,:))
        end
        position_plot=position_plot+1;
end
legend_plot_res_hor_strauss=legend(legend_entry);
legend_plot_res_hor_strauss.Location='bestoutside';
legend_plot_res_hor_strauss.Box='on';
legend_plot_res_hor_strauss.EdgeColor='white';
end
hold off

strgau_name=fieldnames(res_vert_strauss.(wframes_wo_ext{1}));
radii_name=fieldnames(res_vert_strauss.(wframes_wo_ext{1}).(strgau_name{1}));
count_frames=length(fieldnames(res_vert_strauss));
count_strgau=length(fieldnames(res_vert_strauss.(wframes_wo_ext{1})));
count_radii=length(fieldnames(res_vert_strauss.(wframes_wo_ext{1}).(strgau_name{1})));

load_levels=[58,86,115,143,168,199,230,287,306];
plot_res_vert_strauss=figure();

position_plot=1;
for counter_strgau=1:count_strgau
    for counter_radii=1:count_radii
for counter_frames=1:count_frames
    subplot(count_strgau,count_radii,position_plot);
    hold on
    plot_title=strcat('Straingauge: ',strgau_name{counter_strgau,1},' vertical ',radii_name{counter_radii,1});
    title(plot_title);
    xlabel('Pixel [px]');
    ylabel('eyy [-]');
    legend_entry{counter_frames}=strcat('Loadlevel: ',num2str(load_levels(counter_frames)),' kN');

    plot(res_vert_strauss.(wframes_wo_ext{counter_frames}).(strgau_name{counter_strgau,1}).(radii_name{counter_radii,1}).eyy(:,1));
end
            position_plot=position_plot+1;

    end
legend_plot_res_vert_strauss=legend(legend_entry);
legend_plot_res_vert_strauss.Location='bestoutside';
legend_plot_res_vert_strauss.Box='on';
legend_plot_res_vert_strauss.EdgeColor='white';
end
% end

%% Strauss Mean of exx/eyy and corresponding radii per loadlevel for each straingauge position 
% horziontal straingauges
strgau_name=fieldnames(res_hor_strauss.(wframes_wo_ext{1}));
radii_name=fieldnames(res_hor_strauss.(wframes_wo_ext{1}).(strgau_name{1}));
count_frames=length(fieldnames(res_hor_strauss));
count_strgau=length(fieldnames(res_hor_strauss.(wframes_wo_ext{1})));
count_radii=length(fieldnames(res_hor_strauss.(wframes_wo_ext{1}).(strgau_name{1})));
plot_res_hor_strauss_a=figure();
row_dms_xlsx_hor=[20,12,13];
row_dms_xlsx_hor_atena=[19,40,54];
row_dms_xlsx_hor_atena=row_dms_xlsx_hor_atena-6;
row_dms_xlsx_vert=[6,11,5,21,1337,22];
row_dms_xlsx_vert_atena=[103,110,117,124,1337,138];
row_dms_xlsx_vert_atena=row_dms_xlsx_vert_atena-6;
position_plot=1;
for counter_strgau=1:count_strgau
    for counter_radii=1:count_radii
        for counter_frames=1:count_frames
            subplot(count_strgau,1,position_plot)
            hold on
            plot_title=strcat('Straingauge: ',strgau_name{counter_strgau,1},' horizontal ');
            title(plot_title);
            ylabel('loadlevels');
            xlabel('mean of exx [-]');
            legend_entry{counter_radii}=strcat(radii_name{counter_radii},' mm');
            mean_strain_hor(counter_frames,counter_radii,counter_strgau)=mean2(res_hor_strauss.(wframes_wo_ext{counter_frames}).(strgau_name{counter_strgau,1}).(radii_name{counter_radii,1}).exx(1,:));
            str_loadlevels{counter_frames}=strcat('loadlevel: ',num2str(load_levels(counter_frames)),' kN');
            
        end
        plot(mean_strain_hor(:,counter_radii,counter_strgau),load_levels);
%         xmin=-16*10^(-4);
%         xmax=14*10^(-4);
%         ymin=1;
%         ymax=9;
%         axis([xmin xmax ymin ymax]);
        %set(gca, 'YTickLabel',str_loadlevels, 'YTick',1:numel(str_loadlevels),'YTickLabelRotation',45);
    end
    plot(num_dms_data_converted(1:row_highest_load_dms,row_dms_xlsx_hor(counter_strgau)),num_dms_data(1:row_highest_load_dms));
    plot(num_dms_data_atena_converted(4:290,row_dms_xlsx_hor_atena(counter_strgau)),num_dms_data_atena(4:290,row_dms_xlsx_hor_atena(counter_strgau)-1));
    position_plot=position_plot+1;
    legend_plot_res_hor_strauss=legend(legend_entry);
legend_plot_res_hor_strauss.Location='bestoutside';
legend_plot_res_hor_strauss.Box='on';
legend_plot_res_hor_strauss.EdgeColor='white';
end

% vertical straingauges

strgau_name=fieldnames(res_vert_strauss.(wframes_wo_ext{1}));
radii_name=fieldnames(res_vert_strauss.(wframes_wo_ext{1}).(strgau_name{1}));
count_frames=length(fieldnames(res_vert_strauss));
count_strgau=length(fieldnames(res_vert_strauss.(wframes_wo_ext{1})));
count_radii=length(fieldnames(res_vert_strauss.(wframes_wo_ext{1}).(strgau_name{1})));
plot_res_vert_strauss_a=figure();

position_plot=1;
for counter_strgau=1:count_strgau
    for counter_radii=1:count_radii
        for counter_frames=1:count_frames
            subplot(count_strgau,1,position_plot);
            hold on
            plot_title=strcat('Straingauge: ',strgau_name{counter_strgau,1},' vertical ');
            title(plot_title);
            ylabel('loadlevels');
            xlabel('mean of eyy [-]');
            legend_entry{counter_radii}=strcat(radii_name{counter_radii},' mm');
            mean_strain_vert(counter_frames,counter_radii,counter_strgau)=mean2(res_vert_strauss.(wframes_wo_ext{counter_frames}).(strgau_name{counter_strgau,1}).(radii_name{counter_radii,1}).eyy(:,1));
            str_loadlevels{counter_frames}=strcat('loadlevel: ',num2str(load_levels(counter_frames)),' kN');
        end
        plot(mean_strain_vert(:,counter_radii,counter_strgau),load_levels)
%         xmin=-6*10^(-4);
%         xmax=6*10^(-4);
%         ymin=1;
%         ymax=9;
%         axis([xmin xmax ymin ymax]);
%         set(gca, 'YTickLabel',str_loadlevels, 'YTick',1:numel(str_loadlevels),'YTickLabelRotation',45)
    end
    if row_dms_xlsx_vert(counter_strgau)~=1337
    plot(num_dms_data_converted(1:row_highest_load_dms,row_dms_xlsx_vert(counter_strgau)),num_dms_data(1:row_highest_load_dms)); 
    plot(num_dms_data_atena_converted(4:290,row_dms_xlsx_vert_atena(counter_strgau)),num_dms_data_atena(4:290,row_dms_xlsx_vert_atena(counter_strgau)-1));
    else
        disp('lol zu diesem DMS hamma ka Daten lelelelelel');
    end
    position_plot=position_plot+1;
    legend_plot_res_vert_strauss=legend(legend_entry);
legend_plot_res_vert_strauss.Location='bestoutside';
legend_plot_res_vert_strauss.Box='on';
legend_plot_res_vert_strauss.EdgeColor='white';
end

%% Pablo plot exx / eyy mean per frame per dms of max radius
%horizontal
strgau_name=fieldnames(res_hor_pablo.(wframes_wo_ext{1}));
count_strgau=length(fieldnames(res_max_radius_corr.hor.(wframes_wo_ext{1})));
count_frames=length(fieldnames(res_max_radius_corr.hor));
plot_res_hor_pablo=figure();
for counter_strgau=1:count_strgau
    for counter_frames=1:count_frames
        exx_plot(counter_strgau,counter_frames)=res_max_radius_corr.hor.(wframes_wo_ext{counter_frames}).(strgau_name_hor{counter_strgau}).mean_exx;
        
    end
    hold on
    subplot(count_strgau,1,counter_strgau)
    plot(exx_plot(counter_strgau,:),load_levels,num_dms_data_converted(1:row_highest_load_dms,row_dms_xlsx_hor(counter_strgau)),num_dms_data(1:row_highest_load_dms),num_dms_data_atena_converted(4:290,row_dms_xlsx_hor_atena(counter_strgau)),num_dms_data_atena(4:290,row_dms_xlsx_hor_atena(counter_strgau)-1))
    %plot(num_dms_data_atena_converted(4:290,row_dms_xlsx_hor_atena(counter_strgau)),num_dms_data_atena(4:290,row_dms_xlsx_hor_atena(counter_strgau)-1));

    %plot(num_dms_data_converted(1:row_highest_load_dms,row_dms_xlsx_hor(counter_strgau)),num_dms_data(1:row_highest_load_dms));
%     xmin=-16*10^(-4);
%     xmax=14*10^(-4);
%     ymin=1;
%     ymax=9;
%     axis([xmin xmax ymin ymax]);
    %set(gca, 'YTickLabel',str_loadlevels, 'YTick',1:numel(str_loadlevels),'YTickLabelRotation',45)
    plot_title=strcat('Straingauge: ',strgau_name{counter_strgau,1},' horizontal ');
    title(plot_title);
    ylabel('loadlevels');
    xlabel('mean of exx [-]');
    legend_entry=('rmax acceptable');
    legend_plot_res_hor_pablo=legend(legend_entry);
    legend_plot_res_hor_pablo.Location='bestoutside';
    legend_plot_res_hor_pablo.Box='on';
    legend_plot_res_hor_pablo.EdgeColor='white';
   

            

end


%vertical
strgau_name=fieldnames(res_vert_pablo.(wframes_wo_ext{1}));
count_strgau=length(fieldnames(res_max_radius_corr.vert.(wframes_wo_ext{1})));
count_frames=length(fieldnames(res_max_radius_corr.vert));
plot_res_vert_pablo=figure();
for counter_strgau=1:count_strgau
    for counter_frames=1:count_frames
        eyy_plot(counter_strgau,counter_frames)=res_max_radius_corr.vert.(wframes_wo_ext{counter_frames}).(strgau_name_vert{counter_strgau}).mean_eyy;
        
    end
    hold on
    subplot(count_strgau,1,counter_strgau)
    if row_dms_xlsx_vert(counter_strgau)~=1337
    plot(eyy_plot(counter_strgau,:),load_levels,num_dms_data_converted(1:row_highest_load_dms,row_dms_xlsx_vert(counter_strgau)),num_dms_data(1:row_highest_load_dms),num_dms_data_atena_converted(4:290,row_dms_xlsx_vert_atena(counter_strgau)),num_dms_data_atena(4:290,row_dms_xlsx_vert_atena(counter_strgau)-1));
    %plot(num_dms_data_atena_converted(4:290,row_dms_xlsx_hor_atena(counter_strgau)),num_dms_data_atena(4:290,row_dms_xlsx_hor_atena(counter_strgau)-1));
    else
        disp('lol zu diesem DMS hamma ka Daten lelelelelel');
        plot(eyy_plot(counter_strgau,:),load_levels)

    end
%     xmin=-6*10^(-4);
%     xmax=6*10^(-4);
%     ymin=1;
%     ymax=9;
%     axis([xmin xmax ymin ymax]);
%     set(gca, 'YTickLabel',str_loadlevels, 'YTick',1:numel(str_loadlevels),'YTickLabelRotation',45)
    plot_title=strcat('Straingauge: ',strgau_name{counter_strgau,1},' vertical ');
    title(plot_title);
    ylabel('loadlevels');
    xlabel('mean of eyy [-]');
    legend_entry=('rmax acceptable');
    legend_plot_res_hor_pablo=legend(legend_entry);
    legend_plot_res_hor_pablo.Location='bestoutside';
    legend_plot_res_hor_pablo.Box='on';
    legend_plot_res_hor_pablo.EdgeColor='white';
   
    
            

end
print('res_vert_pablo','-dpdf')
end
%%save data to plot in pgf

% horizontal dms strauss save as csv
num_frames=size(mean_strain_hor,1);
num_radii=size(mean_strain_hor,2);
num_strgau=size(mean_strain_hor,3);
for count_strgau=1:num_strgau
    save_as_csv={'loadlevels','r20','r15','r10'};
    save_as_csv(2:10,1)=num2cell(rot90(load_levels,3));
    for count_radii=1:num_radii
    save_as_csv(2:10,1+count_radii)=num2cell(mean_strain_hor(:,count_radii,count_strgau));
    end
    save_as_csv_table=cell2table(save_as_csv(2:end,1:end),'VariableNames',{'loadlevels','r20','r15','r10'});
    csv_filen=strcat('strauss_',strgau_name_hor{count_strgau},'.csv')
    csv_filename=fullfile(workingdir,'../11_plot_csv/',csv_filen);
    writetable(save_as_csv_table,csv_filename);
end

%vertical dms strauss save as csv
num_frames=size(mean_strain_vert,1);
num_radii=size(mean_strain_vert,2);
num_strgau=size(mean_strain_vert,3);
for count_strgau=1:num_strgau
    save_as_csv={'loadlevels','r20','r15','r10'};
    save_as_csv(2:10,1)=num2cell(rot90(load_levels,3));
    for count_radii=1:num_radii
    save_as_csv(2:10,1+count_radii)=num2cell(mean_strain_vert(:,count_radii,count_strgau));
    end
    save_as_csv_table=cell2table(save_as_csv(2:end,1:end),'VariableNames',{'loadlevels','r20','r15','r10'});
    csv_filen=strcat('strauss_',strgau_name_vert{count_strgau},'.csv')
    csv_filename=fullfile(workingdir,'../11_plot_csv/',csv_filen);
    writetable(save_as_csv_table,csv_filename);
end

%% jirovsky atena

% horizontal dms jirovsky save as csv



% Z=rand(1,9)
% loadlev=1:1:9
% plot(eyy_plot(1,:),loadlev)
% axis([-2,-16,min(loadlev),max(loadlev)])
% set(gca, 'YTickLabel',str_loadlevels, 'YTick',1:numel(str_loadlevels),'YTickLabelRotation',45)
