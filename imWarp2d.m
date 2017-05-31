function Iout = imWarp2d(I, D)
% Warps image I per depth map D
% Assumes epipolar lines are horizontal
% for the moment it assumes the input image is grayscale
% the disparity function in MATLAB gives


    [m,n] = size(D);
    Iout = zeros(size(I));

    for i = 1:m
        for j = 1:n
            if D(i,j) > -1000       % make sure there is a disparity value
                pixelXLocation = round(j - D(i,j));
                if pixelXLocation >= 1 && pixelXLocation <=n
                    Iout(i,j) = I(i, pixelXLocation);
                end
            end
        end
    end


end

