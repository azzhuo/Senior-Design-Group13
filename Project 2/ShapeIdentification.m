%% ECE 4940 Senior Design I (Group 13)
% October 12, 2021
% Jackson Delk
% Project part II test

clear; 
clc;
close all;

%% Load in test images

gameState.Ibackground = imread('Background.jpg');
gameState.Iforeground = imread('Foreground.jpg');

figure();
imshow(gameState.Ibackground)

figure();
imshow(gameState.Iforeground)


%% Convert input images to black and white
gameState.IbackgroundGrayscale = rgb2gray(gameState.Ibackground);
gameState.IforegroundGrayscale = rgb2gray(gameState.Iforeground);

figure()
imshow(gameState.IbackgroundGrayscale)

figure()
imshow(gameState.IforegroundGrayscale)

%% Perform background subtraction

gameState.stickers = {};
gameState.Idifference = imsubtract(gameState.IbackgroundGrayscale,gameState.IforegroundGrayscale);

figure();
imshow(gameState.Idifference);

gameState.IbinaryDifference = im2bw(gameState.Idifference, 0.05);

figure();
imshow(gameState.IbinaryDifference);

%% Morphological operations to remove noise from the binary image

se1 = strel('disk', 20);
gameState.IdifferenceOpened = imopen(gameState.IbinaryDifference, se1);

se2 = strel('disk', 75);
gameState.IdifferenceClosed = imdilate(gameState.IdifferenceOpened, se2);

figure();
imshow(gameState.IdifferenceOpened);

figure();
imshow(gameState.IdifferenceClosed);


gameState.IMask = repmat(gameState.IdifferenceClosed, [1, 1, 3]);
gameState.IMasked = gameState.Iforeground;
gameState.IMasked(~gameState.IMask) = 0;

figure();
imshow(gameState.IMasked);




%% Identify Red Areas
[gameState.IredBinary, gameState.Ired] = RedFilter(gameState.Iforeground);

% Remove Noise
se = strel('disk', 10);
Ired = imerode(gameState.IredBinary, se);

% Identify region locations
s = regionprops(gameState.IredBinary, 'Centroid', 'Circularity');
centroids = cat(1,s.Centroid);
circularity = cat(1,s.Circularity);
length = size(centroids, 1);

for index = 1:length
    sticker.color = 'Red';
    sticker.centroid = centroids(index, :);
    sticker.circularity = circularity(index);
    % Determine the shape based of the circularity
    if sticker.circularity > 0.9
        sticker.shape = 'Circle';
    elseif sticker.circularity > 0.75
        sticker.shape = 'Square';
    else 
        sticker.shape = 'Triangle';
    end
    gameState.stickers = [gameState.stickers, sticker];
end

figure(); 
imshow(gameState.IredBinary);
title('Red Regions');

%% Identify Green Areas
[gameState.IgreenBinary, gameState.Igreen] = GreenFilter(gameState.Iforeground);

% Remove Noise
se = strel('disk', 10);
gameState.IgreenBinary = imerode(gameState.IgreenBinary, se);

% Identify region locations
s = regionprops(gameState.IgreenBinary, 'Centroid', 'Circularity');
centroids = cat(1,s.Centroid);
circularity = cat(1,s.Circularity);
length = size(centroids, 1);

for index = 1:length
    sticker.color = 'Green';
    sticker.centroid = centroids(index, :);
    sticker.circularity = circularity(index);
    % Determine the shape based of the circularity
    if sticker.circularity > 0.9
        sticker.shape = 'Circle';
    elseif sticker.circularity > 0.75
        sticker.shape = 'Square';
    else 
        sticker.shape = 'Triangle';
    end
    gameState.stickers = [gameState.stickers, sticker];
end

figure(); 
imshow(gameState.IgreenBinary);
title('Green Regions');

%% Identify Blue Areas
[gameState.IblueBinary, gameState.Iblue] = BlueFilter(gameState.Iforeground);

% Remove Noise
se = strel('disk', 10);
gameState.IblueBinary = imerode(gameState.IblueBinary, se);

% Identify region locations
s = regionprops(gameState.IblueBinary, 'Centroid', 'Circularity');
centroids = cat(1,s.Centroid);
circularity = cat(1,s.Circularity);
length = size(centroids, 1);

for index = 1:length
    sticker.color = 'Blue';
    sticker.centroid = centroids(index, :);
    sticker.circularity = circularity(index);
    % Determine the shape based of the circularity
    if sticker.circularity > 0.9
        sticker.shape = 'Circle';
    elseif sticker.circularity > 0.75
        sticker.shape = 'Square';
    else 
        sticker.shape = 'Triangle';
    end
    gameState.stickers = [gameState.stickers, sticker];
end

figure(); 
imshow(gameState.IblueBinary);
title('Blue Regions');

%% Identify Yellow Areas
[gameState.IyellowBinary, gameState.Iyellow] = YellowFilter(gameState.Iforeground);

% Remove Noise
se = strel('disk', 10);
gameState.IyellowBinary = imerode(gameState.IyellowBinary, se);

% Identify region locations
s = regionprops(gameState.IyellowBinary, 'Centroid', 'Circularity');
centroids = cat(1,s.Centroid);
circularity = cat(1,s.Circularity);
length = size(centroids, 1);

for index = 1:length
    sticker.color = 'Yellow';
    sticker.centroid = centroids(index, :);
    sticker.circularity = circularity(index);
    % Determine the shape based of the circularity
    if sticker.circularity > 0.9
        sticker.shape = 'Circle';
    elseif sticker.circularity > 0.75
        sticker.shape = 'Square';
    else 
        sticker.shape = 'Triangle';
    end
    gameState.stickers = [gameState.stickers, sticker];
end

figure(); 
imshow(gameState.IyellowBinary);
title('Yellow Regions');

%% Assemble the image of just the stickers
gameState.Istickers = gameState.Iyellow + gameState.Igreen + gameState.Iblue + gameState.Ired;

figure();
imshow(gameState.Istickers);


