%Note: the main struct where everything is stored is called
%hrv_corrs

clear, clc

ratings_path = 'ratings_behav/'; %Set path to the emotion and enjoyment ratings
ibi_path = 'ecg_peaks_ibi/'; %Set path to the raw ecg peak data
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
            case 2
              type = 'happy_enjoyment';
              ratings_ext = '_hnl_n_enjoy_log.txt';
              ibi_ext = '_hnl_enjoy_ecg_peaks.txt';
            case 3
              type = 'sad_long_emotion';
              ratings_ext = '_snl_l_emo_log.txt';
              ibi_ext = '_snl_l_emo_ecg_peaks.txt';
            case 4
              type = 'sad_long_enjoyment';
              ratings_ext = '_snl_l_enjoy_log.txt';
              ibi_ext = '_snl_l_enjoy_ecg_peaks.txt'; 
            case 5
              type = 'sad_short_emotion';
              ratings_ext = '_snl_s_emo_log.txt';
              ibi_ext = '_snl_s_emo_ecg_peaks.txt';
            case 6
              type = 'sad_short_enjoyment';
              ratings_ext = '_snl_s_enjoy_log.txt';
              ibi_ext = '_snl_s_enjoy_ecg_peaks.txt'; 
        end
        
        %Create struct to store data
        hrv_corrs(j).type = type; 
        %Get both ibi peak data and ratings data
        directory = dir(strcat(ratings_path, subject, ratings_ext));
        if ~isempty(directory)
            labels = load(strcat(ratings_path,directory.name)); 
            ratings = labels(:,2);
            timestamps = labels(:,1);
            song_length = timestamps(end);
            directory = dir(strcat(ibi_path, subject, ibi_ext));
            raw_ibi_time = load(strcat(ibi_path,directory.name));
            %Truncate the first and last 20 seconds from both signals
            ibi_first_index = ceil(length(raw_ibi_time)*(20/song_length));
            ibi_last_index = floor(length(raw_ibi_time)*((song_length-20)/song_length));
            ratings_first_index = ceil(length(ratings)*(20/song_length));
            ratings_last_index = floor(length(ratings)*((song_length-20)/song_length));
            ibi_tr = raw_ibi_time(ibi_first_index:ibi_last_index);
            ratings_tr = ratings(ratings_first_index:ratings_last_index);
            %Calculate hrv from ibi
            intervals = diff(ibi_tr);%First calculate the actual interbeat intervals
            hrv = movstd(intervals, [window_size 0]);%movestd uses a moving window 
            ratings_rsmpld = resample(ratings_tr, length(hrv), length(ratings_tr));
            %{
            Resample the ratings signal to the sampling rate of the hrv signal. Note 
            that resample downsamples and then interpolates to get to a non-integer 
            sampling rate
            %}
            R = corrcoef(ratings_rsmpld, hrv);
            %Store the data for the subject
            hrv_corrs(j).sub(i).id = subject;%Unique identifier for each subject 
            hrv_corrs(j).sub(i).xcorr = xcorr(ratings_tr, hrv);
            hrv_corrs(j).sub(i).corrcoef = R(1,2);
            hrv_corrs(j).sub(i).ratings_signal = ratings_tr;
            hrv_corrs(j).sub(i).ratings_resampled = ratings_rsmpld;
            hrv_corrs(j).sub(i).hrv_signal = hrv; 
        else
        hrv_corrs(j).sub(i).id = subject;
        end
    end
end

%{
Calculate the average correlations across all subjects for each of the 6
different ratings that each gave
%}
for i = 1:6
   count = 0;
   coeff_sum = 0;
   abs_coeff_sum = 0;
   %{
   Note that not all ratings are available for every subject, so we don't 
   to count those that we don't have data for (these subjects have empty
   empty cells for their correlations
   %}
   for j = 1:length(hrv_corrs(i).sub)
       coeff = hrv_corrs(i).sub(j).corrcoef;
       if isnan(coeff)
        count = count + 1;
       elseif isempty(coeff)   
       else
        count = count + 1;
        coeff_sum = coeff_sum + coeff;
        abs_coeff_sum = abs_coeff_sum + abs(coeff);
       end
   end
   %Average correlation coefficient, as well as the average absolution
   %correlation coefficient
   hrv_corrs(i).corrcoeff_avg_over_subjects = coeff_sum/count;
   hrv_corrs(i).abs_corrcoeff_avg_over_subjects = abs_coeff_sum/count;
end

%{
Example using the struct to plot signals for emotion for the sad long song
(Type 3) for the fifth subject
%}
signal1 = hrv_corrs(3).sub(5).ratings_signal;
signal2 = hrv_corrs(3).sub(5).ratings_resampled;
signal3 = hrv_corrs(3).sub(5).hrv_signal;
figure(1)
plot(signal1)
figure(2)
plot(signal2)
figure(3)
plot(signal3)

