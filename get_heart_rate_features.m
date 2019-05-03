clear

load('heart_beats.mat')


mycell = {};

mycell{1} = ibi_only1;
mycell{2} = ibi_only2;
mycell{3} = ibi_only3;
mycell{4} = ibi_only4;
mycell{5} = ibi_only5;
mycell{6} = ibi_only6;

mycell2{1} = sort([ibi_only1,ibi_only2]);
mycell2{2} = sort([ibi_only3,ibi_only4]);
mycell2{3} = sort([ibi_only5,ibi_only6]);

HRVs = {};
tses = {};
for j = 1:length(mycell2)
    ibi_only = mycell2{j};
    diffs = [];
    %Find IBI
    for i = 2:length(ibi_only) 
        diffs = [diffs, ibi_only(i)-ibi_only(i-1)];
    end

    %Wait ~30 sec

    HRV = [];
    ts = [];
    for i = 41:length(ibi_only) 
        HRV = [HRV, std(ibi_only(i-40:i))];
        ts = [ts, ibi_only(i)];
    end
    HRVs{j} = HRV;
    tses{j} = ts;
end


Xes = {};
for j = 1:length(HRVs)
    j
    HRV = HRVs{j};
    ts = tses{j};
    max_t = max(mycell2{j})
    X = [];
    %Find IBI
    for i = 0:.025:max_t
        for k = 1:length(ts)
            if ts(k) > i
                try
                    X = [X,HRV(k-1)];
                    break
                end
                X = [X,0];
                break
            end
        end 
    end
    Xes{j} = X;
end

    



