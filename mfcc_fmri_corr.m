clear, clc

load('mfccs_sad_l.mat') % Load mfcc data. Note that it is row-oriented
load('mfccs_sad_s.mat')
load('mfccs_happy.mat')

path = 'ratings_fmri/';

%{
Each unique subject has 6 ratings:
1. Emotion - happy song
2. Enjoyment - happy song
3. Emotion - sad long song
4. Enjoyment - sd long song
5. Emotion - sad short song
6. Enjoyment - sad long song
%}
for k = 1:6
    switch k
       case 1
            mfcc_fmri_corrs(k).type = 'happy_emotion';
            directory = dir(strcat(path,'*_hnl_n_emo_log.txt'));
            MFCCs = full_MFCCs_happy';
       case 2
            mfcc_fmri_corrs(k).type = 'happy_enjoyment';
            directory = dir(strcat(path,'*_hnl_n_enjoy_log.txt'));
            MFCCs = full_MFCCs_happy';
       case 3
            mfcc_fmri_corrs(k).type = 'sad_long_emotion';
            directory = dir(strcat(path,'*_snl_l_emo_log.txt'));
            MFCCs = full_MFCCs_sad_l';
       case 4
            mfcc_fmri_corrs(k).type = 'sad_long_enjoyment';
            directory = dir(strcat(path,'*_snl_l_enjoy_log.txt'));
            MFCCs = full_MFCCs_sad_l';
       case 5
            mfcc_fmri_corrs(k).type = 'sad_short_emotion';
            directory = dir(strcat(path,'*_snl_s_emo_log.txt'));
            MFCCs = full_MFCCs_sad_s';
       case 6
            mfcc_fmri_corrs(k).type = 'sad_short_enjoyment';
            directory = dir(strcat(path,'*_snl_s_enjoy_log.txt'));
            MFCCs = full_MFCCs_sad_s';
    end
    
    %For the fmri ratings, there are 40 subjects
    for i = 1:40
      %First load the ratings (also stored in the struct under sub_data
      sec_col_data = load(strcat(path,directory(i).name));
      mfcc_fmri_corrs(k).sub_data{i} = sec_col_data;
      for j = 1:13
        %Perform analysis for each of the 13 MFCCs
        song_length = sec_col_data(end,1);
        %The 2 signals to be correlated are MFCC and the ratings
        mfcc = MFCCs(:,j);
        ratings = mfcc_fmri_corrs(k).sub_data{i}(:,2);
        %Truncate the first and last 20 seconds from both signals
        mfcc_first_index = ceil(length(mfcc)*(20/song_length));
        mfcc_last_index = floor(length(mfcc)*((song_length-20)/song_length));
        ratings_first_index = ceil(length(ratings)*(20/song_length));
        ratings_last_index = floor(length(ratings)*((song_length-20)/song_length));
        mfcc_tr = mfcc(mfcc_first_index:mfcc_last_index);
        ratings_tr = ratings(ratings_first_index:ratings_last_index);
        %{
        Resample the ratings signal to the sampling rate of the mfcc signal. Note 
        that resample downsamples and then interpolates to get to a non-integer 
        sampling rate
        %}
        ratings_rsmpld = resample(ratings_tr, length(mfcc_tr), length(ratings_tr));
        R = corrcoef(mfcc_tr,ratings_rsmpld);
        %Store the data for the subject
        mfcc_fmri_corrs(k).xcorr_by_sub{i}.mfcc{j} = xcorr(mfcc_tr, ratings_tr);
        mfcc_fmri_corrs(k).processed_mfcc_signals.sub{i}.mfcc{j} = mfcc_tr;
        mfcc_fmri_corrs(k).processed_rating_signals.sub{i}.mfcc{j} = ratings_rsmpld;
        mfcc_fmri_corrs(k).corrcoefs.sub{i}.mfcc{j} = R(1,2); 
      end
    end
end

%Averge correlation coefficients, first averaging over all the subjects
for t = 1:6
    for m = 1:13
        coeff_sum = 0;
        abs_coeff_sum = 0;
        for s = 1:40
            corr = mfcc_fmri_corrs(t).corrcoefs.sub{s}.mfcc{m};
            if isnan(corr)
               corr = 0; 
            end
            coeff_sum = coeff_sum + corr;
            abs_coeff_sum = abs_coeff_sum + abs(corr);
        end
        avg_coeff = coeff_sum/40;
        avg_abs_coeff = abs_coeff_sum/40;
        mfcc_fmri_corrs(t).corrcoef_avg_over_sub.mfcc{m} = avg_coeff;
        mfcc_fmri_corrs(t).abs_corrcoef_avg_over_sub.mfcc{m} = avg_abs_coeff;
    end
end

%Now averaging over the 13 MFCCs
for t = 1:6
    for s = 1:40
        coeff_sum = 0;
        abs_coeff_sum = 0;
        for m = 1:13
            corr = mfcc_fmri_corrs(t).corrcoefs.sub{s}.mfcc{m};
            if isnan(corr)
               corr = 0; 
            end
            coeff_sum = coeff_sum + corr;
            abs_coeff_sum = abs_coeff_sum + abs(corr);
        end
        avg_coeff = coeff_sum/13;
        avg_abs_coeff = abs_coeff_sum/13;
        mfcc_fmri_corrs(t).corrcoef_avg_over_mfcc.sub{s} = avg_coeff;
        mfcc_fmri_corrs(t).abs_corrcoef_avg_over_mfcc.sub{s} = avg_abs_coeff;
    end
end


%Create linreg models that can be plotted later
for t = 1:6
    for s = 1:40
        for m = 1:13
            s1 = mfcc_fmri_corrs(t).processed_mfcc_signals.sub{s}.mfcc{m};
            s2 = mfcc_fmri_corrs(t).processed_rating_signals.sub{s}.mfcc{m};
            mfcc_fmri_corrs(t).linreg_models.sub{s}.mfcc{m} = fitlm(s1,s2);
        end
    end
end

%Example: using the struct to find the correlation coefficient between 
%emotion ratings for the sad short song (Type 5) and the second MFCC, for
%the third subject 
mfcc_fmri_corrs(5).corrcoefs.sub{3}.mfcc{2}

%Example of using the struct to find the average correlation coefficient
%for the first MFCC for the sad short song (Type 6)
mfcc_fmri_corrs(6).corrcoef_avg_over_sub.mfcc{1}

%Linear Regression example for type 6, subject 3, mfcc 1
s1 = mfcc_fmri_corrs(6).processed_mfcc_signals.sub{3}.mfcc{1};
s2 = mfcc_fmri_corrs(6).processed_rating_signals.sub{3}.mfcc{1};
scatter(s1,s2)
hold on
model = mfcc_fmri_corrs(6).linreg_models.sub{3}.mfcc{1};
ce = model.Coefficients.Estimate;
y = ce(2)*s1 + ce(1);
plot(s1,y)