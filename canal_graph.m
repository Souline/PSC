function varargout = canal_graph(varargin)
% CANAL_GRAPH MATLAB code for canal_graph.fig
%      CANAL_GRAPH, by itself, creates a new CANAL_GRAPH or raises the existing
%      singleton*.
%
%      H = CANAL_GRAPH returns the handle to a new CANAL_GRAPH or the handle to
%      the existing singleton*.
%
%      CANAL_GRAPH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CANAL_GRAPH.M with the given input arguments.
%
%      CANAL_GRAPH('Property','Value',...) creates a new CANAL_GRAPH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before canal_graph_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to canal_graph_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help canal_graph

% Last Modified by GUIDE v2.5 04-Jan-2017 22:41:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @canal_graph_OpeningFcn, ...
                   'gui_OutputFcn',  @canal_graph_OutputFcn, ...
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


% --- Executes just before canal_graph is made visible.
function canal_graph_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to canal_graph (see VARARGIN)

% Choose default command line output for canal_graph
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.slider_desadaptation, 'Min', 0);
set(handles.slider_desadaptation, 'Max', 50);
set(handles.slider_desadaptation, 'Value', 1);
set(handles.slide_line, 'Min', 0);
set(handles.slide_line, 'Max', 10000);
set(handles.slide_line, 'Value', 10); 

% UIWAIT makes canal_graph wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = canal_graph_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slide_line_Callback(hObject, eventdata, handles)
% hObject    handle to slide_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

wire= get(handles.slide_line, 'Value');
desadaptation= get(handles.slider_desadaptation, 'Value');
H= channel_filter(wire,desadaptation);
Hr = [H(1:256) 0 conj(fliplr(H(2:256))) ];
plot(handles.axes1,20*log10(abs(Hr))) ;
plot(handles.axes2,ifft(Hr, 'symmetric')) ;
set(handles.edit1,'String',num2str(wire));
set(handles.edit2,'String',num2str(desadaptation));



% --- Executes during object creation, after setting all properties.
function slide_line_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slide_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on slider movement.
function slider_desadaptation_Callback(hObject, eventdata, handles)
% hObject    handle to slider_desadaptation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 
wire= get(handles.slide_line, 'Value');
desadaptation= get(handles.slider_desadaptation, 'Value');
H= channel_filter(wire,desadaptation);
Hr = [H(1:256) 0 conj(fliplr(H(2:256))) ];
plot(handles.axes1,20*log10(abs(Hr))) ;
plot(handles.axes2,ifft(Hr, 'symmetric')) ;
set(handles.edit1,'String',num2str(wire));
set(handles.edit2,'String',num2str(desadaptation));


% --- Executes during object creation, after setting all properties.
function slider_desadaptation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_desadaptation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
