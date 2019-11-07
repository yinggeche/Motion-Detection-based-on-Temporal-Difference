% Path of the filefold
SamplePath = '../RedChair/';
GraySavePath = '../GrayChair/';
% File suffix
fileExt = '*.jpg';
% Get the path 
files = dir(fullfile(SamplePath,fileExt)); 
len = size(files,1);
% Get the whole files
for i=1:len
   fileName = strcat(SamplePath,files(i).name); 
   image = imread(fileName);
   % Convert RGB to grayscale
   I = rgb2gray(image);
   % Save gray image
   saveGrayName = strcat(GraySavePath,files(i).name);
   imwrite(I,saveGrayName)
end
