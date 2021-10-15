
% Needs to be modified to take in the camera image as a parameter
% with the background image
function [gameState] = GameStateIdentification(backimg, foreimg, showImages)

    % Load in test images
    gameState.Ibackground = backimg;
    gameState.Iforeground = foreimg;

    % Show background image for testing
    if showImages == true
        figure();   
        imshow(gameState.Ibackground);
        title('Background');
    end

    % Show background with foreground for testing
    if showImages == true
        figure();
        imshow(gameState.Iforeground);
        title('Foreground');
    end

    % Convert input images to black and white
    gameState.IbackgroundGrayscale = rgb2gray(gameState.Ibackground);
    gameState.IforegroundGrayscale = rgb2gray(gameState.Iforeground);

    % Show the background image in grayscale for testing
    if showImages == true
        figure();   
        imshow(gameState.IbackgroundGrayscale);
        title('Background Grayscale');
    end

    % Show the foreground image in grayscale for testing
    if showImages == true
        figure();  
        imshow(gameState.IforegroundGrayscale);
        title('Foreground Grayscale');
    end
    
    % Initialize the gameState struct
    gameState.stickers = {};
    
    % Perform background subtraction
    gameState.Idifference = imsubtract(gameState.IbackgroundGrayscale,gameState.IforegroundGrayscale);

    % Show the background subtraction difference image for testing
    if showImages == true
        figure();     
        imshow(gameState.Idifference);
        title('Background Subtraction');
    end

    % Convert the difference image to a binary image
    gameState.IbinaryDifference = im2bw(gameState.Iforeground, 0.15);

    % Show the difference image (binary) for testing
    if showImages == true
        figure(); 
        imshow(gameState.IbinaryDifference);
        title('Binary Background Subtraction');
    end

    
    
    % Morphological operations to remove noise from the binary image
    se1 = strel('disk', 10);
    se4 = strel('disk', 20);
    gameState.IdifferenceClean = gameState.IbinaryDifference;
    gameState.IdifferenceClean = imerode(gameState.IdifferenceClean, se1);   
    gameState.IdifferenceClean = imdilate(gameState.IdifferenceClean, se4);
   

    % Show cleaned up image for testing
    if showImages == true
        figure();
        imshow(gameState.IdifferenceClean);
        title('Cleaned up image');
    end

    % Mask the RGB original image with the binary mask of sticker locations
    gameState.IMask = repmat(gameState.IdifferenceClean, [1, 1, 3]);
    gameState.IMasked = gameState.Iforeground;
    gameState.IMasked(~gameState.IMask) = 0;

    
    % Show the masked image for testing
    if showImages == true
        figure();
        imshow(gameState.IMasked);
        title('Masked');
    end
    
    mask = gameState.IMasked;
    imwrite(mask, 'mask.jpg');


    % Shape identification Paramters %%% IIFJJFSJFSKLDJFLKSJlkfj
    circleCircularityMin = 0.97;
    circleRMin = 16;
    circlePerimeterMin = 185;
    squarePerimeterMin = 140;
    squareRMin = 13;
    colorTestImage = gameState.IMasked;


    % Identify Red Areas
    [gameState.IredBinary, gameState.Ired] = rFilter(colorTestImage);

    % Remove Noise
    se1 = strel('disk', 3);
    se2 = strel('disk', 25);
    se3 = strel('disk', 10);
    gameState.IredBinary = imerode(gameState.IredBinary, se1);
    gameState.IredBinary = imclose(gameState.IredBinary, se2);
    gameState.IredBinary = imdilate(gameState.IredBinary, se3);

    % Identify region locations
    s = regionprops(gameState.IredBinary, 'Area', 'Centroid', 'Circularity', 'Perimeter');
    centroids = cat(1,s.Centroid);
    circularity = cat(1,s.Circularity);
    areas = cat(1, s.Area);
    perimeter = cat(1, s.Perimeter);
    length = size(centroids, 1);

    % Add the analyzed red sticker struct to the sticker list
    for index = 1:length
        sticker.area = areas(index, :);
        sticker.color = 'Red';
        sticker.centroid = centroids(index, :);
        sticker.circularity = circularity(index);
        sticker.perimeter = perimeter(index, :);
        sticker.r = sticker.area / sticker.perimeter;
        % Determine the shape based of the circularity
        if sticker.r > circleRMin
            sticker.shape = 'Circle';
        elseif sticker.r > squareRMin 
            sticker.shape = 'Square';
        else 
            sticker.shape = 'Triangle';
        end
        gameState.stickers = [gameState.stickers, sticker];
    end

    % Show red areas for testing
    if showImages == true
        figure(); 
        imshow(gameState.IredBinary);
        title('Red Regions');
    end

    
    
    % Identify Green Areas
    [gameState.IgreenBinary, gameState.Igreen] = gFilter(colorTestImage);

    % Remove Noise
    se1 = strel('disk', 3);
    se2 = strel('disk', 25);
    gameState.IgreenBinary = imerode(gameState.IgreenBinary, se1);
    gameState.IgreenBinary = imclose(gameState.IgreenBinary, se2);
    gameState.IgreenBinary = imdilate(gameState.IgreenBinary, se3);

    % Identify region locations
    s = regionprops(gameState.IgreenBinary, 'Area', 'Centroid', 'Circularity', 'Perimeter');
    centroids = cat(1,s.Centroid);
    circularity = cat(1,s.Circularity);
    areas = cat(1, s.Area);
    perimeter = cat(1, s.Perimeter);
    length = size(centroids, 1);

    % Add the analyzed red sticker struct to the sticker list
    for index = 1:length
        sticker.area = areas(index, :);
        sticker.color = 'Green';
        sticker.centroid = centroids(index, :);
        sticker.circularity = circularity(index);
        sticker.perimeter = perimeter(index, :);
        sticker.r = sticker.area / sticker.perimeter;
        % Determine the shape based of the circularity
        if sticker.r > circleRMin
            sticker.shape = 'Circle';
        elseif sticker.r > squareRMin 
            sticker.shape = 'Square';
        else 
            sticker.shape = 'Triangle';
        end
        gameState.stickers = [gameState.stickers, sticker];
    end

    % Show green areas for testing
    if showImages == true
        figure(); 
        imshow(gameState.IgreenBinary);
        title('Green Regions');
    end

    
    
    
    % Identify Blue Areas
    [gameState.IblueBinary, gameState.Iblue] = bFilter(colorTestImage);

    % Remove Noise
    se1 = strel('disk', 3);
    se2 = strel('disk', 25);
    gameState.IblueBinary = imerode(gameState.IblueBinary, se1);
    gameState.IblueBinary = imclose(gameState.IblueBinary, se2);
    gameState.IblueBinary = imdilate(gameState.IblueBinary, se3);

    % Identify region locations
    s = regionprops(gameState.IblueBinary, 'Area', 'Centroid', 'Circularity', 'Perimeter');
    centroids = cat(1,s.Centroid);
    circularity = cat(1,s.Circularity);
    perimeter = cat(1, s.Perimeter);
    areas = cat(1, s.Area);
    length = size(centroids, 1);

    % Add the analyzed red sticker struct to the sticker list
    for index = 1:length
        sticker.area = areas(index, :);
        sticker.color = 'Blue';
        sticker.centroid = centroids(index, :);
        sticker.perimeter = perimeter(index, :);
        sticker.circularity = circularity(index);
        sticker.r = sticker.area / sticker.perimeter;
        % Determine the shape based of the circularity
        if sticker.r > circleRMin
            sticker.shape = 'Circle';
        elseif sticker.r > squareRMin 
            sticker.shape = 'Square';
        else 
            sticker.shape = 'Triangle';
        end
        gameState.stickers = [gameState.stickers, sticker];
    end

    % Show blue areas for testing
    if showImages == true
        figure(); 
        imshow(gameState.IblueBinary);
        title('Blue Regions');
    end

    
    
    
    % Identify Yellow Areas
    [gameState.IyellowBinary, gameState.Iyellow] = yFilter(colorTestImage);

    % Remove Noise
    se1 = strel('disk', 3);
    se2 = strel('disk', 25);
    gameState.IyellowBinary = imerode(gameState.IyellowBinary, se1);
    gameState.IyellowBinary = imclose(gameState.IyellowBinary, se2);
    gameState.IyellowBinary = imdilate(gameState.IyellowBinary, se3);
    

    % Identify region locations
    s = regionprops(gameState.IyellowBinary, 'Area', 'Centroid', 'Circularity', 'Perimeter');
    centroids = cat(1,s.Centroid);
    circularity = cat(1,s.Circularity);
    areas = cat(1, s.Area);
    perimeter = cat(1, s.Perimeter);
    length = size(centroids, 1);

    % Add the analyzed red sticker struct to the sticker list
    for index = 1:length
        sticker.area = areas(index, :);
        sticker.color = 'Yellow';
        sticker.perimeter = perimeter(index, :);
        sticker.centroid = centroids(index, :);
        sticker.circularity = circularity(index, :);
        sticker.r = sticker.area / sticker.perimeter;
        % Determine the shape based of the circularity
        if sticker.r > circleRMin
            sticker.shape = 'Circle';
        elseif sticker.r > squareRMin 
            sticker.shape = 'Square';
        else 
            sticker.shape = 'Triangle';
        end
        gameState.stickers = [gameState.stickers, sticker];
    end

    % Show yellow areas for testing
    if showImages == true
        figure(); 
        imshow(gameState.IyellowBinary);
        title('Yellow Regions');
    end

    % Assemble the image of just the stickers
    gameState.Istickers = gameState.Iyellow + gameState.Igreen + gameState.Iblue + gameState.Ired;

    % Show the sticker only image for testing
    if showImages == true
        figure();
        imshow(gameState.Istickers);
    end
    
    % Label the regions with the results
    RGB = gameState.Istickers;
    markerSize = 10;
    for index = 1:size(gameState.stickers, 2)   
        if strcmp(gameState.stickers{index}.color, 'Red')
            if strcmp(gameState.stickers{index}.shape, 'Square')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid,'s','color','red','size',30);
            elseif strcmp(gameState.stickers{index}.shape, 'Circle')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid,'o','color','red','size',30);
            elseif strcmp(gameState.stickers{index}.shape, 'Triangle')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, '*','color','red','size',30);
            end
         elseif strcmp(gameState.stickers{index}.color, 'Green')
            if strcmp(gameState.stickers{index}.shape, 'Square')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, 's','color','green','size',30);
            elseif strcmp(gameState.stickers{index}.shape, 'Circle')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, 'o','color','green','size',30);
            elseif strcmp(gameState.stickers{index}.shape, 'Triangle')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, '*','color','green','size',30);
            end
         elseif strcmp(gameState.stickers{index}.color, 'Blue')
            if strcmp(gameState.stickers{index}.shape, 'Square')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, 's','color','blue','size',30);
            elseif strcmp(gameState.stickers{index}.shape, 'Circle')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, 'o','color','blue','size',30);
            elseif strcmp(gameState.stickers{index}.shape, 'Triangle')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, '*','color','blue','size',30);
            end
         elseif strcmp(gameState.stickers{index}.color, 'Yellow')
            if strcmp(gameState.stickers{index}.shape, 'Square')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, 's','color','yellow','size',30);
            elseif strcmp(gameState.stickers{index}.shape, 'Circle')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, 'o','color','yellow','size',30);
            elseif strcmp(gameState.stickers{index}.shape, 'Triangle')
                RGB = insertMarker(RGB, gameState.stickers{index}.centroid, '*','color','yellow','size',30);
            end 
         end
    end
    gameState.IstickersLabeled = RGB;
    
    % Show the labeled sticker for testing
    if showImages == true
        figure();
        imshow(gameState.IstickersLabeled);
    end

end
