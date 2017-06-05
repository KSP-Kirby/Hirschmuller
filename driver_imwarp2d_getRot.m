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
% Read in the images to warp.
I1 = imread(leftImages{1});
I2 = imread(rightImages{1});

[im,newOrigin] = undistortImage(I1,stereoParams.CameraParameters1,'OutputView','full');

%Find reference object in new image.
[imagePoints,boardSize] = detectCheckerboardPoints(im);

%Compensate for image coordinate system shift.
imagePoints = [imagePoints(:,1) + newOrigin(1), ...
             imagePoints(:,2) + newOrigin(2)];
         
%Compute new extrinsics.
[rotationMatrix, translationVector] = extrinsics(imagePoints,worldPoints,stereoParams.CameraParameters1);

%Compute camera pose.
[orientation, location] = extrinsicsToCameraPose(rotationMatrix, ...
  translationVector);
figure
plotCamera('Location',location,'Orientation',orientation,'Size',20);
hold on
pcshow([worldPoints,zeros(size(worldPoints,1),1)], ...
  'VerticalAxisDir','down','MarkerSize',40);