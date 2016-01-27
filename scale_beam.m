function [scale,x_origin,y_origin,height_beam] = scale_beam( workingdir )
%SCALE_BEAM Summary of this function goes here
%   Detailed explanation goes here
instruction=msgbox({'Calibration:' 'Please put in the height of the object and choose a calibration image.'});
uiwait(instruction);
height_beam=inputdlg('Height of object[cm]:','Input height of object',1,{'45'});
height_beam=str2double(height_beam);
[beam_scale_filen,beam_scale_path]=uigetfile(fullfile(workingdir,'../01_rawData','*.tif'),'Select .tif 01_rawData','MultiSelect','off');
beam_image=fullfile(beam_scale_path,beam_scale_filen);

f = figure();
%f.MenuBar='none';
ax=gca;
lines=10;
imshow(beam_image,'Parent',ax);
title(ax,'Place ends of distance tool on edge of object and press enter. (repeats 10 times)')
xlim=get(gca,'Xlim');
distx=xlim(2)-xlim(1);
intx=distx/(lines+1);

ylim=get(gca,'Ylim');
%disty=ylim(2)-ylim(1);
y_upperb=0.7*ylim(2);
y_lowerb=0.3*ylim(2);
%img_px_measure=zeros(lines,1);
pixel_length=zeros(lines,1);
%img_px_measure(1:lines)=imdistline();
for i=1:lines
img_px_measure(i)=imdistline(ax);
setPosition(img_px_measure(i),[intx*i y_lowerb;intx*i y_upperb]);
api = iptgetapi(img_px_measure(i));
fcn = makeConstrainToRectFcn('imline',[intx*i intx*i],...
   get(gca,'YLim'));
 api.setPositionConstraintFcn(fcn);
% setDragConstraintFcn(img_px_measure(i),[100*i 0;100*i 100 ])
pause()
pixel_length(i)=api.getDistance();
end
close(f);
mean_pixel_length=mean(pixel_length);
scale=mean_pixel_length/height_beam;
f = figure();
ax=gca;
imshow(fullfile(beam_scale_path,beam_scale_filen),'Parent',ax);
[x_origin,y_origin]=ginput(1);
x_origin=abs(ceil(x_origin));
y_origin=abs(ceil(y_origin));
%[x,y]=getpts(f);
close(f);
end
