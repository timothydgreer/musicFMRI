function [new_signal] = findTonic(data,window)
    %Import something from scr first
    stdt = [];    
    mt = [];
    j = 0;
    for i = 1+window/2:length(data)-window/2
         stdt = [stdt, std(data(i-window/2:i+window/2))];
         mt = [mt, mean(data(i-window/2:i+window/2))];
         j = j+1;
    end
    stdt = [ones(1,window/2)*stdt(1), stdt, ones(1,window/2)*stdt(end)];
    mt = [ones(1,window/2)*mt(1), mt, ones(1,window/2)*mt(end)];
    new_signal = (data'-mt)./stdt;
end
