% This script drive my other Hirschmuller functions and is for development
% purposes.

% first get my images
I1 = rgb2gray(imread('C:\Users\Richard\Documents\Projects\Sarcos\hirchmuller\tsukuba\scene1.row3.col1.ppm'));
I2 = rgb2gray(imread('C:\Users\Richard\Documents\Projects\Sarcos\hirchmuller\tsukuba\scene1.row3.col5.ppm'));

% [filename, pathname] = uigetfile('*.*', 'Select first image');
% I1 = rgb2gray(imread(fullfile(pathname, filename)));
% 
% [filename, pathname] = uigetfile('*.*', 'Select second image');
% I2 = rgb2gray(imread(fullfile(pathname, filename)));

% get initial disparity estimate
numDisparities = 64;
%D = disparity(I1,I2, 'Method','SemiGlobal', 'DisparityRange',[0 numDisparities],'BlockSize',17 );
load('disparityEstimateTsukuba.mat')
load('entropyEstimateTsukubaLine214.mat')

I2w = imWarp(I2,D);            % TODO: implement linear interpolation in imWarp
% verify warp
imtool(imfuse(I1,I2w))

plot(I1(214,:))
hold all
plot(I2(214,:))
plot(I2w(214,:))
hold off

%h = computeEntropy(I1(214,:), I2w(214,:))

fp = HH_GC(I1(214,:), I2(214,:), h);

figure
plot(fp,'b')
hold on
plot(D(214,:),'r')
hold off
axis([0,400,0,100])
