function [ibis,avg_anns] = ibi_analysis(ibi_data,ann_type)
    close all
    ibis = zeros(length(ibi_data(ann_type).sub),length(ibi_data(ann_type).sub(1).section));
    for i=1:length(ibi_data(ann_type).sub)
        for j=1:length(ibi_data(ann_type).sub(i).section)
            ibis(i,j) = std(ibi_data(ann_type).sub(i).section(j).ibi_signal);
        end
    end
    avg_anns = zeros(length(ibi_data(ann_type).sub),length(ibi_data(ann_type).sub(1).section));
    for i=1:length(ibi_data(ann_type).sub)
        for j=1:length(ibi_data(ann_type).sub(i).section)
            avg_anns(i,j) = mean(ibi_data(ann_type).sub(i).section(j).ratings_signal);
        end
    end
    subplot(2,1,1)
    plot(1:length(mean(avg_anns,1)),mean(avg_anns,1))
    subplot(2,1,2)
    plot(1:length(mean(ibis,1)),mean(ibis,1))
    