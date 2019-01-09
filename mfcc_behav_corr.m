%Note: Some ratings are not available. Example: Participant 0117EG_AY only
%has ratings for emotion for the short sad song.
%Also note: some files may be empty, such as 1108BS_AY_snl_s_emo_log.txt

clear, clc

load('mfccs_sad_l.mat') % Load mfcc data. Note that it is row-oriented
load('mfccs_sad_s.mat')
load('mfccs_happy.mat')

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
                MFCCs = full_MFCCs_happy';
           case 2
                mfcc_behav_corrs(k).type = 'happy_enjoyment';
                ratings_ext = '_hnl_n_enjoy_log.txt';
                MFCCs = full_MFCCs_happy';
           case 3
                mfcc_behav_corrs(k).type = 'sad_long_emotion';
                ratings_ext = '_snl_l_emo_log.txt';
                MFCCs = full_MFCCs_sad_l';
           case 4
                mfcc_behav_corrs(k).type = 'sad_long_enjoyment';
                ratings_ext = '_snl_l_enjoy_log.txt';
                MFCCs = full_MFCCs_sad_l';
           case 5
                mfcc_behav_corrs(k).type = 'sad_short_emotion';
                ratings_ext = '_snl_s_emo_log.txt';
                MFCCs = full_MFCCs_sad_s';
           case 6
                mfcc_behav_corrs(k).type = 'sad_short_enjoyment';
                ratings_ext = '_snl_s_enjoy_log.txt';
                MFCCs = full_MFCCs_sad_s';
         end
        
        directory = dir(strcat(path, subject, ratings_ext));
        if ~isempty(directory)
          mfcc_behav_corrs(k).sub_info{i}.data = load(strcat(path,directory.name));
          mfcc_behav_corrs(k).sub_info{i}.id = subject;
          for j = 1:13
              if isempty(mfcc_behav_corrs(k).sub_info{i}.data)
                 mfcc_behav_corrs(k).xcorr_by_sub{i}.mfcc{j} = [];
                 mfcc_behav_corrs(k).processed_mfcc_signals.sub{i}.mfcc{j} = [];
                 mfcc_behav_corrs(k).processed_rating_signals.sub{i}.mfcc{j} = [];
                 mfcc_behav_corrs(k).corrcoefs.sub{i}.mfcc{j} = []; 
              else
                %Perform analysis for each of the 13 MFCCs
                song_length = mfcc_behav_corrs(k).sub_info{i}.data(end,1);
                %The 2 signals to be correlated are MFCC and the ratings
                mfcc = MFCCs(:,j);
                ratings = mfcc_behav_corrs(k).sub_info{i}.data(:,2);
                %Truncate the first and last 20 seconds from both signals
                mfcc_first_index = ceil(length(mfcc)*(20/song_length));
                mfcc_last_index = floor(length(mfcc)*((song_length-20)/song_length));
                ratings_first_index = ceil(length(ratings)*(20/song_length));
                ratings_last_index = floor(length(ratings)*((song_length-20)/song_length));
                mfcc_tr = mfcc(mfcc_first_index:mfcc_last_index);
                ratings_tr = ratings(ratings_first_index:ratings_last_index);
                %{
                Resample the ratings signal to the sampling rate of the mfcc signal. Note 
                that resample *upsamples* and then interpolates to get to a non-integer 
                sampling rate
                %}
                ratings_rsmpld = resample(ratings_tr, length(mfcc_tr), length(ratings_tr));
                R = corrcoef(mfcc_tr,ratings_rsmpld);
                %Store the data for the subject
                mfcc_behav_corrs(k).xcorr_by_sub{i}.mfcc{j} = xcorr(mfcc_tr, ratings_tr);
                mfcc_behav_corrs(k).processed_mfcc_signals.sub{i}.mfcc{j} = mfcc_tr;
                mfcc_behav_corrs(k).processed_rating_signals.sub{i}.mfcc{j} = ratings_rsmpld;
                mfcc_behav_corrs(k).corrcoefs.sub{i}.mfcc{j} = R(1,2); 
              end
           end
        else
            mfcc_behav_corrs(k).sub_info{i}.id = subject;
        end
    end
