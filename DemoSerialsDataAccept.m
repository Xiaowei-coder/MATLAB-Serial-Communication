clear;clc;
delete(instrfindall) % �ر�ǰ��ռ�õĶ˿ڣ�������Ҫ 
%% �Ӵ��ڶ�ȡ����
s = serial('COM2');  % ���ö˿�Ϊ COM2
set(s,'BaudRate',9600); % ���ò�����Ϊ 9600
fopen(s);            % �򿪶˿�
% ��ȡ���ݲ�������Ԫ������ A
for i=1:1:10
fprintf(s,'*IDN?');
out = fscanf(s);
A{i}=cellstr(out);
disp(out)
end
fclose(s);
delete(s)
clear s
%% �������ݣ���Ҫ����ȡԪ��������
str = 'START,A017,3031.07100N,10404.00096E,181213101431,658038464,0295,STOP';
% ������ʽ�ָ�����
DataCellArr = regexp(str,',','split');
START = DataCellArr{1};
STOP = DataCellArr{8};
% �ж�֡ͷ֡β�Ƿ�����
if((START == "START" ) && (STOP == "STOP"))
    disp('data is security');
else
    disp('data is not security');
end
% ȡ������
AddressCode = DataCellArr{2};
LatitudeBefore = DataCellArr{3};
LongitudeBefore = DataCellArr{4};
UTCDateTimeBeefore = DataCellArr{5};
TriggerTimeBefore = DataCellArr{6};
PowerBefore = DataCellArr{7};
% ��ȡ����ԭʼ����ת��Ϊ���õ���Ϣ
[PositionLatStr,PositionLatNum] = getLatitude(LatitudeBefore);
[PositionLonStr,PositionLonNum] = getLongitude(LongitudeBefore);
UTCDateTime = getTime(UTCDateTimeBeefore);
TriggerTimeArr = getTriggerTime(TriggerTimeBefore);
Power = getPower(PowerBefore);
%% ��ʾ����
% f = uifigure;
% f.Name = '��������';
% t = uitable(f,'Data',[1 2 3; 4 5 6; 7 8 9]);
% t.FontSize = 10;


%% ���㴦��