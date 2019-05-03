%Note: Some ratings are not available. Example: Participant 0117EG_AY only
%has ratings for emotion for the short sad song.
%Also note: some files may be empty, such as 1108BS_AY_snl_s_emo_log.txt
 
clear, clc

path = 'biopac_baselines/'; %Set path to the emotion and enjoyment ratings

files = dir(path); 
%{
Find all unique subjects. Note that there is a discrepancy between the number 
of files in the ratings_behav folder (360) and the ecg_peaks_ibi folder, so
the smaller of the two was used to build the list of unique subjects.
%}
sub_list = {};
for file = files'
    if ~(file.isdir) && ~(ismember(file.name(1:9),sub_list))
       sub_list = [sub_list; file.name(1:9)];
    end
end

for i = 1:length(sub_list)
    %subject is the name of the person    
    subject = char(sub_list(i));
    
    ext = '_baseline.mat';
    directory = dir(strcat(path, subject, ext));
    load(strcat(path, subject, ext));
    baselines(i).id = subject;
    baselines(i).scr = acq.data(:,1);
    baselines(i).heartrate = acq.data(:,2);
    front_cut = floor(length(acq.data(:,1))/10);
    back_cut = length(acq.data(:,1))-floor(length(acq.data(:,1))/10);
    
    %Get baseline peak rates
    %May need to mess around with this threshold
    temp_whitened = (acq.data(front_cut:back_cut,1)-mean(acq.data(front_cut:back_cut,1)))/std(acq.data(front_cut:back_cut,1));
    baselines(i).scr_peaks = find_spikes(temp_whitened,1,0);
    baselines(i).lambda = length(baselines(i).scr_peaks)/(back_cut-front_cut)*1000;
end




%mfcc_behav_corrs(1).processed_rating_signals.sub{1,i}.mfcc{1,1}
