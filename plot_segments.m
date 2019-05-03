function plot_segments(songChoice,myMax,myColor)
    for i = 1:length(songChoice)
        line([songChoice(i), songChoice(i)], [0,myMax],'color',myColor)
    end
end