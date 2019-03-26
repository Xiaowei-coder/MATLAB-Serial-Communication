function varargout = SerialsCommunicationGUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SerialsCommunicationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SerialsCommunicationGUI_OutputFcn, ...
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
% --- Executes just before simple_gis made visible.
function SerialsCommunicationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple_g(see VARARGIN)
handles.output = hObject;
handles.port_data = 'COM1';
handles.baud_data = 128000;
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = SerialsCommunicationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnOpenPort.
function btnOpenPort_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpenPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'string',handles.port_data);
set(handles.txtNotify,'string',['你打开了',handles.port_data,'端口,',...
                                '波特率为',num2str(handles.baud_data)]);

% --- Executes on button press in btnClosePort.
function btnClosePort_Callback(hObject, eventdata, handles)
% hObject    handle to btnClosePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Determine the selected data set.
set(handles.txtNotify,'string','当前未打开任何串口');

% --- Executes on selection change in mnChoosePort.
function mnChoosePort_Callback(hObject, eventdata, handles)
% hObject    handle to mnChoosePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnChoosePort contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnChoosePort
str = get(hObject, 'String');
val = get(hObject,'Value');
% 判断选了哪个端口
handles.port_data = getPort(str{val});
% 保存句柄结构
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function mnChoosePort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnChoosePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in mnChooseBaud.
function mnChooseBaud_Callback(hObject, eventdata, handles)
% hObject    handle to mnChooseBaud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnChooseBaud contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnChooseBaud
str = get(hObject, 'String');
val = get(hObject,'Value');
% 判断选了哪个波特率
handles.baud_data = getBaud(str{val});
% 保存句柄结构
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function mnChooseBaud_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mnChooseBaud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSaveFile.
function btnSaveFile_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figSerialComm_CreateFcn(hObject, eventdata, handles)
