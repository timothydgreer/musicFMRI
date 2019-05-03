function above_thresh_peak_inds = find_spikes(new_signal,thresh,plotTrue,songLength)
    if ~exist('songLength','var')
        % songLength does not exist, so default it to something
        songLength = length(new_signal);
    end
    above_thresh = find(new_signal>thresh,2000000000);
    [pks,locs] = findpeaks(new_signal,1:length(new_signal));
    above_thresh_peak_inds = intersect(locs,above_thresh);
    if plotTrue == true
        plot(above_thresh_peak_inds*songLength/length(new_signal),1:length(above_thresh_peak_inds))
    end
end