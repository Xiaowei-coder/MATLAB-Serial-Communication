function [PositionLonStr,PositionLonNum] = getLongitude(LongitudeStr)
% �õ�γ����Ϣ��10404.00096E����104��4��0.096��
NumStr = LongitudeStr(1:end-1);
LocStr = LongitudeStr(end);
if(LocStr == 'E')
    Loc = '����';
elseif(LocStr == 'W')
    Loc = '����';
else
    disp('not in Earth');
end
PositionLonStr = strcat(Loc,NumStr);
PositionLonNum = str2double(NumStr);
end