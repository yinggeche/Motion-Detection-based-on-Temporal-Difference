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

for k = 2:len-1
    % reading images
   fileName1=strcat(SmoothPath,files(k-1).name);
   fileName3= strcat(SmoothPath,files(k+1).name);
   image1 = imread(fileName1);
   image3 = imread(fileName3);
   % calculate the temporal derivative
   framesub=double(abs(image3-image1))*0.5;
   diffName = strcat(DiffPath,files(k).name);
   diff=diff+framesub/(len-2*r);
   imwrite(uint8(framesub),diffName);
end
% diff = diff+3;
threshold=max(max(diff))/255;

%generate the mask and put it on original image
for i = 2:len-1
    diffName = strcat(DiffPath,files(i).name);
    diff_image=imread(diffName);
    mask=imbinarize(diff_image,threshold);
    maskName = strcat(MaskPath,files(i).name);
    imwrite(mask,maskName);
    output=zeros(W,H,3);
    fileName = strcat(OriPath,files(i-1).name);
    
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
