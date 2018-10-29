%% To merge  and 
%% system('python mergeDataPulse.py')
%%

function  holographicstimulation(varargin)

global obj
global deltapulse
global width 
global initialdelay 
global f 
global dutycycle
global nbpulse
global b
global c
global AIState
global DOState
global AIReading
global dataState
global tempHandleDO

addpath (genpath('C:\Users\Administrateur.TRESSARD-T7910\Documents\'))

if nargin==0
            flag=1;
       else
            flag=varargin{1};
end


switch flag
       
    case 1

AIReading = AIProcess('AIReading task');
% Set flags to false
dataState = false;



% DO channels figure
D.fh = figure('units','pixels',...
              'position',[1580 550 200 360],...
              'menubar','none',...
              'name','DigitalOutput',...
              'numbertitle','off',...
              'resize','off', 'Tag', 'do');

D.ls = uicontrol('style','list',...
                 'unit','pix',...
                 'position',[10 170 180 180],...
                 'min',0,'max',2,...
                 'fontsize',14);         
D.txt = uicontrol ('style','text',...
                 'unit','pix',...
                 'position',[10 140 180 30],...
                 'fontsize',14, ...
                 'string', 'Port num / Line num');      
            
D.ed = uicontrol('style','edit',...
                 'unit','pix',...
                 'position',[10 110 80 30],...
                 'fontsize',14);
D.ed2 = uicontrol('style','edit',...
                 'unit','pix',...
                 'position',[110 110 80 30],...
                 'fontsize',14);             
             
D.pb = uicontrol('style','push',...
                 'units','pix',...
                 'position',[10 60 180 40],...
                 'fontsize',14,...
                 'string','Add Channel',...
                 'callback',{@addDO,D});
D.pb2 = uicontrol('style','push',...
                 'units','pix',...
                 'position',[10 10 180 40],...
                 'fontsize',14,...
                 'string','Delete Channel',...
                 'callback',{@delDO,D});

             
% AI channels figure             
A.fh = figure('units','pixels',...
              'position',[1370 550 200 360],...
              'name','AnalogInput',...
              'menubar','none',...
              'numbertitle','off',...
              'resize','off');

A.ls = uicontrol('style','list',...
                 'unit','pix',...
                 'position',[10 170 180 180],...
                 'min',0,'max',2,...
                 'fontsize',14);         
A.txt = uicontrol ('style','text',...
                 'unit','pix',...
                 'position',[10 140 180 30],...
                 'fontsize',14, ...
                 'string', 'Analog ch num');      
            
A.ed = uicontrol('style','edit',...
                 'unit','pix',...
                 'position',[10 110 180 30],...
                 'fontsize',14);
        
             
A.pb = uicontrol('style','push',...
                 'units','pix',...
                 'position',[10 60 180 40],...
                 'fontsize',14,...
                 'string','Add Channel',...
                 'callback',{@addAI,A});
A.pb2 = uicontrol('style','push',...
                 'units','pix',...
                 'position',[10 10 180 40],...
                 'fontsize',14,...
                 'string','Delete Channel',...
                 'callback',{@delAI,A});



            
            %%figure de l'interface
obj.figA=figure('Units','pixels','Position',[1370 50 400 400],...
                'Name','Stimulation','NumberTitle','off');%%titre de la figure                     

    obj.pulseParamText = uicontrol ('Position', [108 360 175 40]', 'Style',...
                'text','String','Pulse parameters', 'fontsize',16);
            obj.but(2)=uicontrol('Units','pixels','Position',[10 340 75 30],...
                'Style','text','String','pulse duration');
            obj.but(3)=uicontrol('Units','pixels','Position',[10 305 75 30],...
                'Style','edit','String',0.2);
            obj.but(4)=uicontrol('Units','pixels','Position',[85 340 75 30],...
                'Style','text','String','duration between pulse');
            obj.but(5)=uicontrol('Units','pixels','Position',[85 305 75 30],...
                'Style','edit','String',0.05);    
            obj.but(6)=uicontrol('Units','pixels','Position',[160 340 75 30],...
                'Style','text','String','number of pulse');
            obj.but(7)=uicontrol('Units','pixels','Position',[160 305 75 30],...
                'Style','edit','String',2);
            obj.but(8)=uicontrol('Units','pixels','Position',[235 340 75 30],...
                'Style','text','String','startdelay (frames)');
            obj.but(9)=uicontrol('Units','pixels','Position',[235 305 75 30],...
                'Style','edit','String',5);
            obj.but(10)=uicontrol('Units','pixels','Position',[310 340 75 30],...
                'Style','text','String','frequency of scanner');
            obj.but(11)=uicontrol('Units','pixels','Position',[310 305 75 30],...
                'Style','edit','String',0.83);
            
    obj.cycleText = uicontrol ('Position', [108 260 175 40]', 'Style',...
                'text','String','Cycle parameters', 'fontsize',16);
            obj.but(14)=uicontrol('Units','pixels','Position',[10 240 75 30],...
                'Style','text','String','Number of cycles');
            obj.but(15)=uicontrol('Units','pixels','Position',[10 205 75 30],...
                'Style','edit','String',1);
            obj.but(17)=uicontrol('Units','pixels','Position',[85 240 75 30],...
                'Style','text','String','Save pulse info');
            obj.but(18)=uicontrol('Units','pixels','Position',[114 205 75 30],...
                'Style','checkbox','Value',1);
            
    obj.controlsText = uicontrol ('Units','pixels','Position',...
                [108 160 175 40]','Style','text','String','Controls','fontsize',16);
            obj.but(1)=uicontrol('Units','pixels','Position',[10 140 180 30],...
                'Style','pushbutton','UserData',struct('val',0,'diffMax',1),...
                'String','Start pulse(s)','BackgroundColor',[ 1 0 0],...
                'callback','holographicstimulation(2)');
            obj.but(16)=uicontrol('Units','pixels','Position',[200 140 180 30],...
                'Style','pushbutton','String','Start collecting data','BackgroundColor',[ 1 0 0],...
                'callback','holographicstimulation(4)');
            obj.but(12)=uicontrol('Units','pixels','Position',[10 105 100 30],...
                'Style','pushbutton','String','Clear objects',...
                'callback','holographicstimulation(3)');
            obj.usualButton = uicontrol('Units','pixels','Position',[110 105 100 30],...
                'Style','pushbutton','String','As usual, please',...
                'callback',@asUsual);
            obj.closeButton = uicontrol('Units','pixels','Position',[10 5 380 50],...
                'Style','pushbutton','String','Close holographicstimulation',...
                'callback',@closeAll);
                    
            
            
            
    case 2 
        deltapulse = str2double(get(obj.but(3),'string'));% time between two pulses in secondes 
        width = str2double(get(obj.but(5),'string')); %%  width of pulses in secondes
        initialdelay = str2double(get(obj.but(9),'string'))/str2double(get(obj.but(11),'string')); % time before first pulses in secondes
        f = 1./(width + deltapulse);
        dutycycle = width./(width + deltapulse);
        nbpulse = str2double(get(obj.but(7),'string'));
        
        for i = 1: str2double(get(obj.but(15),'string'));
            b = DItrig('Dev1',1,0);
            c = Photostimulationpulse('Dev1',3,initialdelay,f,dutycycle,nbpulse);
            startpulse(c);
                if get(obj.but(18),'Value')
                    pulseFilename = ['Pulse' , filename(AIReading)];
                    data = [char(datetime('now', 'Format', 'HH:mm:ss.SSS')), '; Param:', num2str(initialdelay), ':',...
                        num2str(width), ':', num2str(deltapulse), ':', num2str(nbpulse), '\n'];
                    fid = fopen(pulseFilename, 'at');
                    fprintf (fid, data);
                    fclose(fid);
                end
                
            trig(b)
            
           obj.but(1).BackgroundColor = [0 1 0];
           obj.but(1).String = ['In progress... (pulse #',num2str(i),' / ' get(obj.but(15),'string'), ')'];
           pause(initialdelay + (width+deltapulse)*nbpulse);
           holographicstimulation(3)
        end
        obj.but(1).BackgroundColor = [1 0 0];
        obj.but(1).String = 'Start pulse(s)';
       
    case 3 
        delete (b)
        delete (c)
        clear b
        clear c
        
        
    case 4      
         
        
        if dataState == false 
            
            % Get data from the DO figure and open corresponding DO channels
            DOState = 0;
            tempFigDO = findobj('Name', 'DigitalOutput');
            tempHandleDO = findobj(tempFigDO, 'type', 'uicontrol', 'style', 'list');
            if ~isempty(tempHandleDO)
                tempListDO = get(tempHandleDO, 'String');
                if ~isempty(tempListDO)
                    DOState = 1;
                    for i = drange(1:size(tempListDO,1))
                        try
                            % portNline is an array with (port, line)
                            portNline = sscanf(strrep(char(cellstr(tempListDO(i))),'/',' '), '%d');
                            DigitalOutput('PXI1Slot3',portNline(1),portNline(2),1)
                        catch ME
                            disp(ME.message)
                        end
                    end
                end
            end

            % Get data from the AI figure and open corresponding AI channels
            AIState = 0;
            tempFigAI = findobj('Name', 'AnalogInput');
            tempHandleAI = findobj(tempFigAI, 'type', 'uicontrol', 'style', 'list');
            if ~isempty(tempHandleAI) 
                tempListAI = get(tempHandleAI, 'String');
                if ~isempty(tempListAI)
                    AIState = 1;
                    for i = drange(1:size(tempListAI,1))
                        try
                            chanNum = char(cellstr(tempListAI(i)));
                            addChannel(AIReading, 'PXI1Slot3', str2double(chanNum));
                        catch ME
                            disp(ME.message)
                        end
                    end
                    start (AIReading);
                end
            end

            if DOState == 1 && AIState == 1
                obj.but(16).BackgroundColor = [0 1 0];
                obj.but(16).String = 'Input and output in progress...';
                dataState = true;
            elseif DOState == 1 && AIState == 0
                obj.but(16).BackgroundColor = [0 1 0];
                obj.but(16).String = 'Output in progress...';
                dataState = true;
            elseif DOState == 0 && AIState == 1
                obj.but(16).BackgroundColor = [0 1 0];
                obj.but(16).String = 'Input in progress...';
                dataState = true;
            elseif DOState == 0 && AIState == 0
                msgB = msgbox('No AI/DO channels selected');
            end
            
        else 
            % Run python script
            if get(obj.but(18),'Value')
                system(['python mergeDataPulse.py Data', filename(AIReading)])
            end
            
            % Restart AIProcess obj
            if AIState == 1
                delete (AIReading);
                AIReading = AIProcess('AIReading task');
            end
            % Closing DO channels
            
            if ~isempty(tempHandleDO)
                tempListDO = get(tempHandleDO, 'String');
                for i = drange(1:size(tempListDO,1))
                    try
                        % portNline is an array with (port, line)
                        portNline = sscanf(strrep(char(cellstr(tempListDO(i))),'/',' '), '%d');
                        DigitalOutput('PXI1Slot3',portNline(1),portNline(2),0)
                    catch ME
                        disp(ME.message)
                    end
                end
            end
            
            % Return button to the starting state
            obj.but(16).BackgroundColor = [1 0 0];
            obj.but(16).String = 'Start collecting data';
            dataState = false;
        end
end

% DO function

function [] = addDO(varargin)
% Callback for pushbutton, adds new string from edit box.
S = varargin{3};  % Get the structure.
oldstr = get(S.ls,'string'); % The string as it is now.
addstr = {strcat(get(S.ed,'string'),'/',get(S.ed2,'string'))}; % The string to 
%add to the stack.
if isempty(oldstr)
    set(S.ls,'str',{addstr{:}});
else
% The order of the args to cat puts the new string either on top or bottom.
    set(S.ls,'str',{addstr{:},oldstr{:}});  % Put the new string on top -OR-
% set(S.ls,'str',{oldstr{:},addstr{:}});  % Put the new string on bottom.
end
set(S.ed,'string','');
set(S.ed2,'string','');

function [] = delDO(varargin)
% Callback for pushbutton, deletes one line from listbox.
S = varargin{3};  % Get the structure.
L = get(S.ls,{'string','value'});  % Get the users choice.

% We need to make sure we don't try to assign an empty string.
if ~isempty(L{1})
    L{1}(L{2}(:)) = [];  % Delete the selected strings.
    set(S.ls,'string',L{1},'val',1) % Set the new string.
end

% AO functions

function [] = addAI(varargin)
% Callback for pushbutton, adds new string from edit box.
S = varargin{3};  % Get the structure.
oldstr = get(S.ls,'string'); % The string as it is now.
addstr = {strcat(get(S.ed,'string'))}; % The string to 
%add to the stack.
if isempty(oldstr)
    set(S.ls,'str',{addstr{:}});
else
% The order of the args to cat puts the new string either on top or bottom.
    set(S.ls,'str',{addstr{:},oldstr{:}});  % Put the new string on top -OR-
% set(S.ls,'str',{oldstr{:},addstr{:}});  % Put the new string on bottom.
end
set(S.ed,'string','');

function [] = delAI(varargin)
% Callback for pushbutton, deletes one line from listbox.
S = varargin{3};  % Get the structure.
L = get(S.ls,{'string','value'});  % Get the users choice.

% We need to make sure we don't try to assign an empty string.
if ~isempty(L{1})
    L{1}(L{2}(:)) = [];  % Delete the selected strings.
    set(S.ls,'string',L{1},'val',1) % Set the new string.
end

% Fill the fields with default data
function asUsual(varargin)
temp = findobj('Name', 'AIReading');
tempFig = findobj('Name', 'AnalogInput');
tempHandle = findobj(tempFig, 'type', 'uicontrol', 'style', 'list');
if ~isempty(tempHandle)
    set(tempHandle, 'String', {'4'});
end

tempFig = findobj('Name', 'DigitalOutput');
tempHandle = findobj(tempFig, 'type', 'uicontrol', 'style', 'list');
if ~isempty(tempHandle)
    set(tempHandle, 'String', {'1/0'});
end

% Close all button function
function closeAll(varargin)
tempFig = findobj('Name', 'AnalogInput');
close(tempFig)
tempFig = findobj('Name', 'DigitalOutput');
close(tempFig)
tempFig = findobj('Name', 'Stimulation');
close(tempFig)