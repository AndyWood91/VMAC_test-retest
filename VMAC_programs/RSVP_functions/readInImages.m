%% Read in images
function [imageTexture, numImages, targetRotation] = readInImages(inputFoldername, readingTargetImages)

global MainWindow

inputFilenames = dir(inputFoldername);

testStringPos = zeros(length(inputFilenames), 1);
fullTargetRotation = zeros(length(inputFilenames), 1);

for ii = 1 : length(inputFilenames)
    testStringPosUpper = strfind(inputFilenames(ii).name, '.JPG');
    testStringPosLower = strfind(inputFilenames(ii).name, '.jpg');
    
    if ~isempty(testStringPosUpper)
        testStringPos(ii) = testStringPosUpper;
    elseif ~isempty(testStringPosLower)
        testStringPos(ii) = testStringPosLower;
    else
        testStringPos(ii) = NaN;
    end
    
    if readingTargetImages
        if ~isnan(testStringPos(ii))
            LRcharacter = inputFilenames(ii).name(testStringPos(ii) - 1);
            if strcmp(LRcharacter, 'L')
                fullTargetRotation(ii) = 1;
            elseif strcmp(LRcharacter, 'R')
                fullTargetRotation(ii) = 2;
            else
                disp('Target rotation error');
            end
        else
            fullTargetRotation(ii) = NaN;
        end
        
        
    end
end

jpgFilenameArray = inputFilenames(~isnan(testStringPos));

if readingTargetImages
    targetRotation = fullTargetRotation(~isnan(testStringPos));
else
    targetRotation = 0;
end

numImages = length(jpgFilenameArray);

imageTexture = [];

for ii = 1 : numImages
    imgMatrix = imread([inputFoldername, '/', jpgFilenameArray(ii).name], 'jpg');
%        imageHeight = size(imgMatrix,1);
%        imageWidth = size(imgMatrix,2);
    imageTexture(ii) = Screen('MakeTexture', MainWindow, imgMatrix);
end


end