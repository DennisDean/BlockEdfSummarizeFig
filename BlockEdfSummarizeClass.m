classdef BlockEdfSummarizeClass
    %BlockEdfSummarizeClass Summarize EDFs stored in a folder  
    %   Function takes a list of EDF/XML files created by the function 
    % GetMatchedSleepEdfXmlFiles and summarises the content into a single
    % Excel file.
    %
    % Assumptions:
    %  
    %       The search function assumes the following naming the convention:
    %
    %                         EDF: 'SubjectNamingConvention'.EDF
    %                         XML: 'SubjectNamingConvention'.EDF.xml
    %
    %      The search is not case sensitive and 'EDF' can not be a substring of 
    %      'SubjectNamingConvention'.
    %
    % Function Prototype:
    %
    %      besObj = BlockEdfSummarizeClass(xlsFileList, xlsFileSummaryOut);
    %
    % Public Methods:
    %
    %      besObj = besObj.summarizeHeader;
    %      besObj = besObj.summarizeSignalLabels;
    %      besObj = besObj.summarizeSignalLabels(requiredSignals);
    %      besObj = besObj.summarizeHeaderWithCheck;
    %
    %      requiredSignals:  Cell array of EDF signal labels {'EEG', 'ECG'}
    %
    %  Dependencies:
    %
    %         BlockEdfLoadClass.m (54227)
    %         http://www.mathworks.com/matlabcentral/fileexchange/45227-blockedfloadclass
    %
    %         GetMatchedSleepEdfXmlFiles.m
    %         https://github.com/DennisDean/GetMatchedSleepEdfXmlFiles
    %
    %         dirr.m (8682)
    %         http://www.mathworks.com/matlabcentral/fileexchange/8682-dirr--find-files-recursively-filtering-name--date-or-bytes-
    %
    % Additional Information:
    %
    %         https://github.com/DennisDean?tab=repositories
    %         https://sleepdata.org/
    %         http://sleep.partners.org/edf/
    %
    %
    % Version: 0.1.05
    %
    % ---------------------------------------------
    % Dennis A. Dean, II, Ph.D
    %
    % Program for Sleep and Cardiovascular Medicine
    % Brigham and Women's Hospital
    % Harvard Medical School
    % 221 Longwood Ave
    % Boston, MA  02149
    %
    % File created: December 20, 2013
    % Last updated: May 1, 2014 
    %    
    % Copyright © [2013] The Brigham and Women's Hospital, Inc. THE BRIGHAM AND 
    % WOMEN'S HOSPITAL, INC. AND ITS AGENTS RETAIN ALL RIGHTS TO THIS SOFTWARE 
    % AND ARE MAKING THE SOFTWARE AVAILABLE ONLY FOR SCIENTIFIC RESEARCH 
    % PURPOSES. THE SOFTWARE SHALL NOT BE USED FOR ANY OTHER PURPOSES, AND IS
    % BEING MADE AVAILABLE WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED, 
    % INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY AND 
    % FITNESS FOR A PARTICULAR PURPOSE. THE BRIGHAM AND WOMEN'S HOSPITAL, INC. 
    % AND ITS AGENTS SHALL NOT BE LIABLE FOR ANY CLAIMS, LIABILITIES, OR LOSSES 
    % RELATING TO OR ARISING FROM ANY USE OF THIS SOFTWARE.
    %    
    
    %---------------------------------------------------- Public Properties
    properties (Access = public)
        % Primary input
        xlsFileList                              % File input list
        xlsFileSummaryOut                        % Output file 
        
        % Check values
        checkValues = [];        
        
        % Settings accessing sampling rate
        signalLabelSamplingRate = {};   % Signals to get sampling rate
        signalLabelSamplingRateVal = [];
        
        % File Partitioning varible
        filePartitioningLabel = {};     % Partition on signal sampling rate
        splitFileListCellwLabels = {};  % File list variable
        edfFileListNamePrefix = '';     % Multiple file prefix
        fileNameCell = {};              % Cell of multiple file locations
        fileListCell = {};              % Files for each cell  
        uniqueSamplingRates = [];       % unique sampling rates
        file_segmentation_completed = 0;% Flag to test for success
    end
    %------------------------------------------------ Dependent Properties
    properties (Dependent = true)
    end
    %--------------------------------------------------- Private Properties
    properties (Access = protected)
        % Program constants
        folderSeparator = '\';

        % Input File Locations
        edfFnIndex = 2;
        edfPathIndex = 6;
        xmlFnIndex = 7;  
        xmlPathIndex = 11;
        
        % Signal Summary defaults
        signalField = 'signal_labels';
    end
    %------------------------------------------------------- Public Methods
    methods
        %------------------------------------------------------ Constructor
        function obj = BlockEdfSummarizeClass(varargin)
            % Process input arguments
            if nargin == 2
               obj.xlsFileList = varargin{1};
               obj.xlsFileSummaryOut = varargin{2};
            else
               % Number of arguments is not supported
               
            end
        end
        %-------------------------------------------------- summarizeHeader  
        function obj = summarizeHeader(obj)
            % Program constants
            folderSeparator = obj.folderSeparator;

            % File Locations
            edfFnIndex = obj.edfFnIndex;
            edfPathIndex = obj.edfPathIndex;
            xmlFnIndex = obj.xmlFnIndex;  
            xmlPathIndex = obj.xmlPathIndex;

            % XLS File name
            xlsFileList = obj.xlsFileList;
            xlsFileSummaryOut = obj.xlsFileSummaryOut;

            % Load xls file
            try 
                [num txt raw] = xlsread(xlsFileList);
            catch
                % Return
                errMsg = 'Could not open EDF/XML file list';
                warning(errMsg);
                return
            end
            
            % Prepare contents for summary
            edfFN = txt(2:end,edfFnIndex);
            edfPath = strcat(txt(2:end,edfPathIndex), folderSeparator);
            xmlFN = txt(2:end,xmlFnIndex);
            xmlPath = strcat(txt(2:end,xmlPathIndex), folderSeparator);

            % Get values
            numFiles = length(edfFN);
            
            % Process each entry
            try
                % Process each entry
                headerTable = cell(numFiles+1,10+2);
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 1;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:end) = struct2cell(edfObj.edf.header)'; 
                end
                catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end

            
            % Write Header Summary
            try
                % Add headers
                headerTable(1,1) = {'File ID'};
                headerTable(1,2) = {'Edf FN'};
                headerTable(1,3:end) = fieldnames(edfObj.edf.header)';

                % XLS Write
                xlswrite(xlsFileSummaryOut, headerTable);
            catch
                % Return
                errMsg = sprintf('Could not write output file (%s)',...
                    xlsFileSummaryOut);
                warning(errMsg);
                return  
            end   
        end
        %----------------------------------------- summarizeHeaderWithCheck  
        function obj = summarizeHeaderWithCheck(obj)
            % Program constants
            folderSeparator = obj.folderSeparator;

            % File Locations
            edfFnIndex = obj.edfFnIndex;
            edfPathIndex = obj.edfPathIndex;
            xmlFnIndex = obj.xmlFnIndex;  
            xmlPathIndex = obj.xmlPathIndex;

            % XLS File name
            xlsFileList = obj.xlsFileList;
            xlsFileSummaryOut = obj.xlsFileSummaryOut;

            % Load xls file
            try 
                [num txt raw] = xlsread(xlsFileList);
            catch
                % Return
                errMsg = 'Could not open EDF/XML file list';
                warning(errMsg);
                return
            end
            
            % Prepare contents for summary
            edfFN = txt(2:end,edfFnIndex);
            edfPath = strcat(txt(2:end,edfPathIndex), folderSeparator);
            xmlFN = txt(2:end,xmlFnIndex);
            xmlPath = strcat(txt(2:end,xmlPathIndex), folderSeparator);

            % Get values
            numFiles = length(edfFN);
            
            % Process each entry
            try
                % Process each entry
                headerTable = cell(numFiles+1,10+2+2+7);
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 2;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get EDF check information
                    edfObj = edfObj.CheckEdf;
                    mostSeriousErrValue = edfObj.mostSeriousErrValue;
                    mostSeriousErrMsg = edfObj.mostSeriousErrMsg;
                    totNumDeviations = edfObj.totNumDeviations;
                    deviationByType = edfObj.deviationByType;
                    errSummaryLabel = edfObj.errSummaryLabel;                   
                                    
                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:12) = struct2cell(edfObj.edf.header)'; 
                    headerTable(e+1,13) = {mostSeriousErrValue}; 
                    headerTable(e+1,14) = {mostSeriousErrMsg}; 
                    headerTable(e+1,15) = {totNumDeviations};
                    headerTable(e+1,16:21) = num2cell(deviationByType);
                end
            catch
                % Return
                errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                warning(errMsg);
                return 
            end

            
            % Write Header Summary
            try
                % Add headers
                headerTable(1,1) = {'File ID'};
                headerTable(1,2) = {'Edf FN'};
                headerTable(1,3:12) = fieldnames(edfObj.edf.header)';
                headerTable(1,13) = {'mostSeriousErrValue'}; 
                headerTable(1,14) = {'mostSeriousErrMsg'}; 
                headerTable(1,15) = {'totNumDeviations'}; 
                headerTable(1,16:21) = errSummaryLabel'; 
                
                % Delete last line (Bug in Block Check)
                % Will fix later
                headerTable = headerTable(1:end, 1:end-1);
                
                % XLS Write
                xlswrite(xlsFileSummaryOut, headerTable);
            catch
                % Return
                errMsg = sprintf('Could not write output file (%s)',...
                    xlsFileSummaryOut);
                warning(errMsg);
                return  
            end   
        end
        %-------------------------------------------------- summarizeSignals
        function obj = summarizeSignalLabels(obj, varargin)
            % get default
            folderSeparator = obj.folderSeparator;
            signalField = obj.signalField;
            signalsToTestFor = {};
            sccObj = SetCompositionCountStrClass;
            
            % Process input
            if nargin == 1
                % Use default field
            elseif nargin == 2
               % Get field
               signalsToTestFor = varargin{1};
            elseif nargin == 3
               % Get field
               signalsToTestFor  = varargin{1};   
               signalField = varargin{2};              
            else
               % prototype not supported
               fprintf('obj = obj.summarizeSignalLabels\n');
               fprintf('obj = obj.summarizeSignalLabels(signalsToTestFor)\n');
               errMsg = 'summarizeSignalField: prototype not supported';
               warning(errMsg);
               return
            end
            
            % Program constants
            

            % File Locations
            edfFnIndex = obj.edfFnIndex;
            edfPathIndex = obj.edfPathIndex;
            xmlFnIndex = obj.xmlFnIndex;  
            xmlPathIndex = obj.xmlPathIndex;

            % XLS File name
            xlsFileList = obj.xlsFileList;
            xlsFileSummaryOut = obj.xlsFileSummaryOut;

            % Load xls file
            try 
                [num txt raw] = xlsread(xlsFileList);
            catch
                % Return
                errMsg = 'Could not open EDF/XML file list';
                warning(errMsg);
                return
            end
            
            % Prepare contents for summary
            edfFN = txt(2:end,edfFnIndex);
            edfPath = strcat(txt(2:end,edfPathIndex), folderSeparator);
            xmlFN = txt(2:end,xmlFnIndex);
            xmlPath = strcat(txt(2:end,xmlPathIndex), folderSeparator);

            % Get values
            numFiles = length(edfFN);
            
            try
                % Process each entry
                headerTable = cell(numFiles+1,10+2);
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 1;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:end) = struct2cell(edfObj.edf.header)'; 
                end
            catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end
            
            % Repeat but this time get signal information
            try
                % Process each entry
                numSignals = cell2mat(headerTable(2:end,end));
                maxSignals = max(numSignals);
                headerTable = cell(numFiles+1,2+10+maxSignals);
                if ~isempty(signalsToTestFor)
                    headerTable = cell(numFiles+1,2+10+maxSignals+1);
                end
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 2;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:12) = struct2cell(edfObj.edf.header)'; 
                    
                    % Get signal header label
                    N = edfObj.edf.header.num_signals;
                    value = ...
                    arrayfun(@(x)getfield(edfObj.edf.signalHeader(x), signalField),[1:N], ...
                         'UniformOutput', 0); 
                    headerTable(e+1,13:12+length(value)) = (value); 
                    
                    
                    % Check if signals are present
                    check = 0;
                    if ~isempty(signalsToTestFor)
                        intersection = sort(intersect(value, signalsToTestFor));
                        if length(intersection) == length(signalsToTestFor)
                            sigs = sort(signalsToTestFor);
                            cmpF = @(x)strcmp(intersection{x}, sigs{x});
                            check = arrayfun(cmpF, [1:length(sigs)],...
                                'uniformOutput', 1);
                            check = floor(sum(double(check))/length(check));
                        end
                        
                        % Set check value
                        headerTable(e+1,end) = {check}; 
                    end
                end
            catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end
            
            % Add header labels
            checkValues = [];
            try
                % Add headers
                headerTable(1,1) = {'File ID'};
                headerTable(1,2) = {'Edf FN'};
                headerTable(1,3:12) = fieldnames(edfObj.edf.header)';
                headerTable(1,13) = {signalField};
                
                % Check label if completed
                if ~isempty(signalsToTestFor)
                    headerTable(1,end) = {'Signal Check'}; 
                    checkValues = cell2mat(headerTable(2:end,end));
                    obj.checkValues = checkValues;
                end
                
                % XLS Write
                xlswrite(xlsFileSummaryOut, headerTable);
            catch
                % Return
                errMsg = sprintf('Could not write output file (%s)',...
                    xlsFileSummaryOut);
                warning(errMsg);
                return  
            end   
        end % End function
        %------------------------------------ summarizeSignalLabelsPlus
        function obj = summarizeSignalLabelsPlus(obj, varargin)
            % Add sampling rate to signal summary
            % get default
            folderSeparator = obj.folderSeparator;
            signalField = obj.signalField;
            signalsToTestFor = {};
            
            % Process input
            if nargin == 1
                % Use default field
            elseif nargin == 2
               % Get field
               signalsToTestFor = varargin{1};
            elseif nargin == 3
               % Get field
               signalsToTestFor  = varargin{1};   
               signalField = varargin{2};              
            else
               % prototype not supported
               fprintf('obj = obj.summarizeSignalLabels\n');
               fprintf('obj = obj.summarizeSignalLabels(signalsToTestFor)\n');
               errMsg = 'summarizeSignalField: prototype not supported';
               warning(errMsg);
               return
            end
            
            % Program constants
            

            % File Locations
            edfFnIndex = obj.edfFnIndex;
            edfPathIndex = obj.edfPathIndex;
            xmlFnIndex = obj.xmlFnIndex;  
            xmlPathIndex = obj.xmlPathIndex;

            % XLS File name
            xlsFileList = obj.xlsFileList;
            xlsFileSummaryOut = obj.xlsFileSummaryOut;

            % Load xls file
            try 
                [num txt raw] = xlsread(xlsFileList);
            catch
                % Return
                errMsg = 'Could not open EDF/XML file list';
                warning(errMsg);
                return
            end
            
            % Prepare contents for summary
            edfFN = txt(2:end,edfFnIndex);
            edfPath = strcat(txt(2:end,edfPathIndex), folderSeparator);
            xmlFN = txt(2:end,xmlFnIndex);
            xmlPath = strcat(txt(2:end,xmlPathIndex), folderSeparator);

            % Get values
            numFiles = length(edfFN);
            
            try
                % Process each entry
                headerTable = cell(numFiles+1,10+2);
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 1;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:end) = struct2cell(edfObj.edf.header)'; 
                end
            catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end
            
            % Repeat but this time get signal information
            try
                % Process each entry
                numSignals = cell2mat(headerTable(2:end,end));
                maxSignals = max(numSignals);
                headerTable = cell(numFiles+1,2+10+maxSignals);
                if ~isempty(signalsToTestFor)
                    headerTable = cell(numFiles+1,2+10+maxSignals+1);
                end
                
                % Sstore sampling rate if necessary
                samplingRateEntryCell = {};
                
                % Process each file
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 2;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:12) = struct2cell(edfObj.edf.header)'; 
                    
                    % Get signal header label
                    N = edfObj.edf.header.num_signals;
                    value = ...
                    arrayfun(@(x)getfield(edfObj.edf.signalHeader(x), signalField),[1:N], ...
                         'UniformOutput', 0); 
                    headerTable(e+1,13:12+length(value)) = (value); 
                    
                    % Check if signals are present
                    check = 0;
                    if ~isempty(signalsToTestFor)
                        intersection = sort(intersect(value, signalsToTestFor));
                        if length(intersection) == length(signalsToTestFor)
                            sigs = sort(signalsToTestFor);
                            cmpF = @(x)strcmp(intersection{x}, sigs{x});
                            check = arrayfun(cmpF, [1:length(sigs)],...
                                'uniformOutput', 1);
                            check = floor(sum(double(check))/length(check));
                        end
                        
                        % Set check value
                        headerTable(e+1,end) = {check}; 
                    end
                    
                    % Check if sampling rate is requested
                    if ~isempty(obj.signalLabelSamplingRate)

                        % Get sampling rate
                        samplingRateEntry = cell(1, 2*length(obj.signalLabelSamplingRate));
                        for q = 1:length(obj.signalLabelSamplingRate)
                            % Get sampling rate
                            curLab = obj.signalLabelSamplingRate{q};
                            signalIndexF = find(strcmp(edfObj.signal_labels,curLab));
                            
                            if ~isempty(signalIndexF)
                                signalLabelSamplingRateVal(q) = edfObj.sample_rate(signalIndexF);

                                % Save information
                                samplingRateEntry{(q-1)*2+1} = curLab;
                                samplingRateEntry{(q-1)*2+2} = signalLabelSamplingRateVal(q);
                            end
                        end
                        
                        % Save entry
                        samplingRateEntryCell = [samplingRateEntryCell;samplingRateEntry];
                    end
                end
            catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end
            
            % Get signal and sampling rate inforamtion
            try
                
            catch
                
            end
            
            % Add header labels
            try
                % Add headers
                headerTable(1,1) = {'File ID'};
                headerTable(1,2) = {'Edf FN'};
                headerTable(1,3:12) = fieldnames(edfObj.edf.header)';
                headerTable(1,13) = {signalField};
                
                % Check label if completed
                if ~isempty(signalsToTestFor)
                    headerTable(1,end) = {'Signal Check'}; 
                end
                
                % Signal sampling rate if needed
                if ~isempty(obj.signalLabelSamplingRate)
                    samplingRateEntryCell = ...
                        [cell(1,length(samplingRateEntryCell(1,:)));
                         samplingRateEntryCell];
                    headerTable = [headerTable, samplingRateEntryCell];
                end
                
                % XLS Write
                xlswrite(xlsFileSummaryOut, headerTable);
            catch
                % Return
                errMsg = sprintf('Could not write output file (%s)',...
                    xlsFileSummaryOut);
                warning(errMsg);
                return  
            end   
        end % End function
        %----------------------------------------------- signalLabelSummary
        function obj = signalLabelSummary(obj, varargin)
            % Add sampling rate to signal summary
            % get default
            folderSeparator = obj.folderSeparator;
            signalField = obj.signalField;
            signalsToTestFor = {};
            sccObj = SetCompositionCountStrClass;
            
            % Process input
            if nargin == 1
                % Use default field
            elseif nargin == 2
               % Get field
               signalsToTestFor = varargin{1};
            elseif nargin == 3
               % Get field
               signalsToTestFor  = varargin{1};   
               signalField = varargin{2};              
            else
               % prototype not supported
               fprintf('obj = obj.summarizeSignalLabels\n');
               fprintf('obj = obj.summarizeSignalLabels(signalsToTestFor)\n');
               errMsg = 'summarizeSignalField: prototype not supported';
               warning(errMsg);
               return
            end
            
            % Program constants
            

            % File Locations
            edfFnIndex = obj.edfFnIndex;
            edfPathIndex = obj.edfPathIndex;
            xmlFnIndex = obj.xmlFnIndex;  
            xmlPathIndex = obj.xmlPathIndex;

            % XLS File name
            xlsFileList = obj.xlsFileList;
            xlsFileSummaryOut = obj.xlsFileSummaryOut;

            % Load xls file
            try 
                [num txt raw] = xlsread(xlsFileList);
            catch
                % Return
                errMsg = 'Could not open EDF/XML file list';
                warning(errMsg);
                return
            end
            
            % Prepare contents for summary
            edfFN = txt(2:end,edfFnIndex);
            edfPath = strcat(txt(2:end,edfPathIndex), folderSeparator);
            xmlFN = txt(2:end,xmlFnIndex);
            xmlPath = strcat(txt(2:end,xmlPathIndex), folderSeparator);

            % Get values
            numFiles = length(edfFN);
            
            try
                % Process each entry
                headerTable = cell(numFiles+1,10+2);
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 1;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:end) = struct2cell(edfObj.edf.header)'; 
                end
            catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end
            
            % Repeat but this time get signal information
            try
                % Process each entry
                numSignals = cell2mat(headerTable(2:end,end));
                maxSignals = max(numSignals);
                headerTable = cell(numFiles+1,2+10+maxSignals);
                if ~isempty(signalsToTestFor)
                    headerTable = cell(numFiles+1,2+10+maxSignals+1);
                end
                
                % Sstore sampling rate if necessary
                samplingRateEntryCell = {};
                
                % Process each file
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 2;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:12) = struct2cell(edfObj.edf.header)'; 
                    
                    % Get signal header label
                    N = edfObj.edf.header.num_signals;
                    value = ...
                    arrayfun(@(x)getfield(edfObj.edf.signalHeader(x), signalField),[1:N], ...
                         'UniformOutput', 0); 
                    headerTable(e+1,13:12+length(value)) = (value); 
                    
                    % Create a unique signal label list
                    sccObj = sccObj.AddSet(value);   
                    % sccObj = sccObj.echoSetConfigurationsToConsole;
                    % sccObj = sccObj.echoUniqueEntriesToConsole;
                    % entryTotals = length(sccObj.entryTotals)
                    % uniqueEntries = length(sccObj.uniqueEntries)
    
                    % Check if signals are present
                    check = 0;
                    if ~isempty(signalsToTestFor)
                        intersection = sort(intersect(value, signalsToTestFor));
                        if length(intersection) == length(signalsToTestFor)
                            sigs = sort(signalsToTestFor);
                            cmpF = @(x)strcmp(intersection{x}, sigs{x});
                            check = arrayfun(cmpF, [1:length(sigs)],...
                                'uniformOutput', 1);
                            check = floor(sum(double(check))/length(check));
                        end
                        
                        % Set check value
                        headerTable(e+1,end) = {check}; 
                    end
                    
                    % Check if sampling rate is requested
                    if ~isempty(obj.signalLabelSamplingRate)

                        % Get sampling rate
                        samplingRateEntry = cell(1, 2*length(obj.signalLabelSamplingRate));
                        for q = 1:length(obj.signalLabelSamplingRate)
                            % Get sampling rate
                            curLab = obj.signalLabelSamplingRate{q};
                            signalIndexF = find(strcmp(edfObj.signal_labels,curLab));
                            
                            if ~isempty(signalIndexF)
                                signalLabelSamplingRateVal(q) = edfObj.sample_rate(signalIndexF);

                                % Save information
                                samplingRateEntry{(q-1)*2+1} = curLab;
                                samplingRateEntry{(q-1)*2+2} = signalLabelSamplingRateVal(q);
                            end
                        end
                        
                        % Save entry
                        samplingRateEntryCell = [samplingRateEntryCell;samplingRateEntry];
                    end
                end
            catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end
            
            % Get signal and sampling rate inforamtion
            try
                
            catch
                
            end
            
            % Add header labels
            try
                % Add headers
                headerTable(1,1) = {'File ID'};
                headerTable(1,2) = {'Edf FN'};
                headerTable(1,3:12) = fieldnames(edfObj.edf.header)';
                headerTable(1,13) = {signalField};
                
                % Check label if completed
                if ~isempty(signalsToTestFor)
                    headerTable(1,end) = {'Signal Check'}; 
                end
                
                % Signal sampling rate if needed
                if ~isempty(obj.signalLabelSamplingRate)
                    samplingRateEntryCell = ...
                        [cell(1,length(samplingRateEntryCell(1,:)));
                         samplingRateEntryCell];
                    headerTable = [headerTable, samplingRateEntryCell];
                end
                
                % Create New Signal List with Count
                entryTotals = sccObj.entryTotals;
                uniqueEntries = sccObj.uniqueEntries;
                numEntryTotals = length(entryTotals);
                numUniqueEntries = (uniqueEntries);
    
                % Define output table
                headerTable = cell(numEntryTotals+1, 3);
                headerTable{1,1} = 'Label';
                headerTable{1,2} = 'Label';
                headerTable{1,3} = 'Count';
                headerTable(2:end,1) = num2cell([1:1:numEntryTotals]');
                headerTable(2:end,2) = uniqueEntries;
                headerTable(2:end,3) = num2cell(entryTotals);
                
                % XLS Write
                xlswrite(xlsFileSummaryOut, headerTable);
            catch
                % Return
                errMsg = sprintf('Could not write output file (%s)',...
                    xlsFileSummaryOut);
                warning(errMsg);
                return  
            end   
        end % End function
        %-------------------------------------------------- segmentFileList
        function obj = segmentFileList(obj, varargin)
            % Add sampling rate to signal summary
            % get default
            folderSeparator = obj.folderSeparator;
            signalField = obj.signalField;
            signalsToTestFor = {};
            
            % Process input
            if nargin == 1
                % Use default field
            elseif nargin == 2
               % Get field
               signalsToTestFor = varargin{1};
            elseif nargin == 3
               % Get field
               signalsToTestFor  = varargin{1};   
               signalField = varargin{2};              
            else
               % prototype not supported
               fprintf('obj = obj.summarizeSignalLabels\n');
               fprintf('obj = obj.summarizeSignalLabels(signalsToTestFor)\n');
               errMsg = 'summarizeSignalField: prototype not supported';
               warning(errMsg);
               return
            end
            
            % Program constants
            if isempty(obj.filePartitioningLabel)
                % Return if template is empty
                msg = 'Set the signal label prior to segmenting file list';
                fprintf('%s\n', msg);
                return
            end

            % File Locations
            edfFnIndex = obj.edfFnIndex;
            edfPathIndex = obj.edfPathIndex;
            xmlFnIndex = obj.xmlFnIndex;  
            xmlPathIndex = obj.xmlPathIndex;

            % XLS File name
            xlsFileList = obj.xlsFileList;
            xlsFileSummaryOut = obj.xlsFileSummaryOut;

            % Load xls file
            try 
                [num txt raw] = xlsread(xlsFileList);
            catch
                % Return
                errMsg = 'Could not open EDF/XML file list';
                warning(errMsg);
                return
            end
            
            % Prepare contents for summary
            edfFN = txt(2:end,edfFnIndex);
            edfPath = strcat(txt(2:end,edfPathIndex), folderSeparator);
            xmlFN = txt(2:end,xmlFnIndex);
            xmlPath = strcat(txt(2:end,xmlPathIndex), folderSeparator);

            % Get values
            numFiles = length(edfFN);
            
            try
                % Process each entry
                headerTable = cell(numFiles+1,10+2);
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 1;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:end) = struct2cell(edfObj.edf.header)'; 
                end
            catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end
            
            % Repeat but this time get signal information
            try
                % Process each entry
                numSignals = cell2mat(headerTable(2:end,end));
                maxSignals = max(numSignals);
                headerTable = cell(numFiles+1,2+10+maxSignals);
                if ~isempty(signalsToTestFor)
                    headerTable = cell(numFiles+1,2+10+maxSignals+1);
                end
                
                % Sstore sampling rate if necessary
                samplingRateEntryCell = {};
                
                % Process each file
                for e = 1:numFiles
                    % Load header
                    edfObj = BlockEdfLoadClass(strcat(edfPath{e}, edfFN{e}));
                    edfObj.numCompToLoad = 2;   % Don't return object
                    edfObj = edfObj.blockEdfLoad;

                    % Get header information
                    headerTable(e+1,1) = {e};
                    headerTable(e+1,2) = edfFN(e);
                    headerTable(e+1,3:12) = struct2cell(edfObj.edf.header)'; 
                    
                    % Get signal header label
                    N = edfObj.edf.header.num_signals;
                    value = ...
                    arrayfun(@(x)getfield(edfObj.edf.signalHeader(x), signalField),[1:N], ...
                         'UniformOutput', 0); 
                    headerTable(e+1,13:12+length(value)) = (value); 
                    
                    % Check if signals are present
                    check = 0;
                    if ~isempty(signalsToTestFor)
                        intersection = sort(intersect(value, signalsToTestFor));
                        if length(intersection) == length(signalsToTestFor)
                            sigs = sort(signalsToTestFor);
                            cmpF = @(x)strcmp(intersection{x}, sigs{x});
                            check = arrayfun(cmpF, [1:length(sigs)],...
                                'uniformOutput', 1);
                            check = floor(sum(double(check))/length(check));
                        end
                        
                        % Set check value
                        headerTable(e+1,end) = {check}; 
                    end
                    
                    % Check if sampling rate is requested
                    if and(~isempty(obj.filePartitioningLabel), ...
                           length(obj.filePartitioningLabel) == 1);

                        % Get sampling rate
                        samplingRateEntry = cell(1, 2*length(obj.filePartitioningLabel));
                        for q = 1:length(obj.filePartitioningLabel)
                            % Get sampling rate
                            curLab = obj.filePartitioningLabel{q};
                            signalIndexF = find(strcmp(edfObj.signal_labels,curLab));
                            
                            if ~isempty(signalIndexF)
                                signalLabelSamplingRateVal(q) = edfObj.sample_rate(signalIndexF);

                                % Save information
                                samplingRateEntry{(q-1)*2+1} = curLab;
                                samplingRateEntry{(q-1)*2+2} = signalLabelSamplingRateVal(q);
                            end
                        end
                        
                        % Save entry
                        samplingRateEntryCell = [samplingRateEntryCell;samplingRateEntry];
                    end
                end
            catch
                    % Return
                    errMsg = sprintf('Could not complete EDF processing (%.0f, %s)',...
                        e, edfFN{e});
                    warning(errMsg);
                return 
            end
            
            % Get signal and sampling rate inforamtion
            fileListCell = {};
            fileNameCell = {};
            try
                % Process file input
                if and(~isempty(obj.filePartitioningLabel), ...
                       length(obj.filePartitioningLabel)== 1);
                   
                    % Identify Sampling Rate Information
                    samplingRates = cell2mat(samplingRateEntryCell(:,2));
                    uniqueSamplingRates = unique(samplingRates);
                    numUniqueSamplingRates = length(uniqueSamplingRates);

                    % Create sampling rate masks
                    samplingRateMasks = ...
                        zeros(length(samplingRates),numUniqueSamplingRates);
                    for s = 1:numUniqueSamplingRates
                        samplingRateMasks(:,s) = ...
                            samplingRates == uniqueSamplingRates(s);
                    end
                    samplingRateMasks = logical(samplingRateMasks);
                    
                    % Split file
                    if ~isempty(obj.splitFileListCellwLabels)
                        % Get file information                        
                        splitFileListCellwLabels = obj.splitFileListCellwLabels{1};
                        fileLables = splitFileListCellwLabels(1,:);
                        fileListCellMaster = ...
                            splitFileListCellwLabels(2:end,:);
                        
                        % Divide the file list into components by sampling
                        % rate
                        fileListCell = cell(numUniqueSamplingRates,1);
                        fileNameCell = cell(numUniqueSamplingRates,1);
                        for s = 1:numUniqueSamplingRates
                            % Split file name list
                            fileListCell{s} = ...
                                [ fileLables; ...
                                  fileListCellMaster( samplingRateMasks(:,s), :) ];
                        
                            % Generate names
                            newfn = sprintf('%s_%.0f_%.0f_.xls', ...
                                obj.edfFileListNamePrefix, ...
                                s, uniqueSamplingRates(s));
                            fileNameCell{s} = newfn;
                        end
                    end
                   
                    % Save information for access by analysis programs
                    obj.fileNameCell =  fileNameCell;
                    obj.fileListCell = fileListCell;
                    obj.uniqueSamplingRates = uniqueSamplingRates;
                end
                
                % Set flag
                obj.file_segmentation_completed = 1;
            catch
                % Produce output
                errMsg = 'Could not produce multiple file output';
                warning(errMsg);
            end
            
            % Write files to disk
            try
                % Divide the file list into components by sampling
                % rate
                for s = 1:numUniqueSamplingRates
                    % Split file name list
                    nextXlsFn = fileNameCell{s}; 
                    nextFileList = fileListCell{s};
                    xlswrite(nextXlsFn, nextFileList);
                end
            catch
                % Return
                errMsg = sprintf('Could not write output file (%s)',...
                    obj.edfFileListNamePrefix);
                warning(errMsg);
                return  
            end   
        end % End function
    end
    %---------------------------------------------------- Private functions
    methods (Access=protected)

    end
    %------------------------------------------------- Dependent Properties
    methods   
    end
    %---------------------------------------------------- Static Properties
    methods(Static)
    end
end

