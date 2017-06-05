% this is a development script for rotating an image in x, y, and z

% create a test image

m = 480;
n = 640;
im = ones(m,n)*255;
im(50:end-50,50:end-50) = 0;
im(100:end-100,100:end-100) = 127;
im(150:end-150,150:end-150) = 255;

% % XYZ intrisic rotation angles from IMU to camera
thetaX = 0;
thetaY = 0;
thetaZ = 5*pi/180;;

% Rotation matrices for three intrinsic rotations
Rx = [1, 0, 0; 0, cos(thetaX), -sin(thetaX);0, sin(thetaX), cos(thetaX)];
Ry = [cos(thetaY), 0, sin(thetaY);0,1,0;-sin(thetaY), 0, cos(thetaY)];
Rz = [cos(thetaZ), -sin(thetaZ), 0; sin(thetaZ), cos(thetaZ), 0;0,0,1];

R = Rx*Ry*Rz;

im2 = zeros(m,n);

for i = 1:m
    for j = 1:n
        c = R*[i,j,1]';
        if c(1) >=1 && c(2) >=1
            im2(round(c(1)),round(c(2))) = im(i,j);
        end          
    end
end


imtool(im2/256)