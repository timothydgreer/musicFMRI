%Script for extracting features from MIRtoolbox

%directory = [pwd '/stimuli']; 
directory = '/Volumes/MusicProject/NaturalisticNetwork/acoustic_analysis/stimuli';
files = dir(directory);
filefolder = files(arrayfun(@(x) x.name(1), files) ~= '.');
filenames = {filefolder(:).name};
sort(filenames)
resolution = .1;
songlengths = [168,515,256];

%Low-level features are typically extracted in 42ms window in order to
%avoid aliasing with 44.1kHz sampling rate (Eerola)

for f = 1:length(filenames)
    clipname = filenames{f};
    clip = clipname(1:end-4); 
    songlength = songlengths(f); 
    %fprintf('%d\t%s\n',f,clipname);
    CurrentAudioFile = sprintf('%s/%s',directory,clipname); 
    %fprintf('%d\t%s\n',f,CurrentAudioFile);
    
    % Load the audio file
    a = miraudio(CurrentAudioFile,'Trim');
    l = mirlength(a);
    L = mirgetdata(l);  
    
    %% Short features - 25ms window with 50% overlapping
    
    % TIMBRE DATA:
    spectrum = mirspectrum(a,'Frame',0.025,'s',50,'%');
    
    % 1. Zero Crossing Rate (ZCR): number of time-domain zero crossings of the signal per time unit.
    zcr = mirzerocross(a,'Frame',0.025,'s',50,'%');
    ZCR = mirgetdata(zcr);
    if sum(isnan(ZCR)) ~= 0
        fprintf('Num NAN: %d\n',sum(isnan(ENT))) %357/20483 NaNs
    end


    % 2. Spectral Centroid: geometric center on the frequency scale of the amplitude spectrum.
    %  For quasi-silent frames, as specified by the ?MinRMS? option,NaN is returned.
    spc = mircentroid(spectrum,'MinRMS',0.00000000001);
    SPC = mirgetdata(spc);
    if sum(isnan(SPC)) ~= 0 
        fprintf('Num NAN: %d\n',sum(isnan(SPC))) %357/20483 NaNs
    end

    % 3. Spectral Entropy. 
    ent = mirentropy(spectrum,'MinRMS',0.00001);
    ENT = mirgetdata(ent);
    if sum(isnan(ENT)) ~= 0
        fprintf('Num NAN: %d\n',sum(isnan(ENT))) %357/20483 NaNs
    end

%     % 4. Spectral roll-off (frequency below which 85% of the total energy exists.)
%     ro = mirrolloff(spectrum,'MinRMS',0.001);
%     RO = mirgetdata(ro);
% 
%     % 5. Spectral flux: measure of temporal change in the spectrum, obtained by calculating the Euclidian distance between subsequent window-based amplitude spectra.   
%     spf = mirflux(spectrum);
%     SPF = mirgetdata(spf);
%      
%     % 6. Spectral spread: standard deviation of the spectrum.
%     sps = mirspread(a,'MinRMS',0.001,'Frame',0.025,'s',50,'%');
%     SPS = mirgetdata(sps);
%     sum(isnan(SPS)) %Still a lot of NA

    % 7. Spectral Flatness: Wiener entropy of the spectrum, defined as the ratio of its geometric mean to its arithmetic mean
    % For a given frame, if the RMS of the input (for spectral flatness, the input is each frame of the spectrogram, etc.) is below m times
    % the highest RMS value over the frames, NaN is returned. default value: m = .01
%     spfl = mirflatness(a,'MinRMS',0.001,'Frame',0.025,'s',50,'%');
%     SPFL = mirgetdata(spfl);
%     sum(isnan(SPFL))
    
    % 8. Roughness (sensory dissonance)
    rn = mirroughness(spectrum,'Vassilakis');
    RN = mirgetdata(rn); %A lot of zeros
    if sum(isnan(RN)) ~= 0
        fprintf('Num NAN: %d\n',sum(isnan(ENT))) %357/20483 NaNs
    end
    % 9. Sub-Band Flux:decomposes first the input waveform using a 10-channel filterbank of
    %octave-scaled second-order elliptical filters, with frequency cut of the first (low-pass) filter at
    %50 Hz:
