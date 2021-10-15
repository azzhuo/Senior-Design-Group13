f = imread('fgd.jpg');
b = imread('bkgd.jpg');
gameState = GameStateIdentification(b, f, true);
disp('Done')


