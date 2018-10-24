% Digital output function
% Example: 
% DigitalOutput('PXI1Slot3',1,0,0)

function DigitalOutput(devName,portNumber,lineNumber, state)
% Add everything to the path
addpath (genpath('C:\Users\Administrateur.TRESSARD-T7910\Documents\'))

% Default values
if nargin == 0
    devName = 'PXI1Slot3';        
    portNumber = 1;             
    lineNumber = 0;
    state = 1;
end

% Create a task
import dabs.ni.daqmx.*
hTask = Task('Digital Output task');

try
    hTask.createDOChan(devName,sprintf('port%d/line%d',portNumber,...
    lineNumber));
    hTask.writeDigitalData(state);
catch ME
    disp(ME.message)
end

delete(hTask)

end