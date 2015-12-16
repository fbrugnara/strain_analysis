function wframes_gui( DICpath,DICfilen )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   
    f.fig=figure;
    for i=1:length(DICfilen); 
        cbh(i) = uicontrol(f.fig,'Style','checkbox','String',DICfilen(i), ...
                       'Value',0,'Position',[30 20*i 130 20],...
                        'Callback',{@checkBoxCallback,i,DICfilen});
    end
   