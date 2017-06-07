% This script drive my other Hirschmuller functions and is for development
% purposes.  It uses the Tsukuba images that have been corrupted with
% Gaussian noise with a standard deviation of 31.  This runs on HP
% workstation and generates the initial disparity map and initial entropy

% set fullImage = 1 for doing full image, set
fullImage = 0;

% first get my images
I1 = imread('C:\Users\Richard\Documents\Projects\Sarcos\hirchmuller\tsukuba\I1_sigma31.png');
I2 = imread('C:\Users\Richard\Documents\Projects\Sarcos\hirchmuller\tsukuba\I2_sigma31.png');
%disparity_GT = imread('C:\Users\Richard\Documents\Projects\Sarcos\hirchmuller\tsukuba\truedisp.row3.col3.pgm');

% open left image
%[filename, pathname] = uigetfile('*.*', 'Select first image');
%I1 = rgb2gray(imread(fullfile(pathname, filename)));

% open right image
%[filename, pathname] = uigetfile('*.*', 'Select second image');
%I2 = rgb2gray(imread(fullfile(pathname, filename)));

% open disparity file
[filename, pathname] = uigetfile('*.*', 'Select disparity file');
D = load(fullfile(pathname, filename));
% or compute disparity
%numDisparities = 64;
%D = disparity(I1,I2, 'Method','SemiGlobal', 'DisparityRange',[0 numDisparities],'BlockSize',17 );

% if first pass use this
%load('disparityEstimateTsukuba.mat')

% if second pass use the following two lines
%load('disparityEstimateTsukuba2.mat')
%D = fp;

%if first pass use the following line
%load('entropyEstimateTsukuba1.mat')

%if second pass use the following two lines
%load('entropyEstimateTsukuba2.mat')

%if second pass and you want to use different signma values
%load('entropyEstimateTsukubaWithSigma.mat')
%h = h_sigma_of_7;

D = D.D;     %Not sure how this became a struct, may need to remove this for future work
%save('disparityEstimateNoisyTsukuba.mat','D')
I2w = imWarp(I2,D);            % TODO: implement linear interpolation in imWarp
% verify warp
imtool(imfuse(I1,I2w))

% plot(I1(214,:))
% hold all
% plot(I2(214,:))
% plot(I2w(214,:))
% hold off

% load Entropy file
[filename, pathname] = uigetfile('*.*', 'Select entropy file');
h = load(fullfile(pathname, filename));
h = h.h;    % this seems to have something to do with the way disprity and entropy were saved
% or compute entropy
%h = computeEntropy(I1, I2w);
%save('entropyEstimateNoisyTsukuba','h')

[m,n] = size(I1);
startLine = 1;
endLine = m;

fp_LR = HH_GC(I1, I2, h);
fp_RL = HH_GC_baseImageIsRightImage(I1, I2, h);

% for i = 1:m
%     for j = 1:n
%         if (fp_LR(m,n)-fp_RL(m,n))
%         end
%     end
% end


%dispGT = reshape(disparity_GT(startLine:endLine,:)',m*n, 1);

% figure
% plot(fp,'b')
% hold on
% plot(D(214,:),'r')
% plot(dispGT/4,'m')
% hold off
% axis([0,800,0,100])

IoutLR=reshape(fp_LR,n,m)';
IoutLR = medfilt2(IoutLR)
imtool(IoutLR/60)

IoutRL=reshape(fp_RL,n,m)';
IoutRL = medfilt2(IoutRL)
imtool(IoutRL/60)
