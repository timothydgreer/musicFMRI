testfiledir = 'ratings';
matfiles = dir(fullfile(testfiledir, '*.txt'));
nfiles = length(matfiles);
data = cell(nfiles,1);
enemo = cell(nfiles,1);
%
times = cell(nfiles,1);
data = cell(nfiles,1);
%timesemo =  
%timesen = 
%emo = 
%en = 
for i = 1 : nfiles
   fid = fopen( fullfile(testfiledir, matfiles(i).name) );
   enemo{i} = fullfile(testfiledir, matfiles(i).name);
   data{i} = fscanf(fid,'%f %f');
   temp = data{i};
   times{i} = zeros(length(temp)-1,1);
   data{i} = zeros(length(temp)-1,1);
   for j = 1 : 2 : length(temp)-1
       times{i}((j+1)/2) = double(temp(j));
       data{i}((j-1)/2+1) = double(temp(j+1));
   end
   
   fclose(fid);
end

