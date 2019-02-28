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
            
            for k=1:length(section_timestamps)
                if k ~= length(section_timestamps)
                    [a,first_sect_index] = min(abs(timestamps - section_timestamps(k)));
                    [a,last_sect_index] = min(abs(timestamps - section_timestamps(k+1)));
                    [b,first_ibi_index] = min(abs(raw_ibi_time - section_timestamps(k)));
                    [b,last_ibi_index] = min(abs(raw_ibi_time - section_timestamps(k+1)));
                else
                    [a,first_sect_index] = min(abs(timestamps - section_timestamps(k)));
                    last_sect_index = length(ratings);
                    [b,first_ibi_index] = min(abs(raw_ibi_time - section_timestamps(k)));
                    last_ibi_index = length(raw_ibi_time);
                end
            
                section_ratings = ratings(first_sect_index:last_sect_index);
                %Check for sampling error
                if isempty(section_ratings)
                   ibi_data(j).sub(i).error = 1;
                   reset_index = find(diff(timestamps)<0);
                   timestamps = timestamps(reset_index+1:end);
                   ratings = ratings(reset_index+1:end);
                   [a,first_sect_index] = min(abs(timestamps - section_timestamps(k)));
                   [a,last_sect_index] = min(abs(timestamps - section_timestamps(k+1)));
                   [b,first_ibi_index] = min(abs(raw_ibi_time - section_timestamps(k)));
                   [b,last_ibi_index] = min(abs(raw_ibi_time - section_timestamps(k+1)));
                   section_ratings = ratings(first_sect_index:last_sect_index);
                end
                section_ibi_time = raw_ibi_time(first_ibi_index:last_ibi_index);
            
                intervals = diff(section_ibi_time);%First calculate the actual interbeat intervals
                if isempty(intervals)
                   intervals = 0; 
                end
                hrv = movstd(intervals, [window_size 0]);%movestd uses a moving window 
                hrv_section = std(intervals);
                ratings_rsmpld = resample(section_ratings, length(hrv), length(section_ratings));
                %{
                Resample the ratings signal to the sampling rate of the hrv signal. Note 
                that resample downsamples and then interpolates to get to a non-integer 
                sampling rate
                %}
                R = corrcoef(ratings_rsmpld, hrv);
                %Store the data for the subject
                ibi_data(j).sub(i).id = subject;%Unique identifier for each subject 
                ibi_data(j).sub(i).section(k).xcorr = xcorr(section_ratings, hrv);
                %Adjust for sections that are shorter than the sampling
                %rate
                if length(R) == 2
                    ibi_data(j).sub(i).section(k).corrcoef = R(1,2);
                else
                    ibi_data(j).sub(i).section(k).corrcoef = NaN; 
                end
                ibi_data(j).sub(i).section(k).ratings_signal = section_ratings;
                ibi_data(j).sub(i).section(k).ratings_resampled = ratings_rsmpld;
                ibi_data(j).sub(i).section(k).hrv_windowed = hrv; 
                ibi_data(j).sub(i).section(k).hrv_section = hrv_section;
                ibi_data(j).sub(i).section(k).ibi_signal = intervals;
                ibi_data(j).sub(i).section(k).average_ibi = mean(intervals);
            end
            ibi_data(j).sub(i).full_timestamps = timestamps;
            ibi_data(j).sub(i).full_ratings = ratings;
        else
        ibi_data(j).sub(i).id = subject;
        end
        ibi_data(j).section_timestamps = section_timestamps;
    end
end

%Find the average ratings signal over all partipants for each of the 6
%experiments

%Requires resampling all the signals to the lowest number of samples among
%all subjects

%Note that some of the subjects did not have recorded data for all 6
%experiments, so there are some empty arrays that need to be taken care of

for type = 1:6

    num_subjects = length(ibi_data(type).sub);

    %Find the shortest ratings signal
    smallest_num_samples = inf;
    smallest_timestamps = [];
    num_empty_subjects = 0;
    for i = 1:num_subjects
        len = length(ibi_data(type).sub(i).full_ratings);
        if len < 2000 %Less than 2000 samples should indicate a sampling error
            num_empty_subjects = num_empty_subjects+1;
        else
           if len < smallest_num_samples
               smallest_num_samples = len;
               smallest_timestamps = ibi_data(type).sub(i).full_timestamps;
           end
        end
    end

    %Resample everything and average
    sum_ratings = zeros(smallest_num_samples,1);
    sum_hrv = zeros(length(ibi_data(type).section_timestamps),1);
    for i = 1:num_subjects
       full_ratings = ibi_data(type).sub(i).full_ratings; 
       if ~isempty(full_ratings)
          ibi_data(type).sub(i).resampled_full_ratings = resample(full_ratings, smallest_num_samples ,length(full_ratings));
          sum_ratings = sum_ratings + ibi_data(type).sub(i).resampled_full_ratings;
          sum_hrv = sum_hrv + [ibi_data(type).sub(10).section(:).hrv_section]';
       else
          ibi_data(type).sub(i).empty = 1;
          ibi_data(type).sub(i).resampled_full_ratings = zeros(smallest_num_samples,1);
       end
    end

    average_ratings = sum_ratings/(num_subjects - num_empty_subjects);
    average_hrv = sum_hrv/(num_subjects - num_empty_subjects);
    ibi_data(type).average_ratings = average_ratings;
    ibi_data(type).average_section_hrv = average_hrv;
    ibi_data(type).smallest_timestamps = smallest_timestamps;
end

%Sample normalized plots

type = 2;

figure(1)
hold on
x1 = ibi_data(type).section_timestamps;
y1 = ibi_data(type).average_section_hrv;
plot(x1,y1/max(y1))
x2 = ibi_data(type).smallest_timestamps;
y2 = ibi_data(type).average_ratings;
plot(x2,y2/max(y2))
