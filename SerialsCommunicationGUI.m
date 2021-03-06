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

% 打开时候完成的操作在这~~
function SerialsCommunicationGUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simple_g(see VARARGIN)
handles.output = hObject;
warning off all;
javaFram = get(hObject,'JavaFrame');
javaFram.setFigureIcon(javax.swing.ImageIcon('./img/icon.png'));
set(handles.tblShowData,'ColumnWidth',{120});
data = get(handles.tblShowData,'Data');
if ~isempty(data)
data(1:4,:) = [];
set(handles.tblShowData,'Data',data);
end
set(handles.tblShowData,'RearrangeableColumns','on');
% 传递端口和波特率设置数据
str = get(handles.mnChoosePort, 'String');
val = get(handles.mnChoosePort,'Value');
% 判断选了哪个端口
handles.port_data = getPort(str{val});
str = get(handles.mnChooseBaud, 'String');
val = get(handles.mnChooseBaud,'Value');
% 判断选了哪个波特率
handles.baud_data = getBaud(str{val});
handles.scom=serial('COM1');    % 设置端口
% 显示时间，设置定时器属性，每秒触发调用 dispTime函数
handles.timer =  timer('Period',1,'TimerFcn',{@dispTime,handles},...
    'BusyMode','queue','ExecutionMode','fixedRate');
start(handles.timer);
handles.hasData = 0;
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = SerialsCommunicationGUI_OutputFcn(hObject, eventdata, handles) 
% 窗口输出参数函数
varargout{1} = handles.output;



function btnOpenClosePort_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of btnOpenClosePort
val = get(hObject,'value');                   
if val==1            % 串口打开状态，显示关闭字符
delete(instrfindall)                            % 关闭前面占用的端口，这句很重要 
handles.scom = serial(handles.port_data);       % 新建串口
set(handles.scom,'BaudRate',handles.baud_data); % 设置波特率
set(handles.scom,'BytesAvailableFcnCount',69);
set(handles.scom,'BytesAvailableFcnMode','byte');
set(handles.scom,'BytesAvailableFcn',{@bytes,handles});
try                                             % 异常捕捉
    fopen(handles.scom);
catch
    msgbox('创建串口失败','错误');
    set(hObject,'value',0);
    handles.val=get(hObject,'val');
    return;
end
set(hObject,'BackgroundColor',[1,0,0]);
set(hObject,'string','关闭串口');
set(handles.txtNotify,'string',['你打开了',handles.port_data,'端口,',...
                                '波特率为',num2str(handles.baud_data)]);
else
closePort(hObject,handles);
end
guidata(hObject, handles);


% --- Executes on button press in btnSaveFile.
function btnSaveFile_Callback(hObject, eventdata, handles)
[FileName,PathName] = uiputfile({'*.txt';'*.csv'},...
    '导出数据','测量数据.txt');
Data = get(handles.tblShowData,'Data');
DataTable = cell2table(Data);
VarName = {'Start','Address','Latitude','Longitude','UTCTime',...
            'TriggerTime','Power','End','DataIntegrity','Addition'};
DataTable.Properties.VariableNames = VarName;
file = strcat(PathName,FileName);
writetable(DataTable,file);
% 2019a版本有这个函数 writecell
% writecell(Data,file,'Delimiter',',')


% --- Executes on selection change in mnChoosePort.
function mnChoosePort_Callback(hObject, eventdata, handles)
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



% --- Executes during object creation, after setting all properties.
function figSerialComm_CreateFcn(hObject, eventdata, handles)

function dispTime(hObject, evendata, handles)
set(handles.txtTime,'String',datestr(now));


% --- Executes when user attempts to close figSerialComm.
function figSerialComm_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figSerialComm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% delete(handles.timer);
t = timerfind;
if ~isempty(t)
    stop(t);
    delete(t);
end
delete(hObject);






