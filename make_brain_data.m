path = './'; %Set path to the emotion and enjoyment ratings

files = dir(path); 
%{
Find all unique subjects. Note that there is a discrepancy between the number 
of files in the ratings_behav folder (360) and the ecg_peaks_ibi folder, so
the smaller of the two was used to build the list of unique subjects.
%}

for i = 1:length(files)
    if contains(files(i).name,'X_') && ~contains(files(i).name,'100') && ~contains(files(i).name,'#')
        files(i)
        data = load(files(i).name);
        length(data)
        data = downsample(data,40);
        if length(data) == 139
            data = data(1:138,:);
        end
        length(data)
        csvwrite(strcat(files(i).name(1:end-4),'_brain.csv'),data)
    end    
end