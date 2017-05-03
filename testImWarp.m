function [D] = testImWarp( I1, I2 )
% This function is used for the development of imWarp

    D = disparity(rgb2gray(I1),rgb2gray(I2), 'Method','SemiGlobal', 'DisparityRange',[0 64],'BlockSize',17 );
    imtool(D/64);

    [m, n] = size(D);

    Dvis = double(ones(m,n,3));

    noDisp = 0;
    for i = 1:m
        for j = 1:n
            if D(i,j) < -1000
                Dvis(i,j,:) = [1, 0, 0];
                noDisp = noDisp+1;
            else
                %Dvis(i,j,:) = [D(i,j),D(i,j),D(i,j)];
            end
        end
    end

    imtool(Dvis)

    figure
    imshow(I1);
    hold on
    plot(256,218,'*r')
    hold off
    figure
    imshow(I2)
    hold on
    disp(strcat('D(242,218):',num2str(D(242,218))))
    plot(256-D(242,218),218,'*g')
    
    Iout = imWarp(I2,D);
    imtool(Iout)
    imtool(imfuse(I1,Iout))
    noDisp

end

