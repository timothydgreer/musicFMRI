 grain = 25;
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
        mode = mfcc_behav_corrs(j).processed_mode_signals.sub{1,1}.mfcc{1,1};
        compress = mfcc_behav_corrs(j).processed_compression_signals.sub{1,1}.mfcc{1};
        hcdf = mfcc_behav_corrs(j).processed_hcdf_signals.sub{1,1}.mfcc{1};
        flux = mfcc_behav_corrs(j).processed_flux_signals.sub{1,1}.mfcc{1};
        lpcs = mfcc_behav_corrs(j).processed_lpcs_signals.sub{1,1}.mfcc{1};
        size(chroma)
        length(lpcs)
    end
    big_X = [mfccs, mfccs_d, mfccs_dd, clarity, brightness, key_strength, rmses, centroid, spread, skewness, kurtosis, chroma, mode, compress, hcdf, flux, lpcs];
    for k = 1:size(big_X,1)
        for l = 1:size(big_X,2)
            if isnan(big_X(k,l))
                big_X(k,l) = big_X(k-1,l);
                kkkk=3;
            end
        end
    end
    csvwrite(strcat('X_matrix_20_s',num2str(j),'_',num2str(grain),'.csv'),big_X)
    csvwrite(strcat('y_matrix_20_s',num2str(j),'_',num2str(grain),'.csv'),mean(ratings,2))
    csvwrite(strcat('y_matrix_t_20_s',num2str(j),'_',num2str(grain),'.csv'),mean(ratings,2)./std(ratings,0,2))
end
