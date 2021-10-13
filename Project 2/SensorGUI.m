function SensorGUI()
%SENSORGUI Summary of this function goes here
%   Detailed explanation goes here
fig = uifigure('Name','Sensor');
fig.Position(3:4) = [280 210];
stopbtn = uibutton(fig,'Text', 'Start','Position',[100,100, 100, 22],'ButtonPushedFcn', @(obj, event) testTime(obj, event));
         
           
           
end

function a = testTime(~, ~, a)
    a = mod(a+1,2);
    fprintf('a is %d\n',a);
end