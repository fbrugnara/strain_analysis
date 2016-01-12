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
if exist('cal_scale_beam','var') == 0 || exist('cal_y_origin','var') == 0 || exist('cal_x_origin','var') == 0
    [cal_scale_beam,cal_x_origin,cal_y_origin]=scale_beam(workingdir);
end


%% Choose which Frames to use 
dir_stitchedfields = fullfile(workingdir,'../04_StitchedFields','*.mat');
contents_stitchedfields=dir(dir_stitchedfields);
if exist('res_hor_strauss','var') == 0 || exist('res_vert_strauss','var') == 0
fieldnames_stitchedfields={contents_stitchedfields(:).name};
 [wframes,wframes_wo_ext,wframes_indices]=wframes_gui(fieldnames_stitchedfields);
chosen_frames=fullfile(workingdir,'../04_StitchedFields/',wframes);
    

%% Load frames
lenChosenFrames=length(chosen_frames);
tic
for counter1_chosenframes = 1:lenChosenFrames
loadedframes.(wframes_wo_ext{1,counter1_chosenframes})=load(chosen_frames{1,counter1_chosenframes});
cur_frame=wframes_wo_ext(counter1_chosenframes);


%% Evaluation of hor and vert straingauges 
% read xls dms position data
if exist('xls_filen','var') == 0 || exist('xls_path','var') == 0
[xls_filen,xls_path]=uigetfile(fullfile('/home/bowkatz/Documents/MATLAB/BachelorThesis/08_DMSPos_xls','*.xls'),'Select .xls containing DMS info','MultiSelect','on');
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
            strgau_x.(filename)(counter3_strgau_sheet,counter4_sheets)=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2};
            strgau_y.(filename)(counter3_strgau_sheet,counter4_sheets)=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3};
            
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
varnames = {'workingdir','chosen_frames','counter1_chosenframes','waitb','lenChosenFrames','wframes_wo_ext','wframes','cal_scale_beam','cal_y_origin','cal_x_origin','xls_filen','xls_path','res_hor_strauss','res_vert_strauss'};
clearvars('-except',varnames{:});
end
toc
end
%% plot res hor strauss exx/eyy for each pixel each straingauge each radius

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

%% Mean of exx/eyy and corresponding radii per loadlevel for each straingauge position

% horziontal straingauges

strgau_name=fieldnames(res_hor_strauss.(wframes_wo_ext{1}));
radii_name=fieldnames(res_hor_strauss.(wframes_wo_ext{1}).(strgau_name{1}));
count_frames=length(fieldnames(res_hor_strauss));
count_strgau=length(fieldnames(res_hor_strauss.(wframes_wo_ext{1})));
count_radii=length(fieldnames(res_hor_strauss.(wframes_wo_ext{1}).(strgau_name{1})));
plot_res_hor_strauss_a=figure();

position_plot=1;
for counter_strgau=1:count_strgau
    for counter_radii=1:count_radii
        for counter_frames=1:count_frames
            subplot(count_strgau,1,position_plot)
            hold on
            plot_title=strcat('Straingauge: ',strgau_name{counter_strgau,1},' horizontal ');
            title(plot_title);
            xlabel('loadlevels');
            ylabel('mean of exx [-]');
            legend_entry{counter_radii}=strcat(radii_name{counter_radii},' mm');
            mean_strain(counter_frames,counter_radii,counter_strgau)=mean(res_hor_strauss.(wframes_wo_ext{counter_frames}).(strgau_name{counter_strgau,1}).(radii_name{counter_radii,1}).exx(1,:))
            str_loadlevels{counter_frames}=strcat('loadlevel: ',num2str(load_levels(counter_frames)),' kN');
            %plot(mean_strain(counter_frames))
        end
        plot(mean_strain(:,counter_radii,counter_strgau));
        set(gca, 'XTickLabel',str_loadlevels, 'XTick',1:numel(str_loadlevels),'XTickLabelRotation',45);
    end
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
            xlabel('loadlevels');
            ylabel('mean of eyy [-]');
            legend_entry{counter_radii}=strcat(radii_name{counter_radii},' mm');
            mean_strain(counter_frames,counter_radii,counter_strgau)=mean(res_vert_strauss.(wframes_wo_ext{counter_frames}).(strgau_name{counter_strgau,1}).(radii_name{counter_radii,1}).eyy(:,1))
            str_loadlevels{counter_frames}=strcat('loadlevel: ',num2str(load_levels(counter_frames)),' kN');
        end
        plot(mean_strain(:,counter_radii,counter_strgau))
        set(gca, 'XTickLabel',str_loadlevels, 'XTick',1:numel(str_loadlevels),'XTickLabelRotation',45)
    end
    position_plot=position_plot+1;
    legend_plot_res_vert_strauss=legend(legend_entry);
legend_plot_res_vert_strauss.Location='bestoutside';
legend_plot_res_vert_strauss.Box='on';
legend_plot_res_vert_strauss.EdgeColor='white';
end





