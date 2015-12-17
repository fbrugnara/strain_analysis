   %% function wframes_gui gets DICpath and DICfilen and returns selected frames
   function [wframes,wframes_indices]=wframes_gui( DICfilen )
   %create figure
   f.fig=figure;
   handles=guihandles(f.fig);
   guidata(f.fig,handles);
   
        %place checkboxes and name them after DICfilen(i)
        for i=1:length(DICfilen); 
            f.cbh(i) = uicontrol(f.fig,'Style','checkbox','String',DICfilen(i), ...
            'Value',1,'Position',[30 20*i 130 20]);
        end
        
        % Place Button to Submit values 
        f.btn = uicontrol('Style', 'pushbutton', 'String', 'Submit',...
        'Position', [20 20*(i+1) 130 20],...
        'Callback',{@pushbuttoncallback,i,DICfilen,f,handles});
    uiwait(f.fig)
%     guidata(hObject,handles)
%    handles=guidata(hObject)
%    wframes=handles.appdata
%     
%    wframes=(hObject)
%
      handles = guidata(f.fig);
      wframes=handles.DICfilen;
      for i=1:length(wframes)
      [~,wframes{1,i},~]=fileparts(wframes{1,i})
      end
      wframes_indices=handles.wframes_indices
      close(f.fig)

   end
   %% callback of the submit button
   function pushbuttoncallback(hObject,event,i,DICfilen,f,handles)

    lenDICfilen=length(DICfilen);
    
    %Check the values of the checkboxes 
    % .Value returns the value of the checkbox zero unchecked
    %  one checked
    for k=1:lenDICfilen
          val(k)=f.cbh(1,k).Value; 
    end
    %find the indices we want to delete (where val is zero)
    indices =find(val(1,:)==0);
    wframes_indices=find(val(1,:))
    %if the is no entry we want to delete (indices is empty)
    if isempty(indices) == 0
    DICfilen(:,indices)=[];
    else
       DICfilen=DICfilen;
    end
    handles.wframes_indices=wframes_indices;
    handles.DICfilen=DICfilen;
    guidata(f.fig,handles);
    uiresume(f.fig)
   end
   
   