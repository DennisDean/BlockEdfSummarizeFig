classdef SetCompositionCountStrClass
    %SetCompositionCountStrClass Tracks count of unique set entries
    %   Function is meant to be an add on to the union function.  As each set
    % is added the count of unique entries label entries is maintain.  The
    % count of unique set configurations and counts of unique sets are also
    % maintained.
    %
    %   The current version assumes that sets contain string entries. The
    % occurance of duplicate string entries is not tested for explicitly.
    % In the data that we look at, we are generally more interested in
    % unique configurations and identifing signal labels of interest.
    %
    %   The function was written to report on the configuration of signals
    % stored in European Data Format (EDF) files. The EDF file contains
    % a varaible number of signals. Knowing the signal content is the first
    % step in most data checking and data analysis steps. To our knowledge
    % there are no tools for understanding the content of 
    %
    % Note: sorting of strings uses a string approximation
    %
    % Definitions:
    %      strSet: { 'xxx' 'yyy' 'zzz' }
    %    
    % 
    % Version: 0.1.01
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
    % File created: January 20, 2015
    % Last updated: January 20, 2015 
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
        % Operation parameters
        numPerLine = 10;     % Set number of labels to echo to console on one line        
    end
    %------------------------------------------------ Dependent Properties
    properties (Dependent = true)
        % User access to primary summary variables
        entryTotals
        uniqueEntries
        uniqueConfigurationCount
        uniqueConfigurations
    end
    %--------------------------------------------------- Private Properties
    properties (Access = protected)
        % Primary Summary Variables
        % It is assumed that large sets will be summarized. Entries will be
        % discarded once 
        entryTotalsP = [];
        uniqueEntriesP = {};
        uniqueConfigurationCountP = [];
        uniqueConfigurationsP = {};
        
    end
    %------------------------------------------------------- Public Methods
    methods
        %------------------------------------------------------ Constructor
        function obj = SetCompositionCountStrClass (varargin)
        	% Initialize Class
            
        end
        %----------------------------------------------------------- AddSet
        function obj = AddSet (obj, strSet)
        	% Add a strSet to summary varaibles
            
            % Parse out the new and old components
            if isempty(obj.uniqueEntriesP)
                newEntries = strSet;
                existingEntries = obj.uniqueEntriesP;
            else
                % Identify which 
                compareToUniqueF = @(x)sum(strcmp(x, obj.uniqueEntriesP))>0;
                strExistFlag = cellfun(compareToUniqueF, strSet);
                
                % Seperate into new entries and existing entries
                newIndex = find(~strExistFlag);
                exisitingIndex = find(strExistFlag);
                
                % Assign new values
                newEntries = {};
                existingEntries = {};
                if ~isempty(newIndex)
                    newEntries = strSet(newIndex);
                    %newEntries = newEntries(1);
                end
                if ~isempty(exisitingIndex)
                    existingEntries = strSet(exisitingIndex);
                end                
                
            end
            
            % Update summary variablesstrSet
            obj.uniqueEntriesP = union(obj.uniqueEntriesP, strSet, 'stable');  
            
            %----------------------------------------- Update entry summary
            
            % Process newEntries 
            if ~isempty(newEntries)
                obj.entryTotalsP = obj.entryTotalsP;
                numNewEntries = length(newEntries);
                for a = 1:numNewEntries
                    if isempty(obj.entryTotalsP)
                        obj.entryTotalsP = 1;
                    else
                        obj.entryTotalsP = [obj.entryTotalsP;1];
                    end
                end
            end
            
            % Process existing entries
            if ~isempty(existingEntries)
                for a = 1:length(existingEntries)
                    % Identify entry index
                    entryStr = existingEntries{a};
                    entryIndex = ...
                        find(strcmp(entryStr, obj.uniqueEntriesP));
                    obj.entryTotalsP(entryIndex) = ...
                        obj.entryTotalsP(entryIndex) + 1;
                end
            end            
            
            %------------------------------------- Update Configuration Set
            
            % Get configuration summary
            obj.uniqueConfigurationsP = obj.uniqueConfigurationsP;
            
            % Add configuration if different
            if isempty(obj.uniqueConfigurationsP)
                % Add first configuration
                obj.uniqueConfigurationsP{1} = sort(strSet);
            else
                % Create function to check for difference
                strSet = sort(strSet);
                setDiffF = @(x)(strcmp([x{:}],[strSet{:}]));
                isUniqueConfiguration = ...
                    sum(cellfun(setDiffF, obj.uniqueConfigurationsP)) == 0;
                
                % Add if unique configuration
                if isUniqueConfiguration == 1
                    obj.uniqueConfigurationsP{end+1} = strSet;
                    if isempty(obj.uniqueConfigurationCountP)
                        obj.uniqueConfigurationCountP = 1;
                    else
                        obj.uniqueConfigurationCountP = ...
                            length(obj.uniqueConfigurationsP);
                    end
                end
            end
           
        end
        %--------------------------------------- echoUniqueEntriesToConsole
        function obj = echoUniqueEntriesToConsole (obj)
            % Parameters
            numPerLine = obj.numPerLine;
            
            % Write set labels to console
            uniqueEntries = sort(obj.uniqueEntries);
            numUniqueEntries = length(uniqueEntries);
       
            % Echo results to 
            if ~isempty(uniqueEntries)
                fprintf('uniqueEntries = \n\t');
                for e = 1:numUniqueEntries
                    fprintf('%s\t', uniqueEntries{e});
                    if and(mod(e,numPerLine)== 0, e>1)
                        fprintf('\n\t');
                    end
                end
                fprintf('\n\n');
            else
                fprintf('uniqueEntries = \n\n');
            end
            
        end
        %------------------------------------------------- echoSetToConsole
        function obj = echoUniqueEntriesWithCountToConsole (obj)
            % Parameters
            numPerLine = obj.numPerLine;
            
            % Write set labels to console
            uniqueEntries = obj.uniqueEntries;
            numUniqueEntries = length(uniqueEntries);
            entryTotalsP = obj.entryTotalsP;
            
            % Echo results to 
            if ~isempty(uniqueEntries)
                % Sort results prior printing
                [uniqueEntries IX] = sort(uniqueEntries);
                entryTotalsP = entryTotalsP(IX);
                
                % Echo results to console
                fprintf('Label\t= \tCount\n');
                for e = 1:numUniqueEntries
                    fprintf('%.0f. %s\t=\t%.0f\n', e, ...
                        uniqueEntries{e}, ...
                        entryTotalsP(e));
                end
                fprintf('\n');
            else
                fprintf('Label\t= \tCount\n');
            end      
        end       
        %----------------------------------- echoSetConfigurationsToConsole
        function obj = echoSetConfigurationsToConsole (obj)
            % Parameters
            numPerLine = obj.numPerLine;
            
            % Write set labels to console
            uniqueConfigurationsP = obj.uniqueConfigurationsP;
            numConfigurations = length(uniqueConfigurationsP);
            
            % Echo results to 
            if numConfigurations > 0
                % Echo results to console
                fprintf('Set Configurations\n');
                for c = 1:numConfigurations
                    % Current configuration
                    currentConfiguration = uniqueConfigurationsP{c};
                    currentConfigLength = length(currentConfiguration);
                    
                    % Echo each entry to the console
                    fprintf('%.0f.\t', c);
                    for e = 1:currentConfigLength
                        fprintf('%s\t', currentConfiguration{e});                      
                    end
                    fprintf('\n');
                end
                fprintf('\n');
            else
                fprintf('Set Configurations\n');
            end      
        end
    end
    %---------------------------------------------------- Private functions
    methods (Access=protected)

    end
    %------------------------------------------------- Dependent Properties
    methods 
        %---------------------------------------------------- entryTotals
        function value = get.entryTotals (obj)
            [s IX] = sort(obj.uniqueEntriesP);
            value = obj.entryTotalsP(IX);
        end
        %---------------------------------------------------- uniqueEntries
        function value = get.uniqueEntries (obj)
            value = sort(obj.uniqueEntriesP);
        end
        %----------------------------------------- uniqueConfigurationCount
        function value = get.uniqueConfigurationCount (obj)
            value = obj.uniqueConfigurationCountP;
        end
        %-------------------------------------------- uniqueConfigureations
        function value = get.uniqueConfigurations (obj)
            value = obj.uniqueConfigurationsP;
        end
    end
    %---------------------------------------------------- Static Properties
    methods(Static)
    end
end

