function above_thresh_peak_inds = find_spikes(new_signal,thresh,plotTrue)
    above_thresh = find(new_signal>thresh,2000000000);
    [pks,locs] = findpeaks(new_signal,1:length(new_signal));
    above_thresh_peak_inds = intersect(locs,above_thresh);
    if plotTrue == true
        plot(1:length(above_thresh_peak_inds),above_thresh_peak_inds)
    end
end