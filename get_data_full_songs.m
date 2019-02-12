cd 'sad_l_split'

%grain is how often the features are computed in sec
grain = .025;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [200,8000];

MFCCs_sad_l  = [];
MFCCs_sad_l_del  = [];
MFCCs_sad_l_double_del  = [];

%chroma vector, 
%key clarity: can use mirkey
%musical mode
%and harmonicdetection: harmonic change detection function??


[y,fs] = audioread(strcat('snl_l_norm.wav'));
y = sum(y,2);

features_sad_l = mirfeatures(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s'));
MFCCs_sad_l_mir_t = mirgetdata(features_sad_l.spectral.mfcc);
MFCCs_sad_l_mir_d = mirgetdata(features_sad_l.spectral.dmfcc);
MFCCs_sad_l_mir_dd = mirgetdata(features_sad_l.spectral.ddmfcc);

MFCCs_sad_l = mfcc(y,fs,2000*grain,1000*grain,alpha,'hamming',R,M,C,L);


%Don't know why this doesn't work
%MFCCs_sad_l_mir = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',0);
%MFCCs_sad_l_mir_del = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',1);
%MFCCs_sad_l_mir_ddel = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',2);




%harm_sad_l_st  = [harm_sad_l_st, mirgetdata(mirharmonicity(mirframe(strcat('snl_l_norm_',zero,num2str(i),'.wav'),.05,.025)))];
%inharm_sad_l_st = [inharm_sad_l_st, mirgetdata(mirinharmonicity(mirframe(strcat('snl_l_norm_',zero,num2str(i),'.wav'),.05,.025)))];
clarity_sad_l_st  = mirgetdata(mirpulseclarity(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')));
brightness_sad_l_st  = mirgetdata(mirbrightness(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')));
zc_sad_l_st  = mirgetdata(mirzerocross(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')));
key_strength_sad_l_st  = mirgetdata(mirkeystrength(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')));
key_strength_sad_l_st = max(key_strength_sad_l_st(:,:,1,1),key_strength_sad_l_st(:,:,1,2));
key_strength_sad_l_st_max = max(key_strength_sad_l_st);
rms_sad_l_st = mirgetdata(mirrms(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')));
centroid_sad_l_st = mirgetdata(mircentroid(mirspectrum(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s'))));
spread_sad_l_st = mirgetdata(mirspread(mirspectrum(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s'))));
skewness_sad_l_st = mirgetdata(mirskewness(mirspectrum(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s'))));
kurtosis_sad_l_st = mirgetdata(mirkurtosis(mirspectrum(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s'))));
chroma_sad_l_st = mirgetdata(mirchromagram(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')));
mode_sad_l_st = mirgetdata(mirmode(mirchromagram(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s'))));

%pad by 0s
hcdf_sad_l_st = mirgetdata(mirhcdf(mirchromagram(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s'))));
flux_sad_l_st = mirgetdata(mirflux(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')));
hcdf_sad_l_st = [0,hcdf_sad_l_st];
flux_sad_l_st = [0,flux_sad_l_st];

for i = 1:length(MFCCs_sad_l)-1
    MFCCs_sad_l_del = [MFCCs_sad_l_del, MFCCs_sad_l(:,i+1)-MFCCs_sad_l(:,i)];
end
MFCCs_sad_l_del = [zeros(13,1),MFCCs_sad_l_del];

for i = 1:length(MFCCs_sad_l_del)-1
    MFCCs_sad_l_double_del = [MFCCs_sad_l_double_del, MFCCs_sad_l_del(:,i+1)-MFCCs_sad_l_del(:,i)];
end
MFCCs_sad_l_double_del = [zeros(13,1),MFCCs_sad_l_double_del];

save(strcat('data_sad_l_full_song_',num2str(grain*1000)))

clear 

cd '../sad_s_split'

grain = .025;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [200,8000];

MFCCs_sad_s  = [];
MFCCs_sad_s_del  = [];
MFCCs_sad_s_double_del  = [];

%chroma vector, 
%key clarity: can use mirkey
%musical mode
%and harmonicdetection: harmonic change detection function??


[y,fs] = audioread(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav'));
y = sum(y,2);

features_sad_s = mirfeatures(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s'));
MFCCs_sad_s_mir_t = mirgetdata(features_sad_s.spectral.mfcc);
MFCCs_sad_s_mir_d = mirgetdata(features_sad_s.spectral.dmfcc);
MFCCs_sad_s_mir_dd = mirgetdata(features_sad_s.spectral.ddmfcc);

MFCCs_sad_s = mfcc(y,fs,2000*grain,1000*grain,alpha,'hamming',R,M,C,L);


%Don't know why this doesn't work
%MFCCs_sad_l_mir = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',0);
%MFCCs_sad_l_mir_del = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',1);
%MFCCs_sad_l_mir_ddel = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',2);




%harm_sad_l_st  = [harm_sad_l_st, mirgetdata(mirharmonicity(mirframe(strcat('snl_l_norm_',zero,num2str(i),'.wav'),.05,.025)))];
%inharm_sad_l_st = [inharm_sad_l_st, mirgetdata(mirinharmonicity(mirframe(strcat('snl_l_norm_',zero,num2str(i),'.wav'),.05,.025)))];
clarity_sad_s_st  = mirgetdata(mirpulseclarity(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s')));
brightness_sad_s_st  = mirgetdata(mirbrightness(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s')));
zc_sad_s_st  = mirgetdata(mirzerocross(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s')));
key_strength_sad_s_st  = mirgetdata(mirkeystrength(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s')));
key_strength_sad_s_st = max(key_strength_sad_s_st(:,:,1,1),key_strength_sad_s_st(:,:,1,2));
key_strength_sad_s_st_max = max(key_strength_sad_s_st);
rms_sad_s_st = mirgetdata(mirrms(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s')));
centroid_sad_s_st = mirgetdata(mircentroid(mirspectrum(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s'))));
spread_sad_s_st = mirgetdata(mirspread(mirspectrum(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s'))));
skewness_sad_s_st = mirgetdata(mirskewness(mirspectrum(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s'))));
kurtosis_sad_s_st = mirgetdata(mirkurtosis(mirspectrum(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s'))));
chroma_sad_s_st = mirgetdata(mirchromagram(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s')));
mode_sad_s_st = mirgetdata(mirmode(mirchromagram(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s'))));

%pad by 0s
hcdf_sad_s_st = mirgetdata(mirhcdf(mirchromagram(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s'))));
flux_sad_s_st = mirgetdata(mirflux(mirframe('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav',2*grain,'s',grain,'s')));
hcdf_sad_s_st = [0,hcdf_sad_s_st];
flux_sad_s_st = [0,flux_sad_s_st];


for i = 1:length(MFCCs_sad_s)-1
    MFCCs_sad_s_del = [MFCCs_sad_s_del, MFCCs_sad_s(:,i+1)-MFCCs_sad_s(:,i)];
end
MFCCs_sad_s_del = [zeros(13,1),MFCCs_sad_s_del];

for i = 1:length(MFCCs_sad_s_del)-1
    MFCCs_sad_s_double_del = [MFCCs_sad_s_double_del, MFCCs_sad_s_del(:,i+1)-MFCCs_sad_s_del(:,i)];
end
MFCCs_sad_s_double_del = [zeros(13,1),MFCCs_sad_s_double_del];

save(strcat('data_sad_s_full_song_',num2str(grain*1000)))

clear

cd '../happy_split'


grain = .025;
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [200,8000];

MFCCs_happy  = [];
MFCCs_happy_del  = [];
MFCCs_happy_double_del  = [];

%chroma vector, 
%key clarity: can use mirkey
%musical mode
%and harmonicdetection: harmonic change detection function??


[y,fs] = audioread(strcat('hnl_norm.wav'));
y = sum(y,2);

features_happy = mirfeatures(mirframe('hnl_norm.wav',2*grain,'s',grain,'s'));
MFCCs_happy_mir_t = mirgetdata(features_happy.spectral.mfcc);
MFCCs_happy_mir_d = mirgetdata(features_happy.spectral.dmfcc);
MFCCs_happy_mir_dd = mirgetdata(features_happy.spectral.ddmfcc);

MFCCs_happy = mfcc(y,fs,2000*grain,1000*grain,alpha,'hamming',R,M,C,L);


%Don't know why this doesn't work
%MFCCs_sad_l_mir = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',0);
%MFCCs_sad_l_mir_del = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',1);
%MFCCs_sad_l_mir_ddel = mirgetdata(mirmfcc(mirframe('snl_l_norm.wav',2*grain,'s',grain,'s')),'Delta',2);




%harm_sad_l_st  = [harm_sad_l_st, mirgetdata(mirharmonicity(mirframe(strcat('snl_l_norm_',zero,num2str(i),'.wav'),.05,.025)))];
%inharm_sad_l_st = [inharm_sad_l_st, mirgetdata(mirinharmonicity(mirframe(strcat('snl_l_norm_',zero,num2str(i),'.wav'),.05,.025)))];
clarity_happy_st  = mirgetdata(mirpulseclarity(mirframe('hnl_norm.wav',2*grain,'s',grain,'s')));
brightness_happy_st  = mirgetdata(mirbrightness(mirframe('hnl_norm.wav',2*grain,'s',grain,'s')));
zc_happy_st  = mirgetdata(mirzerocross(mirframe('hnl_norm.wav',2*grain,'s',grain,'s')));
key_strength_happy_st  = mirgetdata(mirkeystrength(mirframe('hnl_norm.wav',2*grain,'s',grain,'s')));
key_strength_happy_st = max(key_strength_happy_st(:,:,1,1),key_strength_happy_st(:,:,1,2));
key_strength_happy_st_max = max(key_strength_happy_st);
rms_happy_st = mirgetdata(mirrms(mirframe('hnl_norm.wav',2*grain,'s',grain,'s')));
centroid_happy_st = mirgetdata(mircentroid(mirspectrum(mirframe('hnl_norm.wav',2*grain,'s',grain,'s'))));
spread_happy_st = mirgetdata(mirspread(mirspectrum(mirframe('hnl_norm.wav',2*grain,'s',grain,'s'))));
skewness_happy_st = mirgetdata(mirskewness(mirspectrum(mirframe('hnl_norm.wav',2*grain,'s',grain,'s'))));
kurtosis_happy_st = mirgetdata(mirkurtosis(mirspectrum(mirframe('hnl_norm.wav',2*grain,'s',grain,'s'))));
chroma_happy_st = mirgetdata(mirchromagram(mirframe('hnl_norm.wav',2*grain,'s',grain,'s')));
mode_happy_st = mirgetdata(mirmode(mirchromagram(mirframe('hnl_norm.wav',2*grain,'s',grain,'s'))));

%pad by 0s
hcdf_happy_st = mirgetdata(mirhcdf(mirchromagram(mirframe('hnl_norm.wav',2*grain,'s',grain,'s'))));
flux_happy_st = mirgetdata(mirflux(mirframe('hnl_norm.wav',2*grain,'s',grain,'s')));
hcdf_happy_st = [0,hcdf_happy_st];
flux_happy_st = [0,flux_happy_st];

for i = 1:length(MFCCs_happy)-1
    MFCCs_happy_del = [MFCCs_happy_del, MFCCs_happy(:,i+1)-MFCCs_happy(:,i)];
end
MFCCs_happy_del = [zeros(13,1),MFCCs_happy_del];

for i = 1:length(MFCCs_happy_del)-1
    MFCCs_happy_double_del = [MFCCs_happy_double_del, MFCCs_happy_del(:,i+1)-MFCCs_happy_del(:,i)];
end
MFCCs_happy_double_del = [zeros(13,1),MFCCs_happy_double_del];

save(strcat('data_happy_full_song_',num2str(grain*1000)))