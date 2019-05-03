%This is to get first 10 LPCs

%grain is how often the features are computed in sec
grain = .05;
lpcs_sad_l = [];
[y,fs] = audioread(strcat('snl_l_norm.wav'));
y = sum(y,2);
offset = fs*grain;
for i = 1:10302
    lpcs_sad_l(i,:) = lpc(y(floor(1+i*grain*fs-offset):floor(1+i*grain*fs+offset)),10);
end

save('lpcs_sad_l_50')
clear

grain = .05;
lpcs_sad_s = [];
[y,fs] = audioread(strcat('snl_s_norm.wav'));
y = sum(y,2);
offset = fs*grain;
for i = 1:5119
    lpcs_sad_s(i,:) = lpc(y(floor(1+i*grain*fs-offset):floor(1+i*grain*fs+offset)),10);
end
save('lpcs_sad_s_50')
clear

grain = .05;
lpcs_happy = [];
[y,fs] = audioread(strcat('hnl_norm.wav'));
y = sum(y,2);
offset = fs*grain;
for i = 1:3372
    lpcs_happy(i,:) = lpc(y(floor(1+i*grain*fs-offset):floor(1+i*grain*fs+offset)),10);
end
save('lpcs_happy_50')
