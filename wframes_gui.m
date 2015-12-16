   %% function wframes_gui gets DICpath and DICfilen and returns selected frames
   function [wframes]=wframes_gui( DICpath,DICfilen )
   %create figure
   f.fig=figure;
        %place checkboxes and name them after DICfilen(i)
        for i=1:length(DICfilen); 
            f.cbh(i) = uicontrol(f.fig,'Style','checkbox','String',DICfilen(i), ...
            'Value',1,'Position',[30 20*i 130 20]);
        end
        
        % Place Button to Submit values 
        f.btn = uicontrol('Style', 'pushbutton', 'String', 'Submit',...
        'Position', [20 20*(i+1) 130 20],...
        'Callback',{@pushbuttoncallback,i,DICfilen,f});  
   h=findobj
   wframes=h.UserData
    
   end
   %% callback of the submit button
   function pushbuttoncallback(hObject,event,i,DICfilen,f)
    
    %length of the in put cell
    lenDICfilen=length(DICfilen);
    
    %Check the values of the checkboxes 
    % .Value returns the value of the checkbox zero unchecked
    %  one checked
    for k=1:lenDICfilen
          val(k)=f.cbh(1,k).Value  
    end
    %find the indices we want to delete (where val is zero)
    indices =find(val(1,:)==0)
    %if the is no entry we want to delete (indices is empty)
    if isempty(indices) == 0
    DICfilen(:,indices)=[]
    else
       DICfilen=DICfilen
    end
    hObject.UserData=DICfilen
    close(f.fig);
   end
   
   