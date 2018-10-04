function varargout = EMBEDDED_SYSTEM_FINAL_PROJECT(varargin)
% EMBEDDED_SYSTEM_FINAL_PROJECT MATLAB code for EMBEDDED_SYSTEM_FINAL_PROJECT.fig
%      EMBEDDED_SYSTEM_FINAL_PROJECT, by itself, creates a new EMBEDDED_SYSTEM_FINAL_PROJECT or raises the existing
%      singleton*.
%
%      H = EMBEDDED_SYSTEM_FINAL_PROJECT returns the handle to a new EMBEDDED_SYSTEM_FINAL_PROJECT or the handle to
%      the existing singleton*.
%
%      EMBEDDED_SYSTEM_FINAL_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMBEDDED_SYSTEM_FINAL_PROJECT.M with the given input arguments.
%
%      EMBEDDED_SYSTEM_FINAL_PROJECT('Property','Value',...) creates a new EMBEDDED_SYSTEM_FINAL_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EMBEDDED_SYSTEM_FINAL_PROJECT_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EMBEDDED_SYSTEM_FINAL_PROJECT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EMBEDDED_SYSTEM_FINAL_PROJECT

% Last Modified by GUIDE v2.5 05-May-2017 17:08:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EMBEDDED_SYSTEM_FINAL_PROJECT_OpeningFcn, ...
                   'gui_OutputFcn',  @EMBEDDED_SYSTEM_FINAL_PROJECT_OutputFcn, ...
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


% --- Executes just before EMBEDDED_SYSTEM_FINAL_PROJECT is made visible.
function EMBEDDED_SYSTEM_FINAL_PROJECT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EMBEDDED_SYSTEM_FINAL_PROJECT (see VARARGIN)

% Choose default command line output for EMBEDDED_SYSTEM_FINAL_PROJECT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes EMBEDDED_SYSTEM_FINAL_PROJECT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EMBEDDED_SYSTEM_FINAL_PROJECT_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%serial port
SerialPort='COM5'; 
s = serial(SerialPort);
fopen(s);

interp = 4;%interpolate rate
%transmittion rate is too low, need to reconstruct with DSP
%Nyquist-4 filter designed for interpolate
h = conv([1 1.5 3 1.5 1], [1 4 10 16 19 16 10 4 1]);
h = interp*h/sum(h);
%h = butter(5, .2);
%h = interp*h/sum(h);

%some variables
timeInterval = 0;%constraint of sample rate is set on embedded system, so here is 0
scale = 49;%should be odd
%rate = 3;%suppressed rate of signal being ffted, this is hard to explain, you may ask me directly
middle = (1+scale)/2;
a = zeros(1, scale);
%a_large = zeros(1, interp*scale);
a_fft = zeros(1, scale);
ecg = zeros(1, scale);
ecg_large = zeros(1, interp*scale);
ecg_fft = zeros(1, scale);
%time
time = zeros(1, scale);%origin time
time_2 = (1-middle:middle-1)*360/(scale);%time for fft
time_large = zeros(1, interp*scale);%time used in first row
window_length = 0;
%initial time settings
t = 0;
t0 = now;
while (1)
    %check bit
    while(fread(s, 1) ~= 102)
    end
   
    %time
    t = now - t0;
    time(1:end-1) = time(2:end);
    time(end) = t;
    time_large = linspace(time(1), time(end), length(time_large));
    
    %acceleration and its fft
    a(1:end-1) = a(2:end);
    a(end) = fread(s, 1)/128 + 2*fread(s, 1);
    
    %a_large = zeros(1, interp*scale);
    %a_large(interp:interp:end) = a;
    %a_large = filter(h, 1, a_large);
    
    a_fft = fftshift(abs(fft(a)));
    a_fft(middle) = 0;
    
    %ecg and its fft
    ecg(1:end-1) = ecg(2:end);
    ecg(end) = fread(s, 1)/128 + 2*fread(s, 1);
    
    
    ecg_large = zeros(1, interp*scale);
    ecg_large(interp:interp:end) = ecg;
    ecg_large = filter(h, 1, ecg_large);
    
    ecg_fft = fftshift(abs(fft(ecg)));
    ecg_fft(middle) = 0;

    
    %plot
    axes(handles.axes1);
    plot(time, a)
    datetick('x','MM:SS');
    title('ACCELERATION');
    
    axes(handles.axes2);
    plot(time_large(4*interp:end), ecg_large(4*interp:end))
    datetick('x','MM:SS');
    title('PULSE');
    
    axes(handles.axes3);
    stem(time_2, a_fft, '.')
    title('DISCRETE FOURIER TRANSFORMATION OF ACCELERATON');
    
    axes(handles.axes4);
    stem(time_2, ecg_fft, '.')
    title('DISCRETE FOURIER TRANSFORMATION OF PULSE');
    
    pause(timeInterval);
    %count = count +1;
end



fclose(s);
delete(s);
clear s;
