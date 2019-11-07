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


% Define Temporal filter
% Filtering temporal derivative by Gaussian filter with sigma = 1.4
sigma = 1.4;
n = 7;
GaussTemp1 = ones(1,n);
r = floor(n/2);
for i = -r : r
    GaussTemp1(1,i+r+1) = (-i/sigma^2)*exp(-(i^2)/(2*(sigma^2)));
end

for k = r+1:len-r
    % reading images
   fileName1=strcat(SmoothPath,files(k-3).name);
   fileName2=strcat(SmoothPath,files(k-2).name);
   fileName3=strcat(SmoothPath,files(k-1).name);
   fileName5=strcat(SmoothPath,files(k+1).name);
   fileName6=strcat(SmoothPath,files(k+2).name);
   fileName7=strcat(SmoothPath,files(k+3).name);
   image1 = imread(fileName1);
   image2 = imread(fileName2);
   image3 = imread(fileName3);
   image5 = imread(fileName5);
   image6 = imread(fileName6);
   image7 = imread(fileName7);

   % calculate the temporal derivative
   framesub = abs(double(image1)*GaussTemp1(1,r-2)+double(image2)*GaussTemp1(1,r-1)+double(image3)*GaussTemp1(1,r)+double(image5)*GaussTemp1(1,r+2)+double(image6)*GaussTemp1(1,r+3)+double(image)*GaussTemp1(1,r+4));
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
 