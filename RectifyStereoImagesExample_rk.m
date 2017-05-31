%% Rectify Stereo Images
% Specify calibration images.

% Copyright 2015 The MathWorks, Inc.

% imageDir = fullfile(toolboxdir('vision'),'visiondata','calibration','stereo');
% leftImages = imageDatastore(fullfile(imageDir,'left'));
% rightImages = imageDatastore(fullfile(imageDir,'right'));

% Run 'makeImageNameFile.m' first to generate the files with the names of
% the images in it.
[filenameL, pathnameL] = uigetfile(pwd, 'Select file where left image names are stored');
%load('C:\Users\Richard\Documents\Projects\Sarcos\Snake\Calibration\FireflyWith5inchBaseline\images\left\leftImages.mat')
%load('C:\Users\Richard\Documents\Projects\Sarcos\Snake\Calibration\FireflyWith5inchBaseline\images\right\rightImages.mat')
load(fullfile(pathnameL,filenameL))
[filenameR, pathnameR] = uigetfile(pwd, 'Select file where right image names are stored');
load(fullfile(pathnameR,filenameR))

squareSize = input('Enter calibration target square size: ');
% Calibration target square size is 48.5 for large Sarcos target

%%
%Detect the checkerboards.
[imagePoints,boardSize] = detectCheckerboardPoints(leftImages,...
    rightImages);

%%
% Specify the world coordinates of checkerboard keypoints.
worldPoints = generateCheckerboardPoints(boardSize,squareSize);

%%
% Calibrate the stereo camera system.
stereoParams = estimateCameraParameters(imagePoints,worldPoints, 'NumRadialDistortionCoefficients',3);

%%
% Read in the images.
I1 = imread(leftImages{1});
I2 = imread(rightImages{1});

%%
% Rectify the images using the 'full' output view.
[J1_full,J2_full] = rectifyStereoImages(I1,I2, stereoParams,'OutputView','full');

%%
% Display the result.
figure;
imshowpair(J1_full,J2_full,'falsecolor','ColorChannels','red-cyan');

%%
% Rectify the images using the 'valid' output view
[J1_valid,J2_valid] = rectifyStereoImages(I1,I2,stereoParams,'OutputView','valid');

%%
% Display the result.
figure;
imshowpair(J1_valid,J2_valid,'falsecolor','ColorChannels','red-cyan');

