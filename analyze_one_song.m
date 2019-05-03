function analyze_one_song(myFile)
    load(myFile);
    load('compressibilities_and_markers.mat');
    spikes = find_spikes(data(:,2),.1,1,256);
    myMax = length(spikes);
    plot_segments(sad_s_song_instruments,myMax,'g')
    plot_segments(sad_s_song_segment_points,myMax,'r')
end
