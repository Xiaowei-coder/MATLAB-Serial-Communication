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
% ��ʾ��ʾ��Ϣ
set(hObject,'string',handles.port_data);
set(handles.txtNotify,'string',['�����',handles.port_data,'�˿�,',...
                                '������Ϊ',num2str(handles.baud_data)]);                            
% ���ô������ԣ��򿪴��ڽ�������
% delete(instrfindall)                         % �ر�ǰ��ռ�õĶ˿�
% s = serial(handles.port_data);               % ���ö˿�
% set(s,'BaudRate',handles.baud_data);         % ���ò�����
% fopen(s);                                    % �򿪶˿�
% i=1;
% while(1)                                     % �������ݵ�Ԫ������ A
%     fprintf(s,'*IDN?');
%     out = fscanf(s);
%     A{i}=cellstr(out);
%     i=i+1;
%     
% end



% --- Executes on button press in btnClosePort.
function btnClosePort_Callback(hObject, eventdata, handles)
% hObject    handle to btnClosePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Determine the selected data set.
% �رմ��ڲ�����ʾ��ʾ��Ϣ
set(handles.txtNotify,'string','��ǰδ���κδ���');
% fclose(s);
% delete(s)
% clear s
% delete(instrfindall)                         % �ر�ǰ��ռ�õĶ˿�

% --- Executes on button press in btnSaveFile.
function btnSaveFile_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.tblShowData,'Data',randi(100,10,3));
D = {1,2,3,4,5,6,7,8};
DTable = cell2table(D);
Dcell = table2cell(DTable);
set(handles.tblShowData,'Data',Dcell);


% --- Executes on selection change in mnChoosePort.
function mnChoosePort_Callback(hObject, eventdata, handles)
% hObject    handle to mnChoosePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mnChoosePort contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mnChoosePort
str = get(hObject, 'String');
val = get(hObject,'Value');
% �ж�ѡ���ĸ��˿�
handles.port_data = getPort(str{val});
% �������ṹ
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
% �ж�ѡ���ĸ�������
handles.baud_data = getBaud(str{val});
% �������ṹ
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



% --- Executes during object creation, after setting all properties.
function figSerialComm_CreateFcn(hObject, eventdata, handles)
