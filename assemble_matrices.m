for j = 1:6
    ratings = [];
    for i=1:63
        try
            ratings = [ratings, mfcc_behav_corrs(j).processed_rating_signals.sub{1,i}.mfcc{1,1}];
        end
        mfccs = mfcc_behav_corrs(j).processed_mfcc_signals.sub{1,1}.mfcc{1,1};
        mfccs_d = mfcc_behav_corrs(j).processed_mfcc_d_signals.sub{1,1}.mfcc{1,1};
        mfccs_dd = mfcc_behav_corrs(j).processed_mfcc_dd_signals.sub{1,1}.mfcc{1,1};
        clarity = mfcc_behav_corrs(j).processed_clarity_signals.sub{1,1}.mfcc{1,1};  
        brightness = mfcc_behav_corrs(j).processed_brightness_signals.sub{1,1}.mfcc{1,1};
        key_strength = mfcc_behav_corrs(j).processed_key_strength_signals.sub{1,1}.mfcc{1,1};
        rmses = mfcc_behav_corrs(j).processed_rms_signals.sub{1,1}.mfcc{1,1};
        centroid = mfcc_behav_corrs(j).processed_centroid_signals.sub{1,1}.mfcc{1,1};
        spread = mfcc_behav_corrs(j).processed_spread_signals.sub{1,1}.mfcc{1,1};
        skewness = mfcc_behav_corrs(j).processed_skewness_signals.sub{1,1}.mfcc{1,1};
        kurtosis = mfcc_behav_corrs(j).processed_kurtosis_signals.sub{1,1}.mfcc{1,1};
        chroma = mfcc_behav_corrs(j).processed_chroma_signals.sub{1,1}.mfcc{1,1};      
    end
    big_X = [mfccs, mfccs_d, mfccs_dd, clarity, brightness, key_strength, rmses, centroid, spread, skewness, kurtosis, chroma];
    for k = 1:length(big_X)
        for l = 1:length(big_X(k))
            if isnan(big_X(k,l))
                big_X(k,l) = big_X(k-1,l);
                kkkk=3
            end
        end
    end
    csvwrite(strcat('X_matrix',num2str(j),'.csv'),big_X)
    csvwrite(strcat('y_matrix',num2str(j),'.csv'),mean(ratings,2))


end
