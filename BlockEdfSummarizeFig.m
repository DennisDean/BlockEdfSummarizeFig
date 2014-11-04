function varargout = BlockEdfSummarizeFig(varargin)
% BLOCKEDFSUMMARIZEFIG MATLAB code for BlockEdfSummarizeFig.fig
%      BLOCKEDFSUMMARIZEFIG, by itself, creates a new BLOCKEDFSUMMARIZEFIG or raises the existing
%      singleton*.
%
%      H = BLOCKEDFSUMMARIZEFIG returns the handle to a new BLOCKEDFSUMMARIZEFIG or the handle to
%      the existing singleton*.
%
%      BLOCKEDFSUMMARIZEFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLOCKEDFSUMMARIZEFIG.M with the given input arguments.
%
%      BLOCKEDFSUMMARIZEFIG('Property','Value',...) creates a new BLOCKEDFSUMMARIZEFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BlockEdfSummarizeFig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BlockEdfSummarizeFig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BlockEdfSummarizeFig

% Last Modified by GUIDE v2.5 04-Nov-2014 08:18:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BlockEdfSummarizeFig_OpeningFcn, ...
                   'gui_OutputFcn',  @BlockEdfSummarizeFig_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BlockEdfSummarizeFig is made visible.
function BlockEdfSummarizeFig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BlockEdfSummarizeFig (see VARARGIN)

% Choose default command line output for BlockEdfSummarizeFig
handles.output = hObject;

% Clear edit text boxes
set(handles.e_edf_edf_folder, 'String',' ');
set(handles.e_edf_summary_file_name, 'String',' ');
set(handles.e_edf_signal_labels, 'String','{}');

% Inactivate button until data is loaded
set(handles.pb_edf_create_file_list, 'enable','off');
set(handles.pb_create_header_summary, 'enable','off');
set(handles.pb_create_signal_summary, 'enable','off');
set(handles.pb_edf_create_summary, 'enable','off');
set(handles.pb_xml_check, 'enable','off');

