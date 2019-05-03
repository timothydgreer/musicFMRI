cd 'sad_l_split'
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [100,6400];

MFCCs_sad_l  = [];
MFCCs_sad_l_del  = [];
MFCCs_sad_l_double_del  = [];
harm_sad_l  = [];
inharm_sad_l = [];
clarity_sad_l  = [];
tempo_sad_l  = [];
brightness_sad_l  = [];
zc_sad_l  = [];
key_strength_sad_l  = [];
for i = 1:23
    if i < 10
        zero = '0';
    else
        zero = '';
    end
    [y,fs] = audioread(strcat('snl_l_norm_',zero,num2str(i),'.wav'));
    y = sum(y,2);
    MFCCs_sad_l = [MFCCs_sad_l, mfcc(y,fs,50,25,alpha,'hamming',R,M,C,L)];
    %harm_sad_l  = [harm_sad_l,mirharmonicity(strcat('snl_l_norm_',zero,num2str(i),'.wav'))];
    %inharm_sad_l  = [inharm_sad_l,mirinharmonicity(strcat('snl_l_norm_',zero,num2str(i),'.wav'))];
    clarity_sad_l  = [clarity_sad_l,mirpulseclarity(strcat('snl_l_norm_',zero,num2str(i),'.wav'))];
    tempo_sad_l  = [tempo_sad_l,mirtempo(strcat('snl_l_norm_',zero,num2str(i),'.wav'))];
    brightness_sad_l  = [brightness_sad_l,mirbrightness(strcat('snl_l_norm_',zero,num2str(i),'.wav'))];
    zc_sad_l  = [zc_sad_l,mirzerocross(strcat('snl_l_norm_',zero,num2str(i),'.wav'))];
    key_strength_sad_l  = [key_strength_sad_l,mirkeystrength(strcat('snl_l_norm_',zero,num2str(i),'.wav'))];
end

for i = 1:length(MFCCs_sad_l)-1
    MFCCs_sad_l_del = [MFCCs_sad_l_del, MFCCs_sad_l(:,i+1)-MFCCs_sad_l(:,i)];
end
MFCCs_sad_l_del = [zeros(13,1),MFCCs_sad_l_del];

for i = 1:length(MFCCs_sad_l_del)-1
    MFCCs_sad_l_double_del = [MFCCs_sad_l_double_del, MFCCs_sad_l_del(:,i+1)-MFCCs_sad_l_del(:,i)];
end
MFCCs_sad_l_double_del = [zeros(13,1),MFCCs_sad_l_double_del];



harm_sad_l_u  = [];
inharm_sad_l_u = [];
clarity_sad_l_u  = [];
tempo_sad_l_u  = [];
brightness_sad_l_u  = [];
zc_sad_l_u  = [];
key_strength_sad_l_u  = [];

for i = 1:23
    clarity_sad_l_u = [clarity_sad_l_u, mirgetdata(clarity_sad_l(i))];
    tempo_sad_l_u = [tempo_sad_l_u, mirgetdata(tempo_sad_l(i))];
    brightness_sad_l_u = [brightness_sad_l_u, mirgetdata(brightness_sad_l(i))];
    zc_sad_l_u = [zc_sad_l_u, mirgetdata(zc_sad_l(i))];
    key_strength_sad_l_u = [key_strength_sad_l_u,mirgetdata(key_strength_sad_l(i))];
end

max_min_maj_sad_l = [max(key_strength_sad_l_u(:,:,1,1));max(key_strength_sad_l_u(:,:,1,2))];
key_strength_max_sad_l = max(max_min_maj_sad_l);

hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [100,6400];
[y,fs] = audioread('snl_l_norm.wav');
y = sum(y,2);
%y1 = y(1:floor(length(y)/2));
full_MFCCs_sad_l = mfcc(y,fs,50,25,alpha,'hamming',R,M,C,L);
%y2 = y(floor(length(y)/2):end);
%full_MFCCs_sad_l2 = mfcc(y2,fs,50,25,alpha,'hamming',R,M,C,L);
%mean(full_MFCCs_sad_l2(1,:))
%mean(full_MFCCs_sad_l1(1,:))
save('mfccs_sad_l')
clear 

cd '../sad_s_split'


hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [100,6400];