%     sbf = mirflux(a, 'SubBand','Frame',0.025,'s',50,'%');
%     %mirgetdata(sbf)
%     SB = mean(mirgetdata(sbf));
    
    % 10. High energy-low energy ratio: ratio of energy content below and above 1500 Hz,
    % Spectral brightness (high-frequency rate above 1500 Hz): 
    %I divided the Brightness by "Darkness" (amount of energy content below
    %1500Hz). In this case, 1500Hz is the default cutoff to use so no specs
    %were needed.
    H = mirbrightness(spectrum,'MinRMS',0.00001,'Cutoff',1500); 
    HF = mirgetdata(H); 
    if sum(isnan(HF)) ~= 0
        fprintf('Num NAN: %d\n',sum(isnan(ENT))) %357/20483 NaNs
    end

%     
%     low = mirlowenergy(spectrum); 
%     L = mirgetdata(low);
        
    %GET ENERGY DATA:
    % 11. Root mean square energy. 'Loudness': RMS measure of instantaneous energy contained in the signal, obtained by taking the square root of sum of the squares of the amplitude.
    rms = mirrms(a,'Frame',0.025,'s',50,'%');
    RMS = mirgetdata(rms);
    
    %Print out findings
    fprintf('%s\tRMS mean: %.4f\tRMS length: %d\n', clipname,mean(RMS),length(RMS))
    fprintf('%s\tEntropy mean: %.4f\tEntropy length: %d\n', clipname,nanmean(ENT),length(ENT))
    fprintf('%s\tBright mean: %.4f\tBright length: %d\n', clipname,nanmean(HF),length(HF))
    fprintf('%s\tRough mean: %.4f\tRough length: %d\n', clipname,nanmean(RN),length(RN))
    fprintf('%s\tZCross mean: %.4f\tZCross length: %d\n', clipname,nanmean(ZCR),length(ZCR))
    fprintf('%s\tSCent mean: %.4f\tSCent length: %d\n', clipname,nanmean(SPC),length(SPC))
    fprintf('\n')
    
    %Write to log file:
    fname_sf = sprintf('/Volumes/MusicProject/NaturalisticNetwork/acoustic_analysis/%s_sf.csv',clip);
    varname = sprintf('/Volumes/MusicProject/NaturalisticNetwork/acoustic_analysis/%s_sf',clip);
    headername = {'rms' 'zcr' 'spectral_centroid' 'entropy' 'brightness' 'roughness'}; %dummy header
    header = strjoin(headername, ',');
    data = horzcat(RMS',ZCR',SPC',ENT',HF',RN'); 
    save(varname,'data'); 
    
    if exist(fname_sf, 'file') ~= 2
        fileID=fopen(fname_sf,'w');
        fprintf(fileID,'%s\n',header); 
        fclose(fileID); 
        dlmwrite(fname_sf,data,'-append');
    end


    %Plot short features:
    [r,c] = size(data); 
    fig = figure;
    for i = 1:c
        subplot(6,2,((i*2)-1))
        plot([1:length(data(:,i))],data(:,i))
        ylabel(headername{i});

        %Downsample each to 0.1Hz
        qp = [0:resolution:(songlength)-1];
        time = [1:length(data(:,i))]; 
        data_ds = interp1(time,data(:,i),qp,'spline');
        %data_ds = downsample(data(:,i),25); 

        subplot(6,2,(i*2))
        plot([1:length(data_ds)],data_ds)
        xlabel('Downsampled');
    end
    figname = sprintf('af_short_%s.tif',clip); 
    saveas(fig,figname)
end



         
%% LONG features - 3s window with 50% overlapping
for f = 1:length(filenames)
    clipname = filenames{f};
    clip = clipname(1:end-4); 
    songlength = songlengths(f); 
    %fprintf('%d\t%s\n',f,clipname);
    CurrentAudioFile = sprintf('%s/%s',directory,clipname); 
    %fprintf('%d\t%s\n',f,CurrentAudioFile);
    
    % Load the audio file
    a = miraudio(CurrentAudioFile,'Trim');
    l = mirlength(a);
    L = mirgetdata(l);  
    
    spectrum = mirspectrum(a,'Frame',3,'s',67,'%');
    
    %TONALITY DATA:
    % 12. Key Clarity: Key clarity: measure of the tonal clarity
    [kc, ks] = mirkey(spectrum);
    KC = mirgetdata(ks);
    
    % 13. Mode (major/minor)
    m = mirmode(spectrum);
    M = mirgetdata(m);
    
    %RHYTHM DATA:

    % 14. Fluctuation centroid: geometric mean of the 
    %fluctuation spectrum representing the global 
    %repartition of rhythm periodicities within the range of 0-10 Hz, 
    %indicating the average frequency of these periodicities
    fc = mirfluctuation(spectrum,'Summary'); 
    FC = mirgetdata(fc);
    
    % 15. Fluctuation Entropy: a measure of rhythmic complexity.   
