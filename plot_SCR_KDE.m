function f = plot_SCR_KDE(SCRs,res,bw)
    myticks = linspace(0,max(SCRs),res);
    ksdensity(SCRs,myticks,'Bandwidth',bw);
    f = ksdensity(SCRs,myticks,'Bandwidth',bw);
end

%f = plot_SCR_KDE(allSCRlocs_sad_l_emo,10000,8);
%hold on
%f1 = plot_SCR_KDE(allSCRlocs_sad_l_enjoy,10000,8);
%mean((f-f1).^2)

%myticks = linspace(0,515.16*5,100000);
%[f, k] = ksdensity([allSCRlocs_sad_l_emo_1s,allSCRlocs_sad_l_enjoy_1s],myticks,'Bandwidth',8);
%plot(k/5,f)

%myticks = linspace(0,256.08*5,100000);
%[f, k] = ksdensity([allSCRlocs_sad_s_emo_1s,allSCRlocs_sad_s_enjoy_1s],myticks,'Bandwidth',8);
%plot(k/5,f)

%myticks = linspace(0,168.69*5,100000);
%[f, k] = ksdensity([allSCRlocs_sad_s_emo_1s,allSCRlocs_sad_s_enjoy_1s],myticks,'Bandwidth',8);
%plot(k/5,f)