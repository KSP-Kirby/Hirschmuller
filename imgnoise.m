function [ Iout ] = imgnoise( I1, I2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

    levelShift = 20;
    
    [m,n,p] = size(I1);
    if p > 1
        I1 = rgb2gray(I1);
    end
    
    sigma_G = 1;
    I1 = imgaussfilt(I1,sigma_G);
    %imtool(I)
    
    for i = 1:m
        for j = 1:n
            I1out(i,j) = I1(i,j)+(randn)*2;
        end
    end

    imtool(I1out)
    
    [m,n,p] = size(I2);
    if p > 1
        I1 = rgb2gray(I2);
    end
    
    sigma_G = 1;
    I2 = imgaussfilt(I2,sigma_G);
    %imtool(I)
    
    for i = 1:m
        for j = 1:n
            I2out(i,j) = I2(i,j)+(randn)*2;
        end
    end
    
    I2out = I2out+levelShift;
    
    for i = 1:m
        for j = 1:n
            if I2out(i,j) > 255
                I2out = 255;
            end
        end
    end

    imtool(I2out)

end