%     fe = mirentropy(fc); 
%     FE = mirgetdata(fe); 

    % 16. Pulse Clarity: estimate of clarity of the pulse.
    pc = mirpulseclarity(spectrum);
    PC = mirgetdata(pc);
    
    % 17. Fluctuation centroid
    flc = mircentroid(fc);
    FLC = mirgetdata(flc);
    %AvgFLC= geomean(mean(mirgetdata(fc)));
    
    % 18. Event density
    %evd = mireventdensity(spectrum);
    %EVD = mirgetdata(spectrum);
    %AvgFLC= geomean(mean(mirgetdata(fc)));
    
    %Print out findings
    fprintf('%s\tKeyClar mean: %.4f\tKeyClar length: %d\n', clipname,mean(KC),length(KC))
    fprintf('%s\tMode mean: %.4f\tMode length: %d\n', clipname,mean(M),length(M))
    fprintf('%s\tPulseClar mean: %.4f\tPulseClar length: %d\n', clipname,mean(PC),length(PC))
    fprintf('%s\tFC mean: %.4f\tFC length: %d\n', clipname,mean(FC),length(FC))
    %fprintf('%s\tFluxCent mean: %.4f\tFluxCent length: %d\n', clipname,mean(FLC),length(FLC))
    fprintf('\n')
    
    fname_lf = sprintf('/Volumes/MusicProject/NaturalisticNetwork/acoustic_analysis/%s_lf.csv',clip);
    varname = sprintf('/Volumes/MusicProject/NaturalisticNetwork/acoustic_analysis/%s_lf',clip);
    headername = {'keyclarity' 'mode' 'pulseclar'}; %dummy header
    header = strjoin(headername, ',');
    data = horzcat(KC',M',PC'); 
    save(varname,'data'); 
    
    if exist(fname_lf, 'file') ~= 2
        fileID=fopen(fname_lf,'w');
        fprintf(fileID,'%s\n',header)
        fclose(fileID)
        dlmwrite(fname_lf,data,'-append');
    end
end
 
%% Preprocessing features: 


[r,c] = size(data); 
sf_data_preprocess = nan(5131,c); 
fs = 10; %sample rate 100hz
fc = .0125; %cutoff frequency
qp = [0:resolution:(songlength)-2];
for i = 1:c
    %1) Interpolate so that length is 5141 (ratings are length 5131, why? 
    af = data(:,i);
    resolution = .1;
    time = [1:length(af)]; 
    af_ds = interp1(time,af,qp,'spline');

    %do same preprocessing as for fratings 
    %1) high pass filter

    [b,a] = butter(2,fc/(fs/2),'high');
    af_hp = filtfilt(b,a,af_ds);
    af_hp = af_hp - mean(af_hp);
    af_hp = af_hp./max(af_hp); 

    %2) scale by detrending with mean
    af_norm = detrend(af_hp,'constant'); 

    %3) smooth with 3-second moving average
    af_smooth = smooth(af_norm,300,'mean'); 
    sf_data_preprocess(:,i) = af_smooth;
end

%Check by graphing next to each other 
[r,c] = size(data); 
fig = figure;
for i = 1:c
    subplot(6,2,((i*2)-1))
    plot([1:length(data(:,i))],data(:,i))
    ylabel(headername{i});

    subplot(6,2,(i*2))
    plot([1:length(sf_data_preprocess(:,i))],sf_data_preprocess(:,i))
    xlabel('Preprocessed');
end

%Create CSV file of preprocessed data for R 
fname_sf_preprocess = sprintf('/Volumes/MusicProject/NaturalisticNetwork/acoustic_analysis/%s_sf_preprocess.csv',clip); 
headername = {'rms' 'zcr' 'spectral_centroid' 'entropy' 'brightness' 'roughness'}; %dummy header
header = strjoin(headername, ',');

if exist(fname_sf_preprocess, 'file') ~= 2
    fileID=fopen(fname_sf_preprocess,'w');
    fprintf(fileID,'%s\n',header)
    fclose(fileID)
    dlmwrite(fname_sf_preprocess,sf_data_preprocess,'-append');
