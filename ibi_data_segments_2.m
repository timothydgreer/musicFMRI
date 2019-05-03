%Note: the main struct where everything is stored is called
%ibi_data

clear, clc

ratings_path = 'ratings_behav/'; %Set path to the emotion and enjoyment ratings
ibi_path = 'ecg_peaks_ibi/'; %Set path to the raw ecg peak data
[ss_timestamps,txt,raw] = xlsread('Segmentations.xlsx', 'A:A');
[num,ss_sections,raw] = xlsread('Segmentations.xlsx', 'B:B');
[sl_timestamps,txt,raw] = xlsread('Segmentations.xlsx', 'C:C');
[num,sl_sections,raw] = xlsread('Segmentations.xlsx', 'D:D');
[h_timestamps,txt,raw] = xlsread('Segmentations.xlsx', 'E:E');
[num,h_sections,raw] = xlsread('Segmentations.xlsx', 'F:F');
window_size = 10; %Set the window size that will be used to calculate hrv later

files = dir(ibi_path); 
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
    %{
    Each unique subject has 6 ratings:
    1. Emotion - happy song
    2. Enjoyment - happy song
    3. Emotion - sad long song
    4. Enjoyment - sd long song
    5. Emotion - sad short song
    6. Enjoyment - sad long song
    %}
    subject = char(sub_list(i));
    for j = 1:6
        switch j
            case 1
              type = 'happy_emotion';
              ratings_ext = '_hnl_n_emo_log.txt';
              ibi_ext = '_hnl_emo_ecg_peaks.txt';
              section_timestamps = h_timestamps;
              section_names = h_sections;
            case 2
              type = 'happy_enjoyment';
              ratings_ext = '_hnl_n_enjoy_log.txt';
              ibi_ext = '_hnl_enjoy_ecg_peaks.txt';
              section_timestamps = h_timestamps;
              section_names = h_sections;
            case 3
              type = 'sad_long_emotion';
              ratings_ext = '_snl_l_emo_log.txt';
              ibi_ext = '_snl_l_emo_ecg_peaks.txt';
              section_timestamps = sl_timestamps;
              section_names = sl_sections;
            case 4
              type = 'sad_long_enjoyment';
              ratings_ext = '_snl_l_enjoy_log.txt';
              ibi_ext = '_snl_l_enjoy_ecg_peaks.txt'; 
              section_timestamps = sl_timestamps;
              section_names = sl_sections;
            case 5
              type = 'sad_short_emotion';
              ratings_ext = '_snl_s_emo_log.txt';
              ibi_ext = '_snl_s_emo_ecg_peaks.txt';
              section_timestamps = ss_timestamps;
              section_names = ss_sections;
            case 6
              type = 'sad_short_enjoyment';
              ratings_ext = '_snl_s_enjoy_log.txt';
              ibi_ext = '_snl_s_enjoy_ecg_peaks.txt'; 
              section_timestamps = ss_timestamps;
              section_names = ss_sections;
        end
        
        %Create struct to store data
        ibi_data(j).type = type; 
        %Get both ibi peak data and ratings data
        directory = dir(strcat(ratings_path, subject, ratings_ext));
        if ~isempty(directory)
            labels = load(strcat(ratings_path,directory.name)); 
            ratings = labels(:,2);
            timestamps = labels(:,1);
            song_length = timestamps(end);
            directory = dir(strcat(ibi_path, subject, ibi_ext));
            raw_ibi_time = load(strcat(ibi_path,directory.name));
            %Calculate hrv from ibi
            section_ratings = ratings;
            
           
            %Check for sampling error
            if isempty(section_ratings)
               section_ratings = 0; 
               ibi_data(j).sub(i).error = 1;
            end

            intervals = diff(raw_ibi_time);%First calculate the actual interbeat intervals
            if isempty(intervals)
               intervals = 0; 
            end
            hrv = movstd(intervals, [window_size 0]);%movestd uses a moving window 
            ratings_rsmpld = resample(section_ratings, length(hrv), length(section_ratings));
            %{
            Resample the ratings signal to the sampling rate of the hrv signal. Note 
            that resample downsamples and then interpolates to get to a non-integer 
            sampling rate
            %}
            R = corrcoef(ratings_rsmpld, hrv);
            %Store the data for the subject
            ibi_data(j).sub(i).id = subject;%Unique identifier for each subject 
            ibi_data(j).sub(i).xcorr = xcorr(section_ratings, hrv);
            %Adjust for sections that are shorter than the sampling
            %rate
            if length(R) == 2
                ibi_data(j).sub(i).corrcoef = R(1,2);
            else
                ibi_data(j).sub(i).corrcoef = NaN; 
            end
            ibi_data(j).sub(i).ratings_signal = section_ratings;
            ibi_data(j).sub(i).timestamps = section_timestamps;
            ibi_data(j).sub(i).ratings_resampled = ratings_rsmpld;
            ibi_data(j).sub(i).hrv_signal = hrv; 
            ibi_data(j).sub(i).ibi_signal = intervals;
            ibi_data(j).sub(i).average_ibi = mean(intervals);
            ibi_data(j).sub(i).raw_peaks = raw_ibi_time;
        else
        ibi_data(j).sub(i).id = subject;
        end
    end
end

ibi_only1 = [];
ibi_only2 = [];
ibi_only3 = [];
ibi_only4 = [];
ibi_only5 = [];
ibi_only6 = [];
for j = 1:length(ibi_data(1).sub)
    ibi_only1 = [ibi_only1, ibi_data(1).sub(j).raw_peaks'];
end
for j = 1:length(ibi_data(1).sub)
    ibi_only2 = [ibi_only2, ibi_data(2).sub(j).raw_peaks'];
end
for j = 1:length(ibi_data(1).sub)
    ibi_only3 = [ibi_only3, ibi_data(3).sub(j).raw_peaks'];
end
for j = 1:length(ibi_data(1).sub)
    ibi_only4 = [ibi_only4, ibi_data(4).sub(j).raw_peaks'];
end
for j = 1:length(ibi_data(1).sub)
    ibi_only5 = [ibi_only5, ibi_data(5).sub(j).raw_peaks'];
end
for j = 1:length(ibi_data(1).sub)
    ibi_only6 = [ibi_only6, ibi_data(6).sub(j).raw_peaks'];
end
ibi_only1 = sort(ibi_only1);
ibi_only2 = sort(ibi_only2);
ibi_only3 = sort(ibi_only3);
ibi_only4 = sort(ibi_only4);
ibi_only5 = sort(ibi_only5);
ibi_only6 = sort(ibi_only6);
