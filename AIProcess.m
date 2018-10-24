%% Class for getting data through analog input channel
classdef AIProcess
   
    properties 
        
       taskName;
       outputFilename;
       outputFilenameBackPart;
    end
    
    properties
        
        minVoltage = -10;
        maxVoltage = 10;
        everyNSamples = 3000;
        sampleClockSource = 'OnboardClock'; % the terminal used for the sample Clock; refer to "Terminal Names" in the DAQmx help for valid values
        sampleRate = 1000;                  % sample Rate in Hz
    end    
    
    properties (Hidden)
        
        hTask;
    
    end
    
    methods 
        %% CONSTRUCTOR/DESTRUCTOR
        % AIProcess('PXI1Slot3','Analog input task')
        function obj = AIProcess(taskName)
            
            import dabs.ni.daqmx.*      
            obj.taskName = taskName;
            obj.outputFilenameBackPart = sprintf('_%s.csv', datestr(now,'mm-dd-yyyy HH-MM-SS'));
            obj.outputFilename = strcat('Data', obj.outputFilenameBackPart);

            try
                obj.hTask = Task();
%               obj.hTask.createAIVoltageChan(obj.devName, obj.chanNumber,[],obj.minVoltage,obj.maxVoltage);
%               obj.hTask.cfgSampClkTiming(obj.sampleRate,'DAQmx_Val_ContSamps',[],obj.sampleClockSource);
%               obj.hTask.registerEveryNSamplesEvent({@(src,eventdata)saveDataToCsv(src,eventdata, obj.outputFilename)},obj.everyNSamples,1,'Scaled');
            catch ME
                disp(ME.message)
            end

        end
        
        function addChannel(obj, devName, chanNumber)
            obj.hTask.createAIVoltageChan(devName, chanNumber,[],obj.minVoltage,obj.maxVoltage);
        end
        
        function  start(obj)
            try
                obj.hTask.cfgSampClkTiming(obj.sampleRate,'DAQmx_Val_ContSamps',[],obj.sampleClockSource);
                obj.hTask.registerEveryNSamplesEvent({@(src,eventdata)saveDataToCsv(src,eventdata, obj.outputFilename)},obj.everyNSamples,1,'Scaled');
                obj.hTask.start()
            catch ME
                disp(ME.message)
            end
        end
        
           % deleteAIProcess(b)
        function delete(obj)
            delete(obj.hTask);        
        end
        
        function returnDate = filename(obj)
            returnDate = obj.outputFilenameBackPart;
        end
            
        
%         function addPulseData(obj, data)
%             fid = fopen(obj.outputFilename, 'a');
%             fprintf (fid, data);
%             fclose(fid);
%         end 
        

    end

end         
        