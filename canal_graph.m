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

% Last Modified by GUIDE v2.5 11-Jan-2017 20:45:27

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
set(handles.slider_snr, 'Min', 0);
set(handles.slider_snr, 'Max', 1000);
set(handles.slider_snr, 'Value', 100); 

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
crosstalk= get(handles.Crosstalk,'Value');
awgn=get(handles.awgn,'Value');
snr=get(handles.slider_snr,'Value');


wire= get(handles.slide_line, 'Value');
desadaptation= get(handles.slider_desadaptation, 'Value');
H= channel_filter2(wire,desadaptation);

if (crosstalk == 0) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,0,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;
   

elseif (crosstalk == 1) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,1,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 0) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,0,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 1) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,1,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

end    
set(handles.edit1,'String',num2str(wire));
set(handles.edit2,'String',num2str(desadaptation));
set(handles.edit3,'String',num2str(snr));




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
crosstalk= get(handles.Crosstalk,'Value');
awgn=get(handles.awgn,'Value');
snr=get(handles.slider_snr,'Value');


wire= get(handles.slide_line, 'Value');
desadaptation= get(handles.slider_desadaptation, 'Value');
H= channel_filter2(wire,desadaptation);

if (crosstalk == 0) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,0,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;
   

elseif (crosstalk == 1) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,1,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 0) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,0,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 1) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,1,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

end    
set(handles.edit1,'String',num2str(wire));
set(handles.edit2,'String',num2str(desadaptation));
set(handles.edit3,'String',num2str(snr));


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


% --- Executes on button press in awgn.
function awgn_Callback(hObject, eventdata, handles)
% hObject    handle to awgn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of awgn
crosstalk= get(handles.Crosstalk,'Value');
awgn=get(handles.awgn,'Value');

snr=get(handles.slider_snr,'Value');

wire= get(handles.slide_line, 'Value');
desadaptation= get(handles.slider_desadaptation, 'Value');
H= channel_filter2(wire,desadaptation);

if (crosstalk == 0) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,0,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;
   

elseif (crosstalk == 1) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,1,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 0) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,0,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 1) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,1,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

end    
set(handles.edit1,'String',num2str(wire));
set(handles.edit2,'String',num2str(desadaptation));
set(handles.edit3,'String',num2str(snr));



% --- Executes on button press in Crosstalk.
function Crosstalk_Callback(hObject, eventdata, handles)
% hObject    handle to Crosstalk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Crosstalk

crosstalk= get(handles.Crosstalk,'Value');
awgn=get(handles.awgn,'Value');
snr=get(handles.slider_snr,'Value');


wire= get(handles.slide_line, 'Value');
desadaptation= get(handles.slider_desadaptation, 'Value');
H= channel_filter2(wire,desadaptation);

if (crosstalk == 0) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,0,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;
   

elseif (crosstalk == 1) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,1,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 0) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,0,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 1) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,1,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

end    
set(handles.edit1,'String',num2str(wire));
set(handles.edit2,'String',num2str(desadaptation));
set(handles.edit3,'String',num2str(snr));


% --- Executes on slider movement.
function slider_snr_Callback(hObject, eventdata, handles)
% hObject    handle to slider_snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
crosstalk= get(handles.Crosstalk,'Value');
awgn=get(handles.awgn,'Value');
snr=get(handles.slider_snr,'Value');

wire= get(handles.slide_line, 'Value');
desadaptation= get(handles.slider_desadaptation, 'Value');
H= channel_filter2(wire,desadaptation);

if (crosstalk == 0) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,0,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;
   

elseif (crosstalk == 1) && (awgn==0) 
    Hr=pertubations_signal(H,wire,desadaptation,1,0,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 0) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,0,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

elseif (crosstalk == 1) && (awgn==1)
    Hr=pertubations_signal(H,wire,desadaptation,1,1,snr);
    Hfreq= 20*log10(abs(Hr));
    Htemps= ifft(Hr, 'symmetric');
    plot(handles.axes1,Hfreq) ;
    plot(handles.axes2,Htemps) ;

end    
set(handles.edit1,'String',num2str(wire));
set(handles.edit2,'String',num2str(desadaptation));
set(handles.edit3,'String',num2str(snr));




% --- Executes during object creation, after setting all properties.
function slider_snr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