MFCCs_sad_s  = [];
MFCCs_sad_s_del  = [];
MFCCs_sad_s_double_del  = [];
harm_sad_s  = [];
inharm_sad_s  = [];
clarity_sad_s  = [];
tempo_sad_s  = [];
brightness_sad_s  = [];
zc_sad_s = [];
key_strength_sad_s  = [];
for i = 1:18
    if i < 10
        zero = '0';
    else
        zero = '';
    end
    [y,fs] = audioread(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_',zero,num2str(i),'.wav'));
    y = sum(y,2);
    %mirsegment with RMS is useful?
    MFCCs_sad_s = [MFCCs_sad_s, mfcc(y,fs,50,25,.97,'hamming',R,M,C,L)];
    %harm_sad_s  = [harm_sad_s,mirharmonicity(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_norm_',zero,num2str(i),'.wav'))];
    %inharm_sad_s  = [inharm_sad_s,mirinharmonicity(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_norm_',zero,num2str(i),'.wav'))];
    clarity_sad_s  = [clarity_sad_s,mirpulseclarity(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_',zero,num2str(i),'.wav'))];
    tempo_sad_s  = [tempo_sad_s,mirtempo(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_',zero,num2str(i),'.wav'))];
    brightness_sad_s  = [brightness_sad_s,mirbrightness(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_',zero,num2str(i),'.wav'))];
    zc_sad_s  = [zc_sad_s,mirzerocross(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_',zero,num2str(i),'.wav'))];
    key_strength_sad_s  = [key_strength_sad_s,mirkeystrength(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_',zero,num2str(i),'.wav'))];
end

for i = 1:length(MFCCs_sad_s)-1
    MFCCs_sad_s_del = [MFCCs_sad_s_del, MFCCs_sad_s(:,i+1)-MFCCs_sad_s(:,i)];
end
MFCCs_sad_s_del = [zeros(13,1),MFCCs_sad_s_del];

for i = 1:length(MFCCs_sad_s_del)-1
    MFCCs_sad_s_double_del = [MFCCs_sad_s_double_del, MFCCs_sad_s_del(:,i+1)-MFCCs_sad_s_del(:,i)];
end
MFCCs_sad_s_double_del = [zeros(13,1),MFCCs_sad_s_double_del];




harm_sad_s_u  = [];
inharm_sad_s_u = [];
clarity_sad_s_u  = [];
tempo_sad_s_u  = [];
brightness_sad_s_u  = [];
zc_sad_s_u  = [];
key_strength_sad_s_u  = [];


for i = 1:18
    clarity_sad_s_u = [clarity_sad_s_u, mirgetdata(clarity_sad_s(i))];
    tempo_sad_s_u = [tempo_sad_s_u, mirgetdata(tempo_sad_s(i))];
    brightness_sad_s_u = [brightness_sad_s_u, mirgetdata(brightness_sad_s(i))];
    zc_sad_s_u = [zc_sad_s_u, mirgetdata(zc_sad_s(i))];
    key_strength_sad_s_u = [key_strength_sad_s_u, mirgetdata(key_strength_sad_s(i))];
end

max_min_maj_sad_s = [max(key_strength_sad_s_u(:,:,1,1));max(key_strength_sad_s_u(:,:,1,2))];
key_strength_max_sad_s = max(max_min_maj_sad_s);

[y,fs] = audioread('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta.wav');
y = sum(y,2);
full_MFCCs_sad_s = mfcc(y,fs,50,25,alpha,'hamming',R,M,C,L);

save('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_s')

clear

cd '../happy_split'



hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [100,6400];

MFCCs_happy = [];
MFCCs_happy_del  = [];
MFCCs_happy_double_del  = [];
harm_happy  = [];
inharm_happy  = [];
clarity_happy  = [];
tempo_happy  = [];
brightness_happy  = [];
zc_happy = [];
key_strength_happy  = [];
for i = 1:15
    if i < 10
        zero = '0';
    else
        zero = '';
    end
    [y,fs] = audioread(strcat('hnl_norm_',zero,num2str(i),'.wav'));
    y = sum(y,2);
    MFCCs_happy = [MFCCs_happy, mfcc(y,fs,50,25,alpha,'hamming',R,M,C,L)];
    %harm_happy  = [harm_happy,mirharmonicity(strcat('hnl_norm_',zero,num2str(i),'.wav'))];
    %inharm_happy  = [inharm_happy,mirinharmonicity(strcat('hnl_norm_',zero,num2str(i),'.wav'))];
    clarity_happy  = [clarity_happy,mirpulseclarity(strcat('hnl_norm_',zero,num2str(i),'.wav'))];
    tempo_happy  = [tempo_happy,mirtempo(strcat('hnl_norm_',zero,num2str(i),'.wav'))];
    brightness_happy  = [brightness_happy,mirbrightness(strcat('hnl_norm_',zero,num2str(i),'.wav'))];
    zc_happy  = [zc_happy,mirzerocross(strcat('hnl_norm_',zero,num2str(i),'.wav'))];
    key_strength_happy  = [key_strength_happy,mirkeystrength(strcat('hnl_norm_',zero,num2str(i),'.wav'))];
end

%TODO: Recheck this to be sure.
for i = 1:length(MFCCs_happy)-1
    MFCCs_happy_del = [MFCCs_happy_del, MFCCs_happy(:,i+1)-MFCCs_happy(:,i)];
end
MFCCs_happy_del = [zeros(13,1),MFCCs_happy_del];

for i = 1:length(MFCCs_happy_del)-1
    MFCCs_happy_double_del = [MFCCs_happy_double_del, MFCCs_happy_del(:,i+1)-MFCCs_happy_del(:,i)];
end
MFCCs_happy_double_del = [zeros(13,1),MFCCs_happy_double_del];

harm_happy_u  = [];
inharm_happy_u = [];
clarity_happy_u  = [];
tempo_happy_u  = [];
brightness_happy_u  = [];
zc_happy_u  = [];
key_strength_happy_u  = [];

for i = 1:15
    clarity_happy_u = [clarity_happy_u, mirgetdata(clarity_happy(i))];
    tempo_happy_u = [tempo_happy_u, mirgetdata(tempo_happy(i))];
    brightness_happy_u = [brightness_happy_u, mirgetdata(brightness_happy(i))];
    zc_happy_u = [zc_happy_u, mirgetdata(zc_happy(i))];
    key_strength_happy_u = [key_strength_happy_u, mirgetdata(key_strength_happy(i))];
end

max_min_maj_happy = [max(key_strength_happy_u(:,:,1,1));max(key_strength_happy_u(:,:,1,2))];
key_strength_max_happy = max(max_min_maj_happy);

[y,fs] = audioread('hnl_norm.wav');
y = sum(y,2);
full_MFCCs_happy = mfcc(y,fs,50,25,alpha,'hamming',R,M,C,L);

save('mfccs_happy')