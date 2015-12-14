function[out1] = fieldextraction(loadedDIC,wframes,wframes_filen,wfields,strgau_center,radius)
    width_half=ceil(radius{2})/2;
    length_half=ceil(radius{3})/2;
    x=strgau_center(1,2);
    y=strgau_center(1,1);
    if radius{1,1}=='r'
        for i=1:length(wfields)
            for j=1:length(wframes)
                out1.(wframes_filen{1,j}).(wfields{1,i})=loadedDIC{1,wframes(1,j)}.field_red.(wfields{1,i})(y-length_half:y+length_half,x-width_half:x+width_half);
            end
        end
    end
end