end

%Get average ratings
avg_ratings_5 = zeros(63,8638);
avg_ratings_6 = zeros(63,8638);
discount5 = 0;
discount6 = 0;

for i = 1:length(mfcc_behav_corrs(5).processed_rating_signals.sub)
    if isempty(mfcc_behav_corrs(5).processed_rating_signals.sub{i})
        discount5 = discount5+1;
        continue
    end
    if length(mfcc_behav_corrs(5).processed_rating_signals.sub{i}.mfcc{1}) < 8638
        discount5 = discount5+1;
        continue
    end
    avg_ratings5(i,:) = mfcc_behav_corrs(5).processed_rating_signals.sub{i}.mfcc{1};
end

for i = 1:length(mfcc_behav_corrs(6).processed_rating_signals.sub)
    if isempty(mfcc_behav_corrs(6).processed_rating_signals.sub{i})
        discount6 = discount6+1;
        continue
    end
    if length(mfcc_behav_corrs(6).processed_rating_signals.sub{i}.mfcc{1}) < 8638
        discount6 = discount6+1;
        continue
    end
    avg_ratings6(i,:) = mfcc_behav_corrs(6).processed_rating_signals.sub{i}.mfcc{1};
end
avg_ratings_forreal5 = sum(avg_ratings5)/(63-discount5);
avg_ratings_forreal6 = sum(avg_ratings6)/(63-discount6);

mfccs_sad_s = zeros(8638,13);
for i = 1:13
    mfccs_sad_s(:,i) = mfcc_behav_corrs(6).processed_mfcc_signals.sub{14}.mfcc{i};
end

mfccs_sad_s_del = zeros(8638,13);
for i = 1:8637
    mfccs_sad_s_del(i+1,:) = mfccs_sad_s(i+1,:)-mfccs_sad_s(i,:);
end

mfccs_sad_s_double_del = zeros(8638,13);
for i = 1:8637
    mfccs_sad_s_double_del(i+1,:) = mfccs_sad_s_del(i+1,:)-mfccs_sad_s_del(i,:);
end

