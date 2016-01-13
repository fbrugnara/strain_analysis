function [ max_radius ] = max_radius( loadedframes,raw_px,height_beam,xls_filen,count_sheets,count_strgau_sheet,strgau_name_hor,strgau_name_vert,cur_frame,cal_scale_beam )
%METHOD_CASTILLO Summary of this function goes here
%   Detailed explanation goes here

for counter4_xls=1:length(xls_filen)
    [~,filename,~]=fileparts(xls_filen{counter4_xls});
    counter2_strgau_names=1;
    for counter4_sheets=1:count_sheets(counter4_xls)
        for counter3_strgau_sheet=2:count_strgau_sheet(counter4_xls,counter4_sheets)+1
                    if strfind(filename,'hor') >=1
                            
                            max_radius_l.hor.(strgau_name_hor{counter2_strgau_names}).x=abs(raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2}-1);
                            max_radius_r.hor.(strgau_name_hor{counter2_strgau_names}).x=abs(raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2}-length(loadedframes.(cur_frame{1}).completeField.exx));
                            
                            if max_radius_l.hor.(strgau_name_hor{counter2_strgau_names}).x > max_radius_r.hor.(strgau_name_hor{counter2_strgau_names}).x
                                max_radius.hor.(strgau_name_hor{counter2_strgau_names}).x = floor(max_radius_r.hor.(strgau_name_hor{counter2_strgau_names}).x)
                                disp('Rechter Abstand ist kleiner');
                            elseif max_radius_l.hor.(strgau_name_hor{counter2_strgau_names}).x < max_radius_r.hor.(strgau_name_hor{counter2_strgau_names}).x
                                max_radius.hor.(strgau_name_hor{counter2_strgau_names}).x = floor(max_radius_l.hor.(strgau_name_hor{counter2_strgau_names}).x)
                                disp('Linker Abstand ist kleiner');
                            else
                                max_radius.hor.(strgau_name_hor{counter2_strgau_names}).x = floor(max_radius_l.hor.(strgau_name_hor{counter2_strgau_names}).x)
                                disp('Abstände sind gleich (cmon dude)');
                            end
                            
                            
                            max_radius_o.hor.(strgau_name_hor{counter2_strgau_names}).y=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3};
                            max_radius_u.hor.(strgau_name_hor{counter2_strgau_names}).y=abs(height_beam*cal_scale_beam-raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3});
                            
                            if max_radius_o.hor.(strgau_name_hor{counter2_strgau_names}).y > max_radius_u.hor.(strgau_name_hor{counter2_strgau_names}).y
                                max_radius.hor.(strgau_name_hor{counter2_strgau_names}).y=floor(max_radius_u.hor.(strgau_name_hor{counter2_strgau_names}).y)
                            elseif max_radius_o.hor.(strgau_name_hor{counter2_strgau_names}).y < max_radius_u.hor.(strgau_name_hor{counter2_strgau_names}).y
                                max_radius.hor.(strgau_name_hor{counter2_strgau_names}).y=floor(max_radius_o.hor.(strgau_name_hor{counter2_strgau_names}).y)
                            else
                                max_radius.hor.(strgau_name_hor{counter2_strgau_names}).y=floor(max_radius_o.hor.(strgau_name_hor{counter2_strgau_names}).y)
                            end
                            
                            if max_radius.hor.(strgau_name_hor{counter2_strgau_names}).x > max_radius.hor.(strgau_name_hor{counter2_strgau_names}).y
                               max_radius.hor.(strgau_name_hor{counter2_strgau_names}).max=max_radius.hor.(strgau_name_hor{counter2_strgau_names}).y;
                            else
                                max_radius.hor.(strgau_name_hor{counter2_strgau_names}).max=max_radius.hor.(strgau_name_hor{counter2_strgau_names}).x;
                            end
                            
                            
                            counter2_strgau_names=counter2_strgau_names+1;
                    elseif strfind(filename,'vert') >=1
                           max_radius_l.vert.(strgau_name_vert{counter2_strgau_names}).x=abs(raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2}-1);
                            max_radius_r.vert.(strgau_name_vert{counter2_strgau_names}).x=abs(raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,2}-length(loadedframes.(cur_frame{1}).completeField.exx));
                         if max_radius_l.vert.(strgau_name_vert{counter2_strgau_names}).x > max_radius_r.vert.(strgau_name_vert{counter2_strgau_names}).x
                                max_radius.vert.(strgau_name_vert{counter2_strgau_names}).x = floor(max_radius_r.vert.(strgau_name_vert{counter2_strgau_names}).x)
                                disp('Rechter Abstand ist kleiner');
                            elseif max_radius_l.vert.(strgau_name_vert{counter2_strgau_names}).x < max_radius_r.vert.(strgau_name_vert{counter2_strgau_names}).x
                                max_radius.vert.(strgau_name_vert{counter2_strgau_names}).x = floor(max_radius_l.vert.(strgau_name_vert{counter2_strgau_names}).x)
                                disp('Linker Abstand ist kleiner');
                            else
                                max_radius.vert.(strgau_name_vert{counter2_strgau_names}).x = floor(max_radius_l.vert.(strgau_name_vert{counter2_strgau_names}).x)
                                disp('Abstände sind gleich (cmon dude)');
                         end
                            
                            
                            max_radius_o.vert.(strgau_name_vert{counter2_strgau_names}).y=raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3};
                            max_radius_u.vert.(strgau_name_vert{counter2_strgau_names}).y=abs(height_beam*cal_scale_beam-raw_px.(filename){1,counter4_sheets}{counter3_strgau_sheet,3});
                            
                            if max_radius_o.vert.(strgau_name_vert{counter2_strgau_names}).y > max_radius_u.vert.(strgau_name_vert{counter2_strgau_names}).y
                                max_radius.vert.(strgau_name_vert{counter2_strgau_names}).y=floor(max_radius_u.vert.(strgau_name_vert{counter2_strgau_names}).y)
                            elseif max_radius_o.vert.(strgau_name_vert{counter2_strgau_names}).y < max_radius_u.vert.(strgau_name_vert{counter2_strgau_names}).y
                                max_radius.vert.(strgau_name_vert{counter2_strgau_names}).y=floor(max_radius_o.vert.(strgau_name_vert{counter2_strgau_names}).y)
                            else
                                max_radius.vert.(strgau_name_vert{counter2_strgau_names}).y=floor(max_radius_o.vert.(strgau_name_vert{counter2_strgau_names}).y)
                            end
                            
                            if max_radius.vert.(strgau_name_vert{counter2_strgau_names}).x > max_radius.vert.(strgau_name_vert{counter2_strgau_names}).y
                               max_radius.vert.(strgau_name_vert{counter2_strgau_names}).max=max_radius.vert.(strgau_name_vert{counter2_strgau_names}).y;
                            else
                                max_radius.vert.(strgau_name_vert{counter2_strgau_names}).max=max_radius.vert.(strgau_name_vert{counter2_strgau_names}).x;
                            end
                            
                            counter2_strgau_names=counter2_strgau_names+1;
                    else
                        disp('Neither vert nor hor String found');
                    end
        end
        
    end

end



end

