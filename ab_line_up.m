%Note: Some ratings are not available. Example: Participant 0117EG_AY only
%has ratings for emotion for the short sad song.
%Also note: some files may be empty, such as 1108BS_AY_snl_s_emo_log.txt
 
clear, clc

load('data_sad_s_full_song_25.mat') % Load mfcc data. Note that it is row-oriented
load('data_sad_l_full_song_25.mat')
load('data_happy_full_song_25.mat')
load('lpcs_sad_s_25.mat') % Load mfcc data. Note that it is row-oriented
load('lpcs_sad_l_25.mat')
load('lpcs_happy_25.mat')
compress_happy = load('compressibilities_hnl_norm_25.csv');
compress_sad_s = load('compressibilities_snl_s_norm_25.csv');
compress_sad_l = load('compressibilities_snl_l_norm_25.csv');

path = 'ratings_behav/'; %Set path to the emotion and enjoyment ratings

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
    subject = char(sub_list(i));
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
    for k = 1:6
        switch k
           case 1
                mfcc_behav_corrs(k).type = 'happy_emotion';
                ratings_ext = '_hnl_n_emo_log.txt';
                MFCCs = MFCCs_happy';
                MFCCs_d = MFCCs_happy_del';
                MFCCs_dd = MFCCs_happy_double_del';
                clarity  = clarity_happy_st';
                brightness  = brightness_happy_st';
                zc  = zc_happy_st';
                key_strength = key_strength_happy_st_max';
                rmses = rms_happy_st';
                centroid = centroid_happy_st';
                spread = spread_happy_st';
                skewness = skewness_happy_st';
                kurtosis = kurtosis_happy_st';
                chroma = chroma_happy_st';
                mode = mode_happy_st';
                compress = compress_happy;
                hcdf = hcdf_happy_st';
                flux = flux_happy_st';
                lpcs = lpcs_happy;
           case 2
                mfcc_behav_corrs(k).type = 'happy_enjoyment';
                ratings_ext = '_hnl_n_enjoy_log.txt';
                MFCCs = MFCCs_happy';
                MFCCs_d = MFCCs_happy_del';
                MFCCs_dd = MFCCs_happy_double_del';
                clarity  = clarity_happy_st';
                brightness  = brightness_happy_st';
                zc  = zc_happy_st';
                key_strength = key_strength_happy_st_max';
                rmses = rms_happy_st';
                centroid = centroid_happy_st';
                spread = spread_happy_st';
                skewness = skewness_happy_st';
                kurtosis = kurtosis_happy_st';
                chroma = chroma_happy_st';
                mode = mode_happy_st';
                compress = compress_happy;
                hcdf = hcdf_happy_st';
                flux = flux_happy_st';
                lpcs = lpcs_happy;
           case 3
                mfcc_behav_corrs(k).type = 'sad_long_emotion';
                ratings_ext = '_snl_l_emo_log.txt';
                MFCCs = MFCCs_sad_l';
                MFCCs_d = MFCCs_sad_l_del';
                MFCCs_dd = MFCCs_sad_l_double_del';
                clarity  = clarity_sad_l_st';
                brightness  = brightness_sad_l_st';
                zc  = zc_sad_l_st';
                key_strength = key_strength_sad_l_st_max';
                rmses = rms_sad_l_st';
                centroid = centroid_sad_l_st';
                spread = spread_sad_l_st';
                skewness = skewness_sad_l_st';
                kurtosis = kurtosis_sad_l_st';
                chroma = chroma_sad_l_st';
                mode = mode_sad_l_st';
                compress = compress_sad_l;
                hcdf = hcdf_sad_l_st';
                flux = flux_sad_l_st';
                lpcs = lpcs_sad_l;
           case 4
                mfcc_behav_corrs(k).type = 'sad_long_enjoyment';
                ratings_ext = '_snl_l_enjoy_log.txt';
                MFCCs = MFCCs_sad_l';
                MFCCs_d = MFCCs_sad_l_del';
                MFCCs_dd = MFCCs_sad_l_double_del';
                clarity  = clarity_sad_l_st';
                brightness  = brightness_sad_l_st';
                zc  = zc_sad_l_st';
                key_strength = key_strength_sad_l_st_max';
                rmses = rms_sad_l_st';
                centroid = centroid_sad_l_st';
                spread = spread_sad_l_st';
                skewness = skewness_sad_l_st';
                kurtosis = kurtosis_sad_l_st';
                chroma = chroma_sad_l_st';
                mode = mode_sad_l_st';
                compress = compress_sad_l;
                hcdf = hcdf_sad_l_st';
                flux = flux_sad_l_st';
                lpcs = lpcs_sad_l;
           case 5
                mfcc_behav_corrs(k).type = 'sad_short_emotion';
                ratings_ext = '_snl_s_emo_log.txt';
                MFCCs = MFCCs_sad_s';
                MFCCs_d = MFCCs_sad_s_del';
                MFCCs_dd = MFCCs_sad_s_double_del';
                clarity  = clarity_sad_s_st';
                brightness  = brightness_sad_s_st';
                zc  = zc_sad_s_st';
                key_strength = key_strength_sad_s_st_max';
                rmses = rms_sad_s_st';
                centroid = centroid_sad_s_st';
                spread = spread_sad_s_st';
                skewness = skewness_sad_s_st';
                kurtosis = kurtosis_sad_s_st';
                chroma = chroma_sad_s_st';
                mode = mode_sad_s_st';
                compress = compress_sad_s;
                hcdf = hcdf_sad_s_st';
                flux = flux_sad_s_st';
                lpcs = lpcs_sad_s;
           case 6
                mfcc_behav_corrs(k).type = 'sad_short_enjoyment';
                ratings_ext = '_snl_s_enjoy_log.txt';
                MFCCs = MFCCs_sad_s';
                MFCCs_d = MFCCs_sad_s_del';
                MFCCs_dd = MFCCs_sad_s_double_del';
                clarity  = clarity_sad_s_st';
                brightness  = brightness_sad_s_st';
                zc  = zc_sad_s_st';
                key_strength = key_strength_sad_s_st_max';
                rmses = rms_sad_s_st';
                centroid = centroid_sad_s_st';
                spread = spread_sad_s_st';
                skewness = skewness_sad_s_st';
                kurtosis = kurtosis_sad_s_st';
                chroma = chroma_sad_s_st';
                mode = mode_sad_s_st';
                compress = compress_sad_s;
                hcdf = hcdf_sad_s_st';
                flux = flux_sad_s_st';
                lpcs = lpcs_sad_s;
         end
        
        directory = dir(strcat(path, subject, ratings_ext));
        if ~isempty(directory)
          mfcc_behav_corrs(k).sub_info{i}.data = load(strcat(path,directory.name));
          mfcc_behav_corrs(k).sub_info{i}.id = subject;
          if isempty(mfcc_behav_corrs(k).sub_info{i}.data)
             mfcc_behav_corrs(k).processed_mfcc_signals.sub{i}.mfcc{1} = [];
             mfcc_behav_corrs(k).processed_rating_signals.sub{i}.mfcc{1} = [];
          else
            %Perform analysis for each of the 13 MFCCs
            song_length = mfcc_behav_corrs(k).sub_info{i}.data(end,1);
            %The 2 signals to be correlated are MFCC and the ratings
            mfcc = MFCCs(:,:);
            ratings = mfcc_behav_corrs(k).sub_info{i}.data(:,2);
            %Truncate the first kkk seconds from both signals
            kkk = 20;
            mfcc_first_index = ceil(length(mfcc)*(kkk/song_length));
            %mfcc_last_index = floor(length(mfcc)*((song_length-kkk)/song_length));
            mfcc_last_index = length(mfcc);
            ratings_first_index = ceil(length(ratings)*(kkk/song_length));
            ratings_last_index = length(ratings);
            mfcc_tr = mfcc(mfcc_first_index:mfcc_last_index);



            %TODO: Put in other measures!
            mfcc_tr = mfcc(mfcc_first_index:mfcc_last_index,:);
            mfcc_d_tr = MFCCs_d(mfcc_first_index:mfcc_last_index,:);
            mfcc_dd_tr = MFCCs_dd(mfcc_first_index:mfcc_last_index,:);
            clarity_tr  = clarity(mfcc_first_index:mfcc_last_index);
            brightness_tr  = brightness(mfcc_first_index:mfcc_last_index);
            zc_tr  = zc(mfcc_first_index:mfcc_last_index);
            key_strength_tr  = key_strength(mfcc_first_index:mfcc_last_index);
            rmses_tr  = rmses(mfcc_first_index:mfcc_last_index);
            centroid_tr  = centroid(mfcc_first_index:mfcc_last_index);
            spread_tr  = spread(mfcc_first_index:mfcc_last_index);
            skewness_tr  = skewness(mfcc_first_index:mfcc_last_index);
            kurtosis_tr  = kurtosis(mfcc_first_index:mfcc_last_index);
            chroma_tr  = chroma(mfcc_first_index:mfcc_last_index,:);
            mode_tr = mode(mfcc_first_index:mfcc_last_index);
            compress_tr = compress(mfcc_first_index:mfcc_last_index);
            hcdf_tr = hcdf(mfcc_first_index:mfcc_last_index);
            flux_tr = flux(mfcc_first_index:mfcc_last_index);
            lpcs_tr = lpcs(mfcc_first_index:mfcc_last_index,:);

            ratings_tr = ratings(ratings_first_index:ratings_last_index);
            %{
            Resample the ratings signal to the sampling rate of the mfcc signal. Note 
            that resample *upsamples* and then interpolates to get to a non-integer 
            sampling rate
            %}
            ratings_rsmpld = resample(ratings_tr, length(mfcc_tr), length(ratings_tr));
            %Store the data for the subject
            mfcc_behav_corrs(k).processed_rating_signals.sub{i}.mfcc{1} = ratings_rsmpld;
            mfcc_behav_corrs(k).processed_mfcc_signals.sub{i}.mfcc{1} = mfcc_tr;

            %TODO: Save other measures!
            mfcc_behav_corrs(k).processed_mfcc_signals.sub{i}.mfcc{1} = mfcc_tr;
            mfcc_behav_corrs(k).processed_mfcc_d_signals.sub{i}.mfcc{1} = mfcc_d_tr;
            mfcc_behav_corrs(k).processed_mfcc_dd_signals.sub{i}.mfcc{1} = mfcc_dd_tr;
            mfcc_behav_corrs(k).processed_clarity_signals.sub{i}.mfcc{1} = clarity_tr;
            mfcc_behav_corrs(k).processed_brightness_signals.sub{i}.mfcc{1} = brightness_tr;
            mfcc_behav_corrs(k).processed_key_strength_signals.sub{i}.mfcc{1} = key_strength_tr;
            mfcc_behav_corrs(k).processed_rms_signals.sub{i}.mfcc{1} = rmses_tr;
            mfcc_behav_corrs(k).processed_centroid_signals.sub{i}.mfcc{1} = centroid_tr;
            mfcc_behav_corrs(k).processed_spread_signals.sub{i}.mfcc{1} = spread_tr;
            mfcc_behav_corrs(k).processed_skewness_signals.sub{i}.mfcc{1} = skewness_tr;
            mfcc_behav_corrs(k).processed_kurtosis_signals.sub{i}.mfcc{1} = kurtosis_tr;
            mfcc_behav_corrs(k).processed_chroma_signals.sub{i}.mfcc{1} = chroma_tr;
            mfcc_behav_corrs(k).processed_mode_signals.sub{i}.mfcc{1} = mode_tr;
            mfcc_behav_corrs(k).processed_compression_signals.sub{i}.mfcc{1} = compress_tr;
            mfcc_behav_corrs(k).processed_hcdf_signals.sub{i}.mfcc{1} = hcdf_tr;
            mfcc_behav_corrs(k).processed_flux_signals.sub{i}.mfcc{1} = flux_tr;
            mfcc_behav_corrs(k).processed_lpcs_signals.sub{i}.mfcc{1} = lpcs_tr;
           end
        else
            mfcc_behav_corrs(k).sub_info{i}.id = subject;
        end
    end
end




%mfcc_behav_corrs(1).processed_rating_signals.sub{1,i}.mfcc{1,1}
