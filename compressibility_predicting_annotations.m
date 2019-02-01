%1 = happy_emotion
%2 = happy_enjoyment
%3 = sad_long_emotion
%4 = sad_long_enjoyment
%5 = sad_short_emotion
%6 = sad_short_enjoyment
song = 1
if song == 1 || song == 2
    comp = happy_compressibility;
end
if song == 3 || song == 4
    comp = sad_l_compressibility;
end
if song == 5 || song == 6
    comp = sad_s_compressibility;
end

average_annotations = [];
average_comp = [];
temp_ann = [];
average_annotations = zeros(1,length(3:length(ibi_data(song).sub(i).section)-1));
for j = 3:length(ibi_data(song).sub(1).section)-1
    temp_ann = [];
    for i = 1:length(ibi_data(song).sub)
        if ~isempty(ibi_data(song).sub(i).section)
            temp_ann = [mean(ibi_data(song).sub(i).section(j).ratings_signal), temp_ann];
        end
    end
    average_annotations(j-2) = mean(temp_ann(j-2));
end

average_comp = comp(3:length(ibi_data(song).sub(1).section)-1);

fitlm(average_comp,average_annotations)
scatter(average_comp,average_annotations)