cd 'sad_l_split'
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [200,8000];

MFCCs_sad_l  = [];
harm_sad_l  = [];
inharm_sad_l = [];
clarity_sad_l  = [];
tempo_sad_l  = [];
brightness_sad_l  = [];
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
end

clear
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [200,8000];
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
R = [200,8000];

MFCCs_sad_s  = [];
harm_sad_s  = [];
inharm_sad_s  = [];
clarity_sad_s  = [];
tempo_sad_s  = [];
brightness_sad_s  = [];
for i = 1:13
    if i < 10
        zero = '0';
    else
        zero = '';
    end
    [y,fs] = audioread(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_norm_',zero,num2str(i),'.wav'));
    y = sum(y,2);
    MFCCs_sad_s = [MFCCs_sad_s, mfcc(y,fs,50,25,.97,'hamming',R,M,C,L)];
    %harm_sad_s  = [harm_sad_s,mirharmonicity(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_norm_',zero,num2str(i),'.wav'))];
    %inharm_sad_s  = [inharm_sad_s,mirinharmonicity(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_norm_',zero,num2str(i),'.wav'))];
    clarity_sad_s  = [clarity_sad_s,mirpulseclarity(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_norm_',zero,num2str(i),'.wav'))];
    tempo_sad_s  = [tempo_sad_s,mirtempo(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_norm_',zero,num2str(i),'.wav'))];
    brightness_sad_s  = [brightness_sad_s,mirbrightness(strcat('Olafur_Arnalds_-_Living_Room_Songs_-_1_Fyrsta_norm_',zero,num2str(i),'.wav'))];
end

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
R = [200,8000];

MFCCs_happy = [];
harm_happy  = [];
inharm_happy  = [];
clarity_happy  = [];
tempo_happy  = [];
brightness_happy  = [];
for i = 1:14
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
end

[y,fs] = audioread('hnl_norm.wav');
y = sum(y,2);
full_MFCCs_happy = mfcc(y,fs,50,25,alpha,'hamming',R,M,C,L);

save('mfccs_happy')