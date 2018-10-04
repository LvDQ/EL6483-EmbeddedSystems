function varargout = gui_1st(varargin)
% gui_1st MATLAB code for gui_1st.fig
%      gui_1st, by itself, creates a new gui_1st or raises the existing
%      singleton*.
%
%      H = gui_1st returns the handle to a new gui_1st or the handle to
%      the existing singleton*.
%
%      gui_1st('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gui_1st.M with the given input arguments.
%
%      gui_1st('Property','Value',...) creates a new gui_1st or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_1st_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_1st_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_1st

% Last Modified by GUIDE v2.5 02-May-2017 23:50:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_1st_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_1st_OutputFcn, ...
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


% --- Executes just before gui_1st is made visible.
function gui_1st_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_1st (see VARARGIN)

% Choose default command line output for gui_1st
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes gui_1st wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_1st_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


SerialPort='COM3'; %serial port
freq = 50*60*60*24/10;
loop=500;%display time, in minute
loop = loop*60/(freq*24*60*21.5);
timeInterval = 0;
scale = 100;
scale2 = 20;
X = zeros(1, scale);
Y = zeros(1, scale);
Z = zeros(1, scale);
a = zeros(1, scale);
a_fft = zeros(1, scale2);
ecg = zeros(1, scale2);
ecg_fft = zeros(1, scale2);
time = zeros(1, scale);
time_2 = zeros(1, scale2);
time_fft = 1:scale2;

s = serial(SerialPort);
fopen(s);
%global work
count = 0;

while (count ~= loop)

    while(fread(s, 1) ~= 102)
    end
   
    X(1:end-1) = X(2:end);    
    X(end) = fread(s, 1)/128 - 2*fread(s, 1);    
    
    Y(1:end-1) = Y(2:end);    
    Y(end) = fread(s, 1)/128 - 2*fread(s, 1); 
    
    Z(1:end-1) = Z(2:end);    
    Z(end) = fread(s, 1)/128 - 2*fread(s, 1);
    
    a(1:end-1) = a(2:end);
    a(end) = sqrt(X(end)^2 + Y(end)^2 + Z(end)^2);
    a_fft = fftshift(abs(fft(a(scale-scale2+1:end))));
    
    ecg(1:end-1) = ecg(2:end);
    ecg(end) = fread(s, 1) + 256*fread(s, 1);
    ecg_fft = fftshift(abs(fft(ecg)));
    
    time(1:end-1) = time(2:end);    
    time(end) = count/freq;
    time_2(1:end-1) = time_2(2:end);    
    time_2(end) = count/freq;
    
    

    axes(handles.axes1);
    %plot(time, X, time, Y, time, Z)
    plot(time, a)
    datetick('x','MM:SS');
    
    axes(handles.axes2);
    plot(time_2, ecg)
    datetick('x','MM:SS');
    
    axes(handles.axes3);
    stem(time_fft, a_fft, '.')
    
    axes(handles.axes4);
    stem(time_fft, ecg_fft, '.')
    
    
    pause(timeInterval);
    count = count +1;
end



fclose(s);
delete(s);
clear s;

