root1 = uigetdir(pwd,'Select directory where left camera calibration images are saved.');
rootL = strcat(root1,'\L');
root2 = uigetdir(pwd,'Select directory where right camera calibration images are saved.');
rootR = strcat(root2,'\R');
numImages = input('Number of images: ');

imageNumbers = 1:1:numImages;

for i = 1:length(imageNumbers)
    %if i < 10
    %    leftImages{i} = strcat(rootL,'0',num2str(imageNumbers(i)),'.pgm');
    %else
        leftImages{i} = strcat(rootL,num2str(imageNumbers(i)),'.pgm');
    %end
end

save(strcat(root1,'\','leftImages'), 'leftImages');

for i = 1:length(imageNumbers)
    %if i < 10
    %    rightImages{i} = strcat(rootR,'0',num2str(imageNumbers(i)),'.pgm');
    %else
        rightImages{i} = strcat(rootR,num2str(imageNumbers(i)),'.pgm');
    %end
end

save(strcat(root2,'\','rightImages'), 'rightImages');