end
    


%1) Interpolate so that length is 5141 (ratings are length 5131, why? 
rms = data(:,1);
resolution = .1;
qp = [0:resolution:(songlength)-1];
time = [1:length(rms)]; 
rms_ds = interp1(time,rms,qp,'spline');

%Downsample data to 10hz
rms_ds = downsample(rms_ds, 10);

%make negatives zeros: 
if min(rms_ds) < 0
    %fprintf('\tAt first min is %.6f,nax is %.2f\n',min(ratings_ds),max(ratings_ds))
    rms_ds(rms_ds < 0) = 0; 
    %fprintf('\tNow, min is %.6f, max is %.2f\n',min(ratings_ds),max(ratings_ds))
end  

%Cut first 20 and add lag
rms_ds_lag = rms_ds(16:end-5);

rms_ds_lag2 = detrend(rms_ds_lag,'constant');

%Sliding window
windowspacing = 5; 
windowsize = 15; 
measure = 'mean'; 
numtimepoints = 495; 
maxtimepoint = numtimepoints;
reverseStr = '';
rms_win = [];

windownum = 1; 
for s = 1:windowspacing:numtimepoints
    windowstart = s;
    windowend = windowstart + windowsize-1;

    %check if this window extends beyond the end of the data
    if windowend > maxtimepoint
        break;
    end
    msg = sprintf('\nWorking on window %d, from %d to %d\n',windownum,windowstart,windowend);
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
    val = mean(rms_ds_lag2(windowstart:windowend));
    rms_win(end+1) = val;
    windownum = windownum + 1;
end
%%
% LOAD DATA FROM TIM
%%%%
mfcc = load('/Volumes/MusicProject/NaturalisticNetwork/acoustic_analysis/mfccs_sad_l.mat'); 
loud = full_MFCCs_sad_l(1,:); 
%1) Interpolate so that length is 5141 (ratings are length 5131, why? 
resolution = .1;
qp = [0:resolution:(songlength)-1];
time = [1:length(loud)]; 
loud = interp1(time,loud,qp,'spline');

%Downsample data to 10hz
loud_ds = downsample(loud, 10);

%make negatives zeros: 
if min(loud_ds) < 0
    %fprintf('\tAt first min is %.6f,nax is %.2f\n',min(ratings_ds),max(ratings_ds))
    loud_ds(loud_ds < 0) = 0; 
    %fprintf('\tNow, min is %.6f, max is %.2f\n',min(ratings_ds),max(ratings_ds))
end  
loud_ds = detrend(loud_ds,'constant');
loud_z = zscore(squeeze(loud_ds))
loud_ds = loud_ds/max(loud_ds)
loud_ds = squeeze(loud_ds);
rms_ds = squeeze(rms_ds);


%%
hold on
plot(rms_ds)
plot(loud_ds)


            

%do same preprocessing as for fratings 
%1) high pass filter
fs = 10; %sample rate 100hz
fc = .0125; %cutoff frequency
[b,a] = butter(2,fc/(fs/2),'high');
rms_hp = filtfilt(b,a,rms_ds);
rms_hp = rms_hp - mean(rms_hp);
rms_hp = rms_hp./max(rms_hp); 

%2) scale by detrending with mean
rms_norm = detrend(rms_hp,'constant'); 

%3) smooth with 3-second moving average
rms_smooth = smooth(rms_norm,300,'mean'); 

%plot
fig = figure;
subplot(5,1,1)
plot([1:length(rms)],rms)
xlabel('Raw');

subplot(5,1,2)
plot([1:length(rms_ds)],rms_ds)
xlabel('Downsampled');

subplot(5,1,3)
plot([1:length(rms_ds)],rms_ds)
xlabel('HP Filter');

subplot(5,1,4)
plot([1:length(rms_norm)],rms_norm)
xlabel('Normalized/Scaled');

subplot(5,1,5)
plot([1:length(rms_smooth)],rms_smooth)
xlabel('Smoothed');


%Plot after each step to observe
[r,c] = size(data); 
fig = figure;
for i = 1:c
    subplot(6,2,((i*2)-1))
    plot([1:length(data(:,i))],data(:,i))
    ylabel(headername{i});

    subplot(6,2,(i*2))
    plot([1:length(data_ds)],data_ds)
    xlabel('Downsampled');
end
   


   
        
          