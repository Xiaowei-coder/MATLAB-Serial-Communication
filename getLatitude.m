function [PositionLatStr,PositionLatNum] = getLatitude(LatitudeStr)
% �õ�γ����Ϣ����ʽΪ3031.07100N ��γ30��31��7.100��
NumStr = LatitudeStr(1:end-1);
LocStr = LatitudeStr(end);
if(LocStr == 'N')
    Loc = '��γ';
elseif(LocStr == 'S')
    Loc = '��γ';
else
    disp('not in Earth');
end
PositionLatStr = strcat(Loc,NumStr);
PositionLatNum = str2double(NumStr);
end