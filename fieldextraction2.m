function [ extracted_data ] = fieldextraction2(loadedframes,wframes_wo_ext,wfields,strgau_center,radius)
%FIELDEXTRACTION2 Summary of this function goes here
%   Detailed explanation goes here
% Passt für eyy if vertical dms 
% width_half=ceil(radius{2})/2;
%     length_half=ceil(radius{3})/2;
%     x=strgau_center(1,1);
%     y=strgau_center(1,2);

% Passt für exx if horizontal dms
width_half=ceil(radius{3})/2;
    length_half=ceil(radius{2})/2;
    x=strgau_center(1,1);
    y=strgau_center(1,2);
    if radius{1,1}=='r'
for i=1:length(wframes_wo_ext)
    for j=1:length(wfields)
%extracted_data.(wframes_wo_ext{1,i}).(wfields{1,j})=loadedframes.(wframes_wo_ext{1,i}).completeField.(wfields{1,j})(y-length_half:y+length_half,x-width_half:x+width_half);
 extracted_data.(wfields{1,j})=loadedframes.(wframes_wo_ext{1,i}).completeField.(wfields{1,j})(y-length_half:y+length_half,x-width_half:x+width_half);
    end
end
    end
end

