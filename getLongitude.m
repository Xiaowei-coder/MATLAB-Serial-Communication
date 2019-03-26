function [PositionLonStr,PositionLonNum] = getLongitude(LongitudeStr)
% 得到纬度信息，10404.00096E东经104°4′0.096″
NumStr = LongitudeStr(1:end-1);
LocStr = LongitudeStr(end);
if(LocStr == 'E')
    Loc = '东经';
elseif(LocStr == 'W')
    Loc = '西经';
else
    disp('not in Earth');
end
PositionLonStr = strcat(Loc,NumStr);
PositionLonNum = str2double(NumStr);
end