function plot_segments(songChoice)
    for i = 1:length(songChoice)
        line([songChoice(i), songChoice(i)], [0,127],'color','r')
    end

end