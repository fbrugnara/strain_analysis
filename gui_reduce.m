% Bla some change in gui_reduce
function [ output_args ] = gui_reduce( input_args )
%GUI_REDUCE Summary of this function goes here
%   Detailed explanation goes here
screensize=get(groot,'Screensize');
x_scr_cent=screensize(1,3)/2;
y_scr_cent=screensize(1,4)/2;
x_offs=200;
y_offs=50;
f = figure('Visible','off','Position',[x_scr_cent-x_offs,y_scr_cent-y_offs,2*x_offs,2*y_offs],...
            'ToolBar','none','DockControls','off','MenuBar','none');
    htext  = uicontrol('Style','text','String','Do You want to exclude some fields?',...
           'Position',[x_offs-(x_offs-20),y_offs-(y_offs-20-20-15),x_offs,30]);
    
       
    
       pushb_no = uicontrol('Style','pushbutton','String','No',...
           'Position',[x_offs-(x_offs-20),y_offs-(y_offs-20),70,25]);
       pushb_yes = uicontrol('Style','pushbutton','String','Yes',...
           'Position',[x_offs-(x_offs-20)+20+70,y_offs-(y_offs-20),70,25],...
           'Callback',{@pshb_yes_key_press,f,x_scr_cent,y_scr_cent,x_offs,y_offs});
      
   f.Visible = 'on';
end

function pshb_yes_key_press(hObject,callbackdata,f,x_scr_cent,y_scr_cent,x_offs,y_offs)

    f=figure('Visible','off','Position',[x_scr_cent-x_offs,y_scr_cent-y_offs,2*x_offs,2*y_offs],...
            'ToolBar','none','DockControls','off','MenuBar','none');
    f.Visible='on';
end
