clear
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
M = 20;
C = 13;
L = 22;
alpha = .97;
R = [200,8000];
[y,fs] = audioread('snl_s_norm.wav');
y = sum(y,2);
origy = y;
full_MFCCs_sad_l = mfcc(y,fs,50,25,alpha,'hamming',R,M,C,L);


y = y(1:floor(length(y)/(fs*.05))*(fs*.05));

y = reshape(y,[fs*.05,length(y)/(fs*.05)]);

rmsy = rms(y);
ds = downsample(full_MFCCs_sad_l',2);
ds = ds';
ds = ds(1,:);
rho = corrcoef(rmsy(1:5119),ds)
windowSize = 80; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
y2 = filter(b,a,rmsy);
dsy = filter(b,a,ds);
subplot(1,2,1)
title('MFCC')
plot([0:.05:5119*.05-.05],dsy)
subplot(1,2,2)
title('RMS')
plot([0:.05:5119*.05-.05],y2(1:5119))


tempo = tempo2(origy,fs);
save('mfccs_sad_s_with_rms')


