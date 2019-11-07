% Path of the filefold
OriPath = '../RedChair/';
SamplePath = '../GrayChair/';
SmoothPath = '../smooth_res/box_5/';
DiffPath ='../Diff/';
SavePath = '../res/';
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

% Define Temporal filter
% Filtering temporal derivative by Gaussian filter with sigma = 1
sigma = 1;
n = 5;
GaussTemp1 = ones(1,n);
r = floor(n/2);
for i = -r : r
    GaussTemp1(1,i+r+1) = (-i/sigma^2)*exp(-(i^2)/(2*(sigma^2)));
end

for k = r+1:len-r
    % reading images
   fileName1=strcat(SmoothPath,files(k-2).name);
   fileName2= strcat(SmoothPath,files(k-1).name);
   fileName4= strcat(SmoothPath,files(k+1).name);
   fileName5=strcat(SmoothPath,files(k+2).name);
   image1 = imread(fileName1);
   image2 = imread(fileName2);
   image4 = imread(fileName4);
   image5 = imread(fileName5);
   % calculate the temporal derivative
   framesub = abs(double(image1)*GaussTemp1(1,r-1)+double(image2)*GaussTemp1(1,r)+double(image4)*GaussTemp1(1,r+2)+double(image5)*GaussTemp1(1,r+3));
   diffName = strcat(DiffPath,files(k).name);
   diff=diff+framesub/(len-2*r);
   imwrite(uint8(framesub),diffName);
end
% diff = diff+3;
threshold=max(max(diff))/255;

%generate the mask and put it on original image
for i = r+1:len-r
    diffName = strcat(DiffPath,files(i).name);
    diff_image=imread(diffName);
    mask=imbinarize(diff_image,threshold);
    maskName = strcat(MaskPath,files(i).name);
    imwrite(mask,maskName);
    output=zeros(W,H,3);
    fileName = strcat(OriPath,files(i-r).name);
    
    saveName = strcat(SavePath,files(i).name);
    ori=imread(fileName);
    for m=1:W
        for n=1:H
           for k= 1:3
              output(m,n,k)=uint8(mask(m,n))*ori(m,n,k);
           end
       end
    end
    %save result
    imwrite(uint8(output),saveName);
end
