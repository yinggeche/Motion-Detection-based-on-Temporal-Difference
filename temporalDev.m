GraySavePath = '../GrayChair/';
% File suffix
fileExt = '*.jpg';
% Get the path 
files = dir(fullfile(GraySavePath,fileExt)); 
len = size(files,1);
res = zeros(1,len);

% Compute the temporal derivative
for i=1:len
   fileName = strcat(GraySavePath,files(i).name); 
   image = imread(fileName);
   res(1,i) = image(1,1);
end

% Compute the simple filter 0.5*[-1,0,1]
tem1 = res;
tem2 = res;
[J,W]=size(res);
for k=2:W-1
    tem1(1,k) = (-0.5)*res(1,k-1) + 0.5*res(1,k+1);
end

% Compute the Gaussian filter with sigma = 1
sigma = 1;
n = 5;
GaussTemp1 = ones(1,n);
r = floor(n/2);

for i = -r : r
    GaussTemp1(1,i+r+1) = (-i/sigma^2)*exp(-(i^2)/(2*(sigma^2)));
end

for k = r+1:len-r
    tem2(1,k)= res(1,k-2)*GaussTemp1(1,r-1)+res(1,k-1)*GaussTemp1(1,r)+res(1,k)*GaussTemp1(1,r+1)+res(1,k+1)*GaussTemp1(1,r*2)+res(1,k+2)*GaussTemp1(1,r*2+1);
end

avg = 0;

for k=1:len
    avg= avg + tem2(1,k)/len;
end

% Compute the Gaussian filter with sigma = 1.4
sigma = 1.4;
n = 7;
GaussTemp2 = ones(1,n);
r = floor(n/2);
tem3 = res;

for i = -r : r
    GaussTemp2(1,i+r+1) = (-i/sigma^2)*exp(-(i^2)/(2*(sigma^2)));
end

for k = r+1:len-r
    tem3(1,k)= res(1,k-3)*GaussTemp2(1,r-2)+res(1,k-2)*GaussTemp2(1,r-1)+res(1,k-1)*GaussTemp2(1,r)+res(1,k)*GaussTemp2(1,r+1)+res(1,k+1)*GaussTemp2(1,r+2)+res(1,k+2)*GaussTemp2(1,r+3)+res(1,k+3)*GaussTemp2(1,r+4);
end

figure
subplot(2,2,1);plot(res);
title('Gray Value Plot');
xlabel('Time Zone')
ylabel('Gray Value')
subplot(2,2,2);plot(tem1);
title('Simple Filter');
xlabel('Time Zone')
subplot(2,2,3);plot(tem2);
title('Gaussian Filter with sigma=1, mean=0');
xlabel('Time Zone')
subplot(2,2,4);plot(tem3);
title('Gaussian Filter with sigma=1.4, mean=0');
xlabel('Time Zone')

% figure
% plot(tem2);
% hold on
% x = ones(1,len);
% x = x * avg;
% plot(x);
% hold on