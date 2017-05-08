function [ P, P1, P2, P3, h ] = HH( I1, I2 )
    % Implements Hirchmuller per the paper "Stereo Processing by Semi-Global
    % Matching and Mutual Information
    %
    % The first step in Hirschmuller is to compute the joint probability distribution, this is the P_I1,I2 in
    % equation (5) of Hirschmuller.  This is the joint probability of 
    % corresponding intensities.  The number of corresponding pixels is n.  
    % Equation (5) is: 
    %
    % h_I1,I2(i,k) = (-1/n)log(P_I1,I2(i,k)*g(i,k)*g(i,k) 
    % 
    % where '*' is the convolution operator, I1 is the base image, also labelled Ib,
    % I2 is the matching imaging warped using the current disparity map.  Since
    % P_I1,I2 is the joint probability of intensities, I'm assuming that i
    % are the intensities values (e.g. 0-255).  Equation (3) shows what I'm
    % assuming as the intensities as i1, and i2.  Equation 5 shows
    % P_I1,I2(i,l) which suggests that i is the intensity of p (a pixel) in
    % I1 and k is the intensity of p in I2.
    %
    % The joint probability is then defined in equation (6) as:
    % P_I1,I2(i,k) = (1/n)*(Sum over the pixels) of T[(i,k) = (I1p,I2p)]
    % where T[] is 1 if the argument is true and 0 otherwise.
    %
    % According to Hirschmuller, (6) is computed by counting the number of
    % pixels of all combinations of intensities, divide by the numer of all
    % correspondnces.
    % 
    % While not clear from the paper it appears that i  
    % probability that pixel(i) is some intensity given that pixel(k) is
    % some intensity.

    numIntensities = 256;
    P = zeros(numIntensities);  % rows are intensities of image 2 warped by disparity map

    % Compute an initial guess of disparity, should also try using a random
    % field per the paper
    numDisparities = 64;
    D = disparity(rgb2gray(I1),rgb2gray(I2), 'Method','SemiGlobal', 'DisparityRange',[0 numDisparities],'BlockSize',17 );
    
    % check disparity map
    % imtool(D/64);
    
    % warp img2 to map to image 1
    Iout = imWarp(I2,D);            % TODO: implement linear interpolation in imWarp
    % verify warp
    % imtool(imfuse(I1,Iout))
    
    %reshape images
    [m, n, p] = size(I1);
    Ib = reshape(I1(:,:,1),[m*n,1]);
    Iout(m,n,1) = 0; %quick way to make Iout the same size as Ib
    Iq = reshape(Iout(:,:,1),[m*n,1]);
    
    % uncomment this to verify I get a diagonal line as described by
    % Hirschmuller and Kim
    % Iq = Ib;
    
    % This is the counting done in (6)
    % this is faster than the method below, but the method 
    maxIntensity = 256;
    numCorrPix = 0;
    h = waitbar(0, 'Computing joint probability')
    for i = 1:maxIntensity
        for k = 1:maxIntensity
            for p = 1:length(Ib)
                if (i == Ib(p)) && (k == Iq(p))
                    P(i,k) = P(i,k) + 1;
                    numCorrPix = numCorrPix + 1;
                end
            end
        end
        waitbar(i/maxIntensity)
    end
    close(h);
    
    pMax = max(max(P));
    %imtool(imcomplement(P/pMax))
    
    % The line below gives me the results of equation (9) of Kim.  Kim
    % calls this P0 (the '0' is a superscript).
    P = P/numCorrPix;
    
    sigma_G = 7;
    % Kim calls this 'P' (equation (10))
    P1 = imgaussfilt(P,sigma_G);
    
    % make zeros very small numbers
    P2 = double(P1);
    for i = 1:numIntensities
        for j = 1:numIntensities
            if P2(i,j) < 0.0000001
                P2(i,j) = 0.0000001;
            end
        end
    end
    
    P3 = -log(P2);    
    h = imgaussfilt(P3,sigma_G);
end

