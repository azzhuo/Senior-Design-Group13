
% Needs to be modified to take in the camera image as a parameter
% with the background image
function [gameState] = GameStateIdentification()

    % Load in test images
    gameState.Ibackground = imread('Background.jpg');
    gameState.Iforeground = imread('Foreground.jpg');

    % Show background image for testing
    figure();
    imshow(gameState.Ibackground)

    % Show background with foreground for testing
    figure();
    imshow(gameState.Iforeground)


    
    
    % Convert input images to black and white
    gameState.IbackgroundGrayscale = rgb2gray(gameState.Ibackground);
    gameState.IforegroundGrayscale = rgb2gray(gameState.Iforeground);

    % Show the background image in grayscale for testing
    figure()
    imshow(gameState.IbackgroundGrayscale)

    % Show the foreground image in grayscale for testing
    figure()
    imshow(gameState.IforegroundGrayscale) 
    
    % Initialize the gameState struct
    gameState.stickers = {};
    
    % Perform background subtraction
    gameState.Idifference = imsubtract(gameState.IbackgroundGrayscale,gameState.IforegroundGrayscale);

    % Show the background subtraction difference image for testing
    figure();
    imshow(gameState.Idifference);

    % Convert the difference image to a binary image
    gameState.IbinaryDifference = im2bw(gameState.Idifference, 0.05);

    % Show the difference image (binary) for testing
    figure();
    imshow(gameState.IbinaryDifference);

    
    
    % Morphological operations to remove noise from the binary image
    se1 = strel('disk', 20);
    gameState.IdifferenceOpened = imopen(gameState.IbinaryDifference, se1);
    se2 = strel('disk', 75);
    gameState.IdifferenceClosed = imdilate(gameState.IdifferenceOpened, se2);
    
    % Show cleaned up image for testing
    figure();
    imshow(gameState.IdifferenceOpened);

    % Show cleaned up image for testing
    figure();
    imshow(gameState.IdifferenceClosed);

    % Mask the RGB original image with the binary mask of sticker locations
    gameState.IMask = repmat(gameState.IdifferenceClosed, [1, 1, 3]);
    gameState.IMasked = gameState.Iforeground;
    gameState.IMasked(~gameState.IMask) = 0;

    % Show the masked image for testing
    figure();
    imshow(gameState.IMasked);




    % Identify Red Areas
    [gameState.IredBinary, gameState.Ired] = RedFilter(gameState.Iforeground);

    % Remove Noise
    se = strel('disk', 10);
    Ired = imerode(gameState.IredBinary, se);

    % Identify region locations
    s = regionprops(gameState.IredBinary, 'Centroid', 'Circularity');
    centroids = cat(1,s.Centroid);
    circularity = cat(1,s.Circularity);
    length = size(centroids, 1);

    % Add the analyzed red sticker struct to the sticker list
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

    % Show red areas for testing
    figure(); 
    imshow(gameState.IredBinary);
    title('Red Regions');

    
    
    % Identify Green Areas
    [gameState.IgreenBinary, gameState.Igreen] = GreenFilter(gameState.Iforeground);

    % Remove Noise
    se = strel('disk', 10);
    gameState.IgreenBinary = imerode(gameState.IgreenBinary, se);

    % Identify region locations
    s = regionprops(gameState.IgreenBinary, 'Centroid', 'Circularity');
    centroids = cat(1,s.Centroid);
    circularity = cat(1,s.Circularity);
    length = size(centroids, 1);

    % Add the analyzed red sticker struct to the sticker list
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

    % Show green areas for testing
    figure(); 
    imshow(gameState.IgreenBinary);
    title('Green Regions');

    
    
    
    % Identify Blue Areas
    [gameState.IblueBinary, gameState.Iblue] = BlueFilter(gameState.Iforeground);

    % Remove Noise
    se = strel('disk', 10);
    gameState.IblueBinary = imerode(gameState.IblueBinary, se);

    % Identify region locations
    s = regionprops(gameState.IblueBinary, 'Centroid', 'Circularity');
    centroids = cat(1,s.Centroid);
    circularity = cat(1,s.Circularity);
    length = size(centroids, 1);

    % Add the analyzed red sticker struct to the sticker list
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

    % Show blue areas for testing
    figure(); 
    imshow(gameState.IblueBinary);
    title('Blue Regions');

    
    
    
    % Identify Yellow Areas
    [gameState.IyellowBinary, gameState.Iyellow] = YellowFilter(gameState.Iforeground);

    % Remove Noise
    se = strel('disk', 10);
    gameState.IyellowBinary = imerode(gameState.IyellowBinary, se);

    % Identify region locations
    s = regionprops(gameState.IyellowBinary, 'Centroid', 'Circularity');
    centroids = cat(1,s.Centroid);
    circularity = cat(1,s.Circularity);
    length = size(centroids, 1);

    % Add the analyzed red sticker struct to the sticker list
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

    % Show yellow areas for testing
    figure(); 
    imshow(gameState.IyellowBinary);
    title('Yellow Regions');

    % Assemble the image of just the stickers
    gameState.Istickers = gameState.Iyellow + gameState.Igreen + gameState.Iblue + gameState.Ired;

    % Show the sticker only image for testing
    figure();
    imshow(gameState.Istickers);

end