%This is to get first 10 LPCs

%grain is how often the features are computed in sec
grain = .025;
lpcs_sad_l = [];
[y,fs] = audioread(strcat('snl_l_norm.wav'));
y = sum(y,2);
for i = 1:20605
    lpcs_sad_l(i,:) = lpc(y(floor(1+i*grain*fs-1102.5):floor(1+i*grain*fs+1102.5)),10);
end

save('lpcs_sad_l')
clear

grain = .025;
lpcs_sad_s = [];
[y,fs] = audioread(strcat('snl_s_norm.wav'));
y = sum(y,2);
for i = 1:10242
    lpcs_sad_s(i,:) = lpc(y(floor(1+i*grain*fs-1102.5):floor(1+i*grain*fs+1102.5)),10);
end
save('lpcs_sad_s')
clear

grain = .025;
lpcs_happy = [];
[y,fs] = audioread(strcat('hnl_norm.wav'));
y = sum(y,2);
for i = 1:6746
    lpcs_happy(i,:) = lpc(y(floor(1+i*grain*fs-1102.5):floor(1+i*grain*fs+1102.5)),10);
end
save('lpcs_happy')
