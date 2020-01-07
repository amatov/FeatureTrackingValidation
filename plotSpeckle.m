function plotSpeckle

% allows to display a manually selected speckle
%
% SYNOPSIS plotSpeckle
%
% Alexandre Matov, 11-Mar-2004

h=gca;
handles=guidata(findobj('Name','manTrack'));
coord=get(h,'CurrentPoint');
if handles.no == handles.noInit
    return
end
% find the closest speckle from cands using createDistanceMatrix
for i = 1:length(handles.tempCands)   
    dist(i)=createDistanceMatrix(handles.tempCands(i).Lmax,[coord(1,2) coord(1,1)]);
    res(i,:) = [dist(i) i];
end
speck=sortrows(res);
handles.speckleIndx(handles.no)=speck(1,2); % the index in the cands structure of the closest detected speckle
handles.frame(handles.no) = handles.no;
if ~isempty(handles.speckleCo)
    indx = find(handles.speckleCo(:,1) == handles.no);
else
    indx=[];
end
if isempty(indx)
    handles.hPlot(end+1,1)=plot(coord(1,1),coord(1,2),'b.');
    handles.near(end+1,1) = plot(handles.tempCands(speck(1,2)).Lmax(2),handles.tempCands(speck(1,2)).Lmax(1),'yo');  
    set(handles.hPlot(end,1),'ButtonDownFcn','deleteSpeckle');
    set(handles.near(end,1),'ButtonDownFcn','plotSpeckle');
    handles.speckleCo(end+1,:) = [handles.no coord(1,1) coord(1,2)];
    hTextB=text(coord(1,1)-6,coord(1,2)-6,[num2str(handles.no)],'Color','b');
    set(hTextB,'ButtonDownFcn','plotSpeckle');
    handles.textB(end+1,1)=hTextB;
else
    if ~isempty(handles.hPlot) & ishandle(handles.hPlot(indx,1))
        delete(handles.hPlot(indx,1));
    end
    if ishandle(handles.near)
        delete(handles.near(indx));
        handles.near(indx) = [];
    end
    if ~isempty(handles.textB) & ishandle(handles.textB(indx,1))
        delete(handles.textB(indx,1));
    end
    handles.hPlot(indx,1) = plot(coord(1,1),coord(1,2),'b.');  
    handles.near(indx,1) = plot(handles.tempCands(speck(1,2)).Lmax(2),handles.tempCands(speck(1,2)).Lmax(1),'yo');  
    set(handles.hPlot(indx),'ButtonDownFcn','deleteSpeckle');
    set(handles.near(indx),'ButtonDownFcn','plotSpeckle');
    handles.speckleCo(indx,:) = [handles.no coord(1,1) coord(1,2)];
    hTextB=text(coord(1,1)-6,coord(1,2)-6,[num2str(handles.no)],'Color','b');
    set(hTextB,'ButtonDownFcn','plotSpeckle');
    handles.textB(indx,1)=hTextB;
    indx = [];
end
guidata(findobj('Name','manTrack'),handles);