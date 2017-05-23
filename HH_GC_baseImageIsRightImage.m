function [fp] = HH_GC_baseImageIsRightImage(I1, I2, Di1i2)
% This function runs graphs cuts for the HH algorithm and returns the set 
% of labels computed.  It takes the rectified input images (I1 and I2), the 
% estimated disparity map, f0, and the mutual information data term, h, 
% from Kim's and then Hirschmuller's papers.  GC is the Boykov algorithm as
% implemented by Veksler.

% h is expected to be a 256x256 array of joint intensity probabilities.  It
% is used as a lookup table to determine costs based on the intensities of
% suspected corresponding pixels.  Equations (11) and (12) in Kim explain
% how this works.  (11) shows how the computation of D(i1,i2) is computed
% and (12) shows how D(i1,i2) is converted to Dp(fp).  In otherwords a cost
% based on pixel intensities is converted to a cost for a given pixel pair
% (p,q) by using the mutual information of the corresponding intensities
% for pixel p and pixel q and looking up that value in h.

% base image is right image

    addpath('C:\Users\Richard\Documents\MATLAB\gco-v3.0\matlab')      % This is where the Veksler/Delong Matlab wrapper is on my computer, change if needed.
    
    if size(I1) ~= size(I2)
        disp('Images must be the same size')
        fp = -1;
        return;
    end
        
    [m, n, p] = size(I1);
    if p~= 1
        I1 = rgb2gray(I1);
    end
    
    [m, n, p] = size(I2);
    if p~= 1
        I2 = rgb2gray(I2);
    end
    
    numSites = m*n;
    
    smoothingFactor = 10; % Scales the smoothing cost vs. the data cost 
    horzNeighborMaskWeight = 1; % Weights the neighborhood
    verticalNeighborMaskWeight = 1;
    dataFactor = 100;
    
    % labels are disaprity in pixels
    minLabel = 1;
    maxLabel = 64;
    labels = (minLabel:1:maxLabel);
    numLabels = length(labels);
    h = GCO_Create(numSites,numLabels);
    
    %compute data cost using mutual information
    dataCost = zeros(numLabels, m*n)+30;  % this assigns all sites an arbitrarily large cost to start
    site = 1;
    h1 = waitbar(0, 'Constructing data cost matrix');
    for i = 1:m
        for j = 1:n
            for k = 1:numLabels
                if j+labels(k) <= n
                    intensityOfPixelLeftImage = I1(i,j+labels(k));
                    intensityOfPixelRightImage = I2(i,j);
                    cost = Di1i2(intensityOfPixelLeftImage+1, intensityOfPixelRightImage+1);
                    dataCost(k,site) = Di1i2(intensityOfPixelLeftImage+1, intensityOfPixelRightImage+1);
                end
            end
            site = site+1;
        end
        waitbar(i/m)
    end
    close(h1)
    
    minDataCost = min(min(dataCost));
    maxDataCost = max(max(dataCost));

    %scale data cost between 1 and 1000

    %scaleFactor = 50/maxDataCost;
    dataCost = dataFactor*dataCost;


    GCO_SetDataCost(h,cast(dataCost,'int32'));

    % Smooth cost is number of labels by number of labels
    smoothCost = zeros(numLabels, numLabels);
    
    % this is an L1 norm
    for i = 1:numLabels
        smoothCost(i,:) = abs((1:1:numLabels) - i);
    end
    
    % this is Pott's
%     for i = 1:numLabels
%       smoothCost(i,i) = 1;
%     end
    

    smoothCost = smoothCost*smoothingFactor;

    GCO_SetSmoothCost(h,cast(smoothCost, 'int32'));

    neighbors = sparse(numSites,numSites);

    colCount = 1;
    for i = 1:numSites-1
        if i ~= n
            neighbors(i,i+1) = horzNeighborMaskWeight;      % must be upper triangle
            colCount = colCount + 1;
        else
            colCount = 1;       % this prevents wrapping from the end of one roll to the start of the next
        end
    end

    for i = 1:numSites-n - 1
        neighbors(i,i+n) = verticalNeighborMaskWeight;
    end

    GCO_SetNeighbors(h,neighbors);

    GCO_Expansion(h);

    [E, D, S] = GCO_ComputeEnergy(h); 

    fp = cast(GCO_GetLabeling(h),'double');

    GCO_Delete(h);
    
%     fp = reshape(fp,288,384);
%     imtool(fp);
end

