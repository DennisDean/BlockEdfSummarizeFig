function varargout = BlockEdfSummarizeFigAbout(varargin)
% BLOCKEDFSUMMARIZEFIGABOUT MATLAB code for BlockEdfSummarizeFigAbout.fig
%      BLOCKEDFSUMMARIZEFIGABOUT, by itself, creates a new BLOCKEDFSUMMARIZEFIGABOUT or raises the existing
%      singleton*.
%
%      H = BLOCKEDFSUMMARIZEFIGABOUT returns the handle to a new BLOCKEDFSUMMARIZEFIGABOUT or the handle to
%      the existing singleton*.
%
%      BLOCKEDFSUMMARIZEFIGABOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BLOCKEDFSUMMARIZEFIGABOUT.M with the given input arguments.
%
%      BLOCKEDFSUMMARIZEFIGABOUT('Property','Value',...) creates a new BLOCKEDFSUMMARIZEFIGABOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BlockEdfSummarizeFigAbout_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BlockEdfSummarizeFigAbout_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BlockEdfSummarizeFigAbout

% Last Modified by GUIDE v2.5 06-Feb-2014 12:07:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BlockEdfSummarizeFigAbout_OpeningFcn, ...
                   'gui_OutputFcn',  @BlockEdfSummarizeFigAbout_OutputFcn, ...
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


% --- Executes just before BlockEdfSummarizeFigAbout is made visible.
function BlockEdfSummarizeFigAbout_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BlockEdfSummarizeFigAbout (see VARARGIN)

% Choose default command line output for BlockEdfSummarizeFigAbout
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BlockEdfSummarizeFigAbout wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BlockEdfSummarizeFigAbout_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_fig_ok.
function pb_fig_ok_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fig_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close BlockEdfSummarizeFigAbout
