%1 = happy_emotion
%2 = happy_enjoyment
%3 = sad_long_emotion
%4 = sad_long_enjoyment
%5 = sad_short_emotion
%6 = sad_short_enjoyment
song = 6
average_annotations = [];
average_hrv = [];
for i = 1:length(ibi_data(song).sub)
    for j = 3:length(ibi_data(song).sub(i).section)-1
        temp_hrv = std(ibi_data(song).sub(i).section(j).ibi_signal);
        temp_ann = mean(ibi_data(song).sub(i).section(j).ratings_signal);
        average_annotations = [average_annotations, temp_ann];
        average_hrv = [average_hrv, temp_hrv];
    end
end
fitlm(average_hrv,average_annotations)
scatter(average_hrv,average_annotations)
    