% Create 
handles.summaryFilePath = strcat(cd,'\');
handles.edf_pn = strcat(cd,'\');
handles.edf_FolderName = '';
handles.pnSeperator = '\';
handles.summaryFileName = '';
handles.splitFileListCellwLabels = {};
handles.edfFileListName = '';

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BlockEdfSummarizeFig wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = BlockEdfSummarizeFig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% redo but in pixel
% Set starting position in characters. Had problems with pixels
left_border = .8;
header = 2.0;
set(0,'Units','character') ;
screen_size = get(0,'ScreenSize');
set(handles.figure1,'Units','character');
dlg_size    = get(handles.figure1, 'Position');
pos1 = [ left_border , screen_size(4)-dlg_size(4)-1*header,...
    dlg_size(3) , dlg_size(4)];
set(handles.figure1,'Units','character');
set(handles.figure1,'Position',pos1);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_fig_quit.
function pb_fig_quit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fig_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Close GUI figure
close BlockEdfSummarizeFig

% --- Executes on button press in pb_fig_folder.
function pb_fig_folder_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fig_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open folder dialog box
start_path = handles.summaryFilePath;
dialog_title = 'Summary file save directory';
folder_name = uigetdir(start_path, dialog_title);

% Check return values
if isstr(folder_name)
   % user selected a folder
   handles.summaryFilePath = strcat(folder_name,'\');
   
   % Update handles structure
    guidata(hObject, handles);
end

function e_edf_edf_folder_Callback(hObject, eventdata, handles)
% hObject    handle to e_edf_edf_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_edf_edf_folder as text
%        str2double(get(hObject,'String')) returns contents of e_edf_edf_folder as a double


% --- Executes during object creation, after setting all properties.
function e_edf_edf_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_edf_edf_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_edf_select_edf_folder.
function pb_edf_select_edf_folder_Callback(hObject, eventdata, handles)
% hObject    handle to pb_edf_select_edf_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Default to current EDF path
current_edf_path = handles.edf_pn;

% Open folder dialog box
start_path = current_edf_path;
dialog_title = 'Select EDF/XML directory';
folder_name = uigetdir(start_path, dialog_title);

% check if user selected a file
if folder_name ~= 0
    % Get folder name
    k = strfind(folder_name, handles.pnSeperator);
    edf_FolderName = folder_name(k(end)+1:end);
    
    % Write file name to dialog box
    set(handles.e_edf_edf_folder, 'String', edf_FolderName);
    
    % Create a file  
    summaryFilePath = handles.summaryFilePath;
    summaryFileName = strcat(edf_FolderName, '_');
    set(handles.e_edf_summary_file_name, 'String', summaryFileName);
    handles.edfFileListName = strcat(edf_FolderName, '.EdfFileList.xls');

    % Turn on buttons
    set(handles.pb_edf_create_file_list, 'enable','on');
    set(handles.pb_edf_create_summary, 'enable','off');
    set(handles.pb_create_header_summary, 'enable','off');
    set(handles.pb_create_signal_summary, 'enable','off');
    set(handles.pb_xml_check, 'enable','off');
    
    % Save file information to globals
    handles.edf_pn = strcat(folder_name, handles.pnSeperator);
    handles.edf_FolderName = edf_FolderName;
    handles.summaryFileName = summaryFileName;
    
    % Save new varaibles
    guidata(hObject, handles);
end

function e_edf_summary_file_name_Callback(hObject, eventdata, handles)
% hObject    handle to e_edf_summary_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_edf_summary_file_name as text
%        str2double(get(hObject,'String')) returns contents of e_edf_summary_file_name as a double


% --- Executes during object creation, after setting all properties.
function e_edf_summary_file_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_edf_summary_file_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_edf_create_file_list.
function pb_edf_create_file_list_Callback(hObject, eventdata, handles)
% hObject    handle to pb_edf_create_file_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get Path/File Information
summaryFilePath = handles.summaryFilePath;
handles.edfFileListName = get(handles.e_edf_summary_file_name, 'String');
edfFileListName = strcat(summaryFilePath, handles.edfFileListName,'_Edf_File_List.xls');
edf_pn = handles.edf_pn;
edf_pn = edf_pn(1:end-1);
edf_FolderName = handles.edf_FolderName;

% Echo Status to console
fprintf('\nStarting search for EDF files in folder: %s\n\n', ...
    edf_FolderName);

% Generate Matched files    
GetMatchedSleepEdfXmlFiles(edf_pn, edfFileListName);
splitFileListCellwLabels = ...
        GetMatchedSleepEdfXmlFiles(edf_pn, edfFileListName);
    
% Save file list
handles.splitFileListCellwLabels = splitFileListCellwLabels;
 
% Turn on buttons
set(handles.pb_edf_create_file_list, 'enable','on');
set(handles.pb_edf_create_summary, 'enable','on');
set(handles.pb_create_header_summary, 'enable','on');
set(handles.pb_create_signal_summary, 'enable','on');
set(handles.pb_xml_check, 'enable','on');

% Update User
fprintf('File list containing %.0f entries created:\n\t%s\n', ...
    size(splitFileListCellwLabels{:},1)-1, edfFileListName);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pb_edf_create_summary.
function pb_edf_create_summary_Callback(hObject, eventdata, handles)
% hObject    handle to pb_edf_create_summary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Generate EDF File list
summaryFilePath = handles.summaryFilePath;
handles.edfFileListName = get(handles.e_edf_summary_file_name, 'String');
edfFileListName = strcat(summaryFilePath, handles.edfFileListName,'_Edf_File_List.xls');

% Get Path/File Information
summaryFilePath = handles.summaryFilePath;
summaryFileName = get(handles.e_edf_summary_file_name, 'String');
summaryFileName = strcat(summaryFilePath, summaryFileName,'_HeaderCheckSummary.xls');

% XLS File name
xlsFileList = edfFileListName;
xlsFileSummaryOut = summaryFileName; 

% Update user
fprintf('\nHeader and EDF check initiated\n');

% Create clas
besObj = BlockEdfSummarizeClass(xlsFileList, xlsFileSummaryOut);
besObj = besObj.summarizeHeaderWithCheck;

% Update User
fprintf('Header and EDF check summary written to:\t%s\n', xlsFileSummaryOut);
    
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_fig_about.
function pb_fig_about_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fig_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

BlockEdfSummarizeFigAbout


% --- Executes on button press in pb_create_header_summary.
function pb_create_header_summary_Callback(hObject, eventdata, handles)
% hObject    handle to pb_create_header_summary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Generate EDF File list
summaryFilePath = handles.summaryFilePath;
handles.edfFileListName = get(handles.e_edf_summary_file_name, 'String');
edfFileListName = strcat(summaryFilePath, handles.edfFileListName,'_Edf_File_List.xls');

% Get Path/File Information
summaryFilePath = handles.summaryFilePath;
summaryFileName = get(handles.e_edf_summary_file_name, 'String');
summaryFileName = strcat(summaryFilePath, summaryFileName,'_HeaderCheckSummary.xls');

% XLS File name
xlsFileList = edfFileListName;
xlsFileSummaryOut = summaryFileName; 

% Create clas
besObj = BlockEdfSummarizeClass(xlsFileList, xlsFileSummaryOut);
besObj = besObj.summarizeHeader;

    
% --- Executes on button press in pb_create_signal_summary.
function pb_create_signal_summary_Callback(hObject, eventdata, handles)
% hObject    handle to pb_create_signal_summary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Generate EDF File list
summaryFilePath = handles.summaryFilePath;
handles.edfFileListName = get(handles.e_edf_summary_file_name, 'String');
edfFileListName = strcat(summaryFilePath, handles.edfFileListName,'_Edf_File_List.xls');

% Get Path/File Information
summaryFilePath = handles.summaryFilePath;
summaryFileName = get(handles.e_edf_summary_file_name, 'String');
summaryFileName = strcat(summaryFilePath, summaryFileName,'_HeaderSignalSummary.xls');

% XLS File name
xlsFileList = edfFileListName;
xlsFileSummaryOut = summaryFileName; 

% Update User
fprintf('\nSummarizing signal information\n');

% Create clas
besObj = BlockEdfSummarizeClass(xlsFileList, xlsFileSummaryOut);
besObj = besObj.summarizeSignalLabels;

% Update User
fprintf('Signal summary written to:\t%s\n', xlsFileSummaryOut);


% --- Executes on button press in pb_xml_check.
function pb_xml_check_Callback(hObject, eventdata, handles)
% hObject    handle to pb_xml_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Generate EDF File list
summaryFilePath = handles.summaryFilePath;
handles.edfFileListName = get(handles.e_edf_summary_file_name, 'String');
edfFileListName = strcat(summaryFilePath, handles.edfFileListName,'_Edf_File_List.xls');

% Get Path/File Information
summaryFilePath = handles.summaryFilePath;
summaryFileName = get(handles.e_edf_summary_file_name, 'String');
summaryFileName = strcat(summaryFilePath, summaryFileName,'_XML_Summary.xls');

% XLS File name
xlsFileList = edfFileListName;
xlsFileSummaryOut = summaryFileName; 

% Load XML file
[txt num raw] =  xlsread(xlsFileList);
xmlFile = raw(2:end, 7);
xmlPath = raw(2:end, 11);
numFiles = size(xmlFile, 1);
% numFiles = 10;

% Check each file
checkFlags = zeros(numFiles, 1);
checkMsgs = cell(numFiles,1);
   
% Update User
fprintf('\nInitiating XML summary check\n');

% For each file
start = 1;
fprintf('Checking %.0f XML files\n', numFiles);
tic
for f = start:numFiles
    % Processing 
    % fprintf('%.0f %s\n', f, xmlFileList{f});

    % Create class and load file
    xmlFn1 = strcat(xmlPath{f}, '\', xmlFile{f});
    lcaObj = loadCompumedicsAnnotationsClass(xmlFn1);
    lcaObj.GET_SCORED_EVENTS = 0;
    lcaObj = lcaObj.loadFile;

    % Save check flag
    checkFlags(f) = lcaObj.errorFlag;
    checkMsgs{f} = lcaObj.errorMsg;
end
elapseTime = toc;
% Save checks to file
resultCell = [num2cell([1:numFiles]'), xmlFile(start:numFiles)];
resultCell = [resultCell num2cell(checkFlags) checkMsgs];
resultCell = ...
   [ {'ID', 'File Name', 'Check Flag', 'Error Msg'};  resultCell];
xlswrite(summaryFileName, resultCell);
   
% Update User
fprintf('XML summary check written to (%.1f min):\t%s\n', elapseTime/60, xlsFileSummaryOut);


% --- Executes on button press in pb_ed_signal_plus.
function pb_ed_signal_plus_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ed_signal_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Generate EDF File list
summaryFilePath = handles.summaryFilePath;
handles.edfFileListName = get(handles.e_edf_summary_file_name, 'String');
edfFileListName = strcat(summaryFilePath, handles.edfFileListName,'_Edf_File_List.xls');

% Get Path/File Information
summaryFilePath = handles.summaryFilePath;
summaryFileName = get(handles.e_edf_summary_file_name, 'String');
summaryFileName = strcat(summaryFilePath, summaryFileName,'_HeaderSignalSummary.xls');

% XLS File name
xlsFileList = edfFileListName;
xlsFileSummaryOut = summaryFileName; 

% Get Signal Summary
signalLabelSamplingRate = eval(get(handles.e_edf_signal_labels, 'String'));

% Update User
fprintf('\nSummarizing signal + sampling rate information\n');

% Create clas
besObj = BlockEdfSummarizeClass(xlsFileList, xlsFileSummaryOut);
besObj.signalLabelSamplingRate = signalLabelSamplingRate;
besObj = besObj.summarizeSignalLabelsPlus;

% Update User
fprintf('Signal summary written to:\t%s\n', xlsFileSummaryOut);



function e_edf_signal_labels_Callback(hObject, eventdata, handles)
% hObject    handle to e_edf_signal_labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_edf_signal_labels as text
%        str2double(get(hObject,'String')) returns contents of e_edf_signal_labels as a double


% --- Executes during object creation, after setting all properties.
function e_edf_signal_labels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_edf_signal_labels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
