function Iout = blobFilter(fp)
    % Removes blobs from disparity data 

    im = fp;
    
    disparityLevels = 64;
    steps = 10;
    out = zeros(size(fp));
    for j = 1:steps:disparityLevels
        range=(im >= j & im <= j+steps);    % creates a binary image that has disparity leves between j and i+steps
        CC = bwconncomp(range,4);           % finds connected components for binary image and labels them
        L = labelmatrix(CC);                % creates a label image for the connected components
        histL = imhist(L);
        threshold = 20;

        for i = 2:length(histL)
            if histL(i) >= threshold
                out = out + (L == i-1)*i;     % relabel image using the disparity level for all connected components
            end
        end
    end
    Iout = logical(out).*fp;
end