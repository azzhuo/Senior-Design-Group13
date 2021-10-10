%% ECE 4950 Fall 2020 Project 2 - Game State Sensor
close all
clc
clear
clear('cam')
%% Check Camera List
cam_list = webcamlist;

%% Assign webcam to be used
% Pick an index from the camera list above
cam_name = cam_list{1};

%% Check webcam properties
cam = webcam(cam_name);

%% Preview cam
preview(cam)

%% Close Preview
closePreview(cam)

%% Snapshot 1 of background
img = snapshot(cam);

figure();
imshow(img)
title('Background')

%% Snapshot 2 with changes
img2 = snapshot(cam);

figure();
imshow(img2)
title('Changed')

%% test grabbing changed pixels
img3 = imread('NoiseBackground.png');
img4 = imread('StickersWithNoise.png');

imgdiff = img3 - img4;
figure();
imshow(imgdiff);
title('Background Subtraction Image');

%% convert to binary
bi = imgdiff;
b2 = bi;
[height,width,depth] = size(img3);
for i=1:height
    for j=1:width
        if (bi(i,j,1) > 2) || ...
           (bi(i,j,2) > 2) || ...
           (bi(i,j,3) > 2)
            
            %Will Show in Green
            b2(i,j,:) = [175,200,175];
        end
    end
end
binary = im2bw(b2);
figure();
imshow(binary);
title('Binary');

%% get isolated shapes
info = regionprops(binary, 'all');

%% get isolated colors
oppo = img4;
for i=1:height
    for j=1:width
        if (binary(i,j,1) > 0)
            
            %Will Show in Green
            oppo(i,j,1) = img4(i,j,1);
            oppo(i,j,2) = img4(i,j,2);
            oppo(i,j,3) = img4(i,j,3);
        else
            oppo(i,j,:) = [0,0,0];
        end
    end
end
figure();
imshow(oppo);
title('Colors');

%% struct for identifying colors and location
gameState.wellLoc=[30,60,90,135,180,-45,-90,-120,-150]; %All of the well locations, length = n
gameState.wellColor=[0,0,1,0,2,0,0,4,0]; % Color of stickers in the desired configuration,
% Length = n,colors described in "key"
gameState.key={'0', 'Empty';'1', 'Red'; '2', 'Green'; '3', 'Yellow'; '4','Blue'}; %Key


%% convert to hsv

hsvimg = rgb2hsv(oppo);

figure();
imshow(hsvimg);
title('test');

%% find shape
out = strings(length(info),1);
for i=1:length(info)
   % do we want to check for area size?
   %if ( info(i).Area > 1000 )
   circ = info(i).Circularity;
  if (circ >= .9)
      out{i,1}= 'circle';
  elseif (circ < .9 && circ >= .7)
      out{i,1}= 'square';
  elseif (circ < .7 && circ >= .5)
      out{i,1}= 'triangle';
  else
      out{i,1}= 'unknown';
  end

end
    
