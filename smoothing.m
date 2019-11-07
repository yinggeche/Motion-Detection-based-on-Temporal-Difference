% Path of the filefold
OriPath = '../RedChair/';
SamplePath = '../GrayChair/';
SmoothPath = '../gauss_7/';
DiffPath ='../Diff/';
SavePath = '../res_5/';
MaskPath = '../mask/';
% File suffix
fileExt = '*.jpg';

files = dir(fullfile(SamplePath,fileExt)); 
len = size(files,1);

%get the image size

fileName = strcat(SamplePath,files(1).name);
I = imread(fileName);
[W,H]=size(I);
diff=zeros(W,H);
framesub = zeros(W,H);

%define spatial filter
%3*3 box filter
% filter=ones(3,3)/9;

%5*5 box filter
% filter=ones(5,5)/25;

%7*7 gaussian filter
filter=zeros(7,7);
for i= 1:7
    for j= 1:7
        filter(i,j)=exp((-(i-4)^2-(j-4)^2)/(2*1.4*1.4));
    end
end

%5*5 gaussian filter
% filter=zeros(5,5);
% for i= 1:5
%     for j= 1:5
%         filter(i,j)=(exp((-(i-3)^2-(j-3)^2)/(2)));
%     end
% end
s = sum(sum(filter));
filter = filter./s;
%  Smoothing by 5*5 box filter
for i=1:len
   %readin images
   fileName=strcat(SamplePath,files(i).name);
   image = imread(fileName);
   %use the spatial filter
   I=imfilter(image,filter,'replicate');
   SmoothName = strcat(SmoothPath,files(i).name);
   %save the result
   imwrite(uint8(I),SmoothName);
end