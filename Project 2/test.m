% Test code for the camera sticker test
%% grab background image
clear;
clc;
close all;

% Setup Camera 
vid = videoinput('macvideo', 1, 'YCbCr422_640x480');
% Camera loop
set(vid,'TriggerRepeat',Inf);
vid.FrameGrabInterval = 30;
vid.ReturnedColorspace = 'rgb';
start(vid);
%%
data = getdata(vid,1);
backgroundimg = data(:,:,:,1);
preview(vid);
%% view background
figure();
imshow(backgroundimg);

%% loop camera
DlgH = figure;
H = uicontrol('Style', 'PushButton', ...
                    'String', 'Break', ...
                    'Callback', 'delete(gcbf)');
while(ishandle(H))
    data = getdata(vid,1);
    img = data(:,:,:,1);
    figure();
    %imshow(img);
    gameState = GameStateIdentification(backgroundimg, img);
end

%% 
stop(vid);
delete(imaqfind)

% Jackson's testing
%gameState = GameStateIdentification();
