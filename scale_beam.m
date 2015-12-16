function [ scale ] = scale_beam( beam_image,height_beam )
%SCALE_BEAM Summary of this function goes here
%   Detailed explanation goes here
f = figure()
ax=gca
lines=10;
img_beam=imshow(beam_image,'Parent',ax)
xlim=get(gca,'Xlim');
distx=xlim(2)-xlim(1);
intx=distx/(lines+1);

ylim=get(gca,'Ylim');
%disty=ylim(2)-ylim(1);
y_upperb=0.7*ylim(2)
y_lowerb=0.3*ylim(2)
for i=1:lines
img_px_measure(i)=imdistline
setPosition(img_px_measure(i),[intx*i y_lowerb;intx*i y_upperb])
api = iptgetapi(img_px_measure(i));
fcn = makeConstrainToRectFcn('imline',[intx*i intx*i],...
   get(gca,'YLim'));
 api.setPositionConstraintFcn(fcn);
% setDragConstraintFcn(img_px_measure(i),[100*i 0;100*i 100 ])
pause()
pixel_length(i)=api.getDistance();
end
close(f);
pixel_length;
mean_pixel_length=mean(pixel_length);
scale=mean_pixel_length/height_beam;
end

