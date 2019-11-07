% Path of the filefold
SamplePath = '/Users/cheyingge/Desktop/cv/project1/smooth_res/box_5/';
SavePath = '../res/';
DiffPath ='../Diff/';
% File suffix
fileExt = '*.jpg';

files = dir(fullfile(SamplePath,fileExt)); 
len = size(files,1);
%get the image size
size_p=size(imread(strcat(SamplePath,files(1).name)));
diff=zeros(size_p(1),size_p(2));



%define spatial filter

%3*3 box filter
%filter=ones(3,3)/9;

%5*5 box filter
%filter=ones(5,5)/25;

%7*7 gaussian filter
% filter=zeros(7,7);
% for i= 1:7
%     for j= 1:7
%         filter(i,j)=exp((-(i-4)^2-(j-4)^2)/(2*1.4*1.4/255/255));
%     end
% end

%5*5 gaussian filter
% filter=zeros(5,5);
% for i= 1:5
%     for j= 1:5
%         filter(i,j)=exp((-(i-3)^2-(j-3)^2)/(2/255/255));
%     end
% end

%simple temporal derivative
for i=2:len-1
   %readin images
   fileName0=strcat(SamplePath,files(i-1).name);
   fileName1= strcat(SamplePath,files(i+1).name);
   image0 = imread(fileName0);
   image1 = imread(fileName1);
   % Convert RGB to grayscale
   I0=rgb2gray(image0);
   I1= rgb2gray(image1);
   %use the spatial filter
   I0=imfilter(I0,filter,'replicate');
   I1=imfilter(I1,filter,'replicate');
   %calculate the temporal derivative
   framesub=double(abs(I1-I0))*0.5;
   diffName = strcat(DiffPath,files(i).name);
   %save the result
   imwrite(uint8(framesub),diffName);
   diff=diff+double(framesub)/(len-1);
end

%caculate the max average temporal derivate as threshold
threshold=max(max(diff))/255;

%generate the mask and put it on original image
for i=2:len-1
    fileName = strcat(SamplePath,files(i-1).name);
    diffName = strcat(DiffPath,files(i).name);
    saveName = strcat(SavePath,files(i).name);
    diff_image=imread(diffName);
    image=imread(fileName);
    
    ori=imread(fileName);
    
    %generate the mask based on threshold
    mask=imbinarize(diff_image,threshold);
    output=zeros(size_p(1),size_p(2),3);
    
    %use mask on original images
    for m=1:size_p
       for n=1:size_p
           for k= 1:3
              output(m,n,k)=uint8(mask(m,n))*ori(m,n,k);
           end
       end
    end
    %save result
    imwrite(uint8(output),saveName);
end
