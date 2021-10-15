% Test code for the camera sticker test

%% Setup and grab background image
clear;
clc;
close all;
delete(imaqfind); % In case it was open

% Setup Camera 
vid = videoinput('winvideo', 2, 'YUY2_640x480');

% Camera loop
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = 1;
vid.ReturnedColorspace = 'rgb';
start(vid);

for index = 0:30
    data = getdata(vid,1);
end
backgroundimg = data(:,:,:,1);
imwrite(backgroundimg, 'bkgd.jpg');
preview(vid);

figure();
imshow(backgroundimg);
title('Background Image');

% Cleanup 
stop(vid);
delete(imaqfind)

%% Run camera analysis

% Setup Camera 
delete(imaqfind);
vid = videoinput('winvideo', 2, 'YUY2_640x480');
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = 30;
vid.ReturnedColorspace = 'rgb';
start(vid);

% Capture an image
for index = 0:10
    data = getdata(vid,1);
end
img = data(:,:,:,1);

figure(); title('foreground')
imshow(img);
imwrite(img, 'fgd.jpg');

gameState = GameStateIdentification(backgroundimg, img, true);
disp('Done')
imshow(gameState.IstickersLabeled);

% Cleanup 
stop(vid);
delete(imaqfind)

length = size(gameState.stickers, 2);
disp(length);
for index = 1:length
    disp(gameState.stickers{index}.centroid)
end