[b,bint,r,rint,stats5] = regress(avg_ratings_forreal5',[ones(8638,1),mfccs_sad_s]);
[b,bint,r,rint,stats6] = regress(avg_ratings_forreal6',[ones(8638,1),mfccs_sad_s]);

[b,bint,r,rint,stats_del] = regress(avg_ratings_forreal5',[ones(8638,1),mfccs_sad_s,mfccs_sad_s_del]);
[b,bint,r,rint,stats_double_del] = regress(avg_ratings_forreal6',[ones(8638,1),mfccs_sad_s,mfccs_sad_s_del,mfccs_sad_s_double_del]);

save('MFCC_corrs_01_08','-v7.3')


%Average correlation coefficients, first averaging over all the subjects
for t = 1:6
    for m = 1:13
        coeff_sum = 0;
        abs_coeff_sum = 0;
        count = 0;
        for s = 1:length(mfcc_behav_corrs(t).corrcoefs.sub)
            if ~isempty(mfcc_behav_corrs(t).corrcoefs.sub{s})
                corr = mfcc_behav_corrs(t).corrcoefs.sub{s}.mfcc{m};
                if ~isempty(corr)
                    count = count + 1;
                    if isnan(corr)
                       corr = 0; 
                    end
                    coeff_sum = coeff_sum + corr;
                    abs_coeff_sum = abs_coeff_sum + abs(corr); 
                end
            end
        end
        avg_coeff = coeff_sum/count;
        avg_abs_coeff = abs_coeff_sum/count;
        mfcc_behav_corrs(t).corrcoef_avg_over_sub.mfcc{m} = avg_coeff;
        mfcc_behav_corrs(t).abs_corrcoef_avg_over_sub.mfcc{m} = avg_abs_coeff;
    end
end


%Now averaging over the 13 MFCCs
for t = 1:6
    for s = 1:length(mfcc_behav_corrs(t).corrcoefs.sub)
        coeff_sum = 0;
        abs_coeff_sum = 0;
        for m = 1:13
            if ~isempty(mfcc_behav_corrs(t).corrcoefs.sub{s})
                corr = mfcc_behav_corrs(t).corrcoefs.sub{s}.mfcc{m};
                if ~isempty(corr)
                    if isnan(corr)
                       corr = 0; 
                    end
                    coeff_sum = coeff_sum + corr;
                    abs_coeff_sum = abs_coeff_sum + abs(corr);
                end
            end
        end
        avg_coeff = coeff_sum/13;
        avg_abs_coeff = abs_coeff_sum/13;
        mfcc_behav_corrs(t).corrcoef_avg_over_mfcc.sub{s} = avg_coeff;
        mfcc_behav_corrs(t).abs_corrcoef_avg_over_mfcc.sub{s} = avg_abs_coeff;
    end
end


%Create linreg models that can be plotted later
for t = 1:6
    for s = 1:length(mfcc_behav_corrs(t).processed_mfcc_signals.sub)
        for m = 1:13
            if ~isempty(mfcc_behav_corrs(t).processed_rating_signals.sub{s}) & ~isempty(mfcc_behav_corrs(t).processed_rating_signals.sub{s}.mfcc{m})
                s1 = mfcc_behav_corrs(t).processed_mfcc_signals.sub{s}.mfcc{m};
                s2 = mfcc_behav_corrs(t).processed_rating_signals.sub{s}.mfcc{m};
                mfcc_behav_corrs(t).linreg_models.sub{s}.mfcc{m} = fitlm(s1,s2);
            end
        end
    end
end

%Example: using the struct to find the correlation coefficient between 
%emotion ratings for the sad short song (Type 5) and the second MFCC, for
%the third subject 
mfcc_behav_corrs(5).corrcoefs.sub{3}.mfcc{2}

%Example of using the struct to find the average correlation coefficient
%for the first MFCC for the sad short song (Type 6)
mfcc_behav_corrs(6).corrcoef_avg_over_sub.mfcc{1}

%Linear Regression example for type 6, subject 3, mfcc 1
s1 = mfcc_behav_corrs(6).processed_mfcc_signals.sub{3}.mfcc{1};
s2 = mfcc_behav_corrs(6).processed_rating_signals.sub{3}.mfcc{1};
scatter(s1,s2)
hold on
model = mfcc_behav_corrs(6).linreg_models.sub{3}.mfcc{1};
ce = model.Coefficients.Estimate;
y = ce(2)*s1 + ce(1);
plot(s1,y)
%%
clear swenjoy
clear swemo
swenjoy = stepwiselm([ones(8638,1),mfccs_sad_s],avg_ratings_forreal6','linear')
swemo = stepwiselm([ones(8638,1),mfccs_sad_s],avg_ratings_forreal5','linear')
[b6,bint6,r6,rint6,stats6] = regress(avg_ratings_forreal6',[ones(8638,1),mfccs_sad_s]);
[b5,bint5,r5,rint5,stats5] = regress(avg_ratings_forreal5',[ones(8638,1),mfccs_sad_s]);
save('MFCC_corrs_01_08_no_dels','-v7.3')
clear swenjoy
clear swemo
swenjoydel = stepwiselm([ones(8638,1),mfccs_sad_s,mfccs_sad_s_del],avg_ratings_forreal6','linear')
swemodel = stepwiselm([ones(8638,1),mfccs_sad_s,mfccs_sad_s_del],avg_ratings_forreal5','linear')
save('MFCC_corrs_01_08_dels','-v7.3')
clear swenjoydel
clear swemodel
swenjoyddel = stepwiselm([ones(8638,1),mfccs_sad_s,mfccs_sad_s_del,mfccs_sad_s_double_del],avg_ratings_forreal6','linear')
save('MFCC_corrs_01_08_double_dels_enjoy','-v7.3')
%%
clear swenjoyddel
swemoddel = stepwiselm([ones(8638,1),mfccs_sad_s,mfccs_sad_s_del,mfccs_sad_s_double_del],avg_ratings_forreal5','linear')
save('MFCC_corrs_01_08_double_dels_emo','-v7.3')