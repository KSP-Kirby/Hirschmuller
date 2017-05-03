function [ P ] = HH( I1, I2 )

    % for development purposes I start with one line.  Line 30 is one of the
    % worst lines for intensity mismatches
    Ib = I1(30,:,1);
    Im = I2(30,:,1);
    d = int16((Ib*0)+9);       % set initial disparity

    p1 = int16(1:1:length(Im));
    p2 = p1 - d;
    
    Iq = zeros(size(Ib));
    Iq(1:end-9) = Im(1+9:end);


%     figure
%     plot(Ib)
%     hold all
%     %plot(Im)
%     plot(Iq)
%     hold off
%     %legend('Ib', 'Im', 'Iq');
%     legend('Ib', 'Iq');
    
    

    % compute joint probability
    % the probability that pixel(i) is some Intensity given that pixel(k) is
    % some intensity.

    P = zeros(256);  % rows are intensities of image 2 warped by disparity map
                            % columns are the intensities of image 1
                            
    Ib = Ib + 1;    % shift intensity up by 1
    Iq = Iq + 1;    % shift intensity up by 1
    
    maxIntensity = 256;
    for i = 1:maxIntensity
        for j = 1:length(Iq)
            if Iq(j) == i           % for Iq(j) equal to the intensity value 
                P(i,Ib(j)) = P(i,Ib(j)) + 1;
            end
        end
    end

    %P = P/(length(Ib)*length(Ib));
    %imtool(imcomplement(P))
    sigma = 5;
    
    P1 = imgaussfilt(P,sigma);
    
    %imtool(P1)
    p1Max = max(max(P1));
    imtool(imcomplement(P1/p1Max))
    
    for i = 1:256
        for j = 1:256
            if P1(i,j) == 0
                P1(i,j) = 1e-10;
            end
        end
    end
    
    P2 = -log(P1);
    p2Max = max(max(P2));
    imtool(imcomplement(P2/p1Max))
    
    % Now working on a full image
    % Compute an initial guess of disparity
    D = disparity(rgb2gray(I1),rgb2gray(I2), 'Method','SemiGlobal', 'DisparityRange',[0 64],'BlockSize',17 );
    
    %check disparity map
    %imtool(D/64);
    
    %warp img2 to map to image 1
    Iout = imWarp(I2,D);
    %verify warp
    %imtool(imfuse(I1,Iout))
    
    %reshape images
    [m, n, p] = size(I1);
    Ib = reshape(I1(:,:,1),[m*n,1]);
    Iout(m,n,1) = 0; %quick way to make Iout the same size as Ib
    Iq = reshape(Iout(:,:,1),[m*n,1]);
    
    maxIntensity = 256;
    for i = 1:maxIntensity
        for j = 1:length(Iq)
            if Iq(j) == i           % for Iq(j) equal to the intensity value 
                P(i,Ib(j)) = P(i,Ib(j)) + 1;
            end
        end
    end
    
    pMax = max(max(P));
    imtool(imcomplement(P/pMax))
    
    
    P1 = imgaussfilt(P,sigma);
    P2 = -log(P1);
    p2Max = max(max(P2));
    imtool(imcomplement(P2/p1Max))

                
end

