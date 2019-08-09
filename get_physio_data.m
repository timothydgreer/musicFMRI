clear, clc

physio_path = 'fmri_physio/'; % Path where the raw physio text files are stored (Note that all the files should be unzipped to the same location)

frame_size = 10000; % Set num samples in a frame (window). Sampling rate is 1000 Hz, so a window of 10000 samples is 10 seconds long 
overlap = 5000; % Set window overlap. 5000 samples in this case is an overlap of 50%

files = dir(physio_path); 

sub_list = {}; % Find all the different subjects in the given directory
for file = files'
    if ~(file.isdir) && ~(ismember(file.name(1:6),sub_list))
       sub_list = [sub_list; file.name(1:6)]; % Note that subject 7 is missing from the given files
    end
end

for i = 1:length(sub_list)    
    subject = char(sub_list(i));
    for j = 1:3 % Each subject should have 3 files associated with it, one for each song
        switch j
            case 1
              type = 'happy';
              file_ext = '_happy_physio_gsr.txt';
            case 2
              type = 'sad_long';
              file_ext = '_sadln_physio_gsr.txt';
            case 3
              type = 'sad_short';
              file_ext = '_sadsh_physio_gsr.txt';
        end
        
        %Create struct to store data
        physio_data(j).type = type; 
    
        directory = dir(strcat(physio_path, subject, file_ext));
        if ~isempty(directory)
            data = load(strcat(physio_path,directory.name)); 
            raw_resp = data(:,2); % Get the raw respiratory data (should be column 2 in the given files)
            zcr = sum(buffer(abs(diff(sign(    raw_resp - mean(raw_resp)     ))), frame_size,overlap)); % Calculate zero crossing rate for each window
            % Also note that raw_resp has been centered when calculating
            % zcr
        else
            raw_resp = 0;
            zcr = 0;
        end
        physio_data(j).sub(i).id = subject; %Unique identifier for each subject 
        physio_data(j).sub(i).respiration = raw_resp;
        physio_data(j).sub(i).zcr = zcr;
    end
end