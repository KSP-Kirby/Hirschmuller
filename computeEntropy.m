function [h] = computeEntropy( I1, I2w )
% Returns the entropy per the Kim and the Hirschmuller papers
% I1 is the base image
% I2w is the match image warped back using the previous disparity map (f0
% in paper).  The size of I1 must equal the size of I2w

    numIntensities = 256;
    P = zeros(numIntensities);  % rows are intensities of image 2 warped by disparity map

    %reshape images
    [m, n, p] = size(I1);
    Ib = reshape(I1(:,:,1),[m*n,1]);
    Iq = reshape(I2w(:,:,1),[m*n,1]);
    
    % uncomment this to verify I get a diagonal line as described by
    % Hirschmuller and Kim
    % Iq = Ib;
    
    % This is the counting done in (6)
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
    
    sigma_G = 0.5;
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

