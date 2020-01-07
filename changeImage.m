function changeImage(key)

% advances to the next image when a key is pressed
%
% SYNOPSIS changeImage(key)
%
% Alexandre Matov, 11-Mar-2004

handles = guidata(findobj('Name','manTrack'));
switch key
    case 1
        if handles.no>1 & handles.no<41
            handles.no = handles.no - 1;
            flag = -1;
            if ishandle(handles.neighborPlot)
                delete(handles.neighborPlot);
            end
            if ~isempty(handles.neighborPlot)
                handles.neighborPlot = [];
            end
        else
            msgbox('there are 40 images in the stack (min number 1 and max number 40)')
            return
        end
    case 2
        if handles.no>0 & handles.no<40
            handles.no = handles.no + 1;
            flag = 1;
            if ishandle(handles.neighborPlot)
                delete(handles.neighborPlot);
            end
            if ~isempty(handles.neighborPlot)
                handles.neighborPlot = [];
            end
        else
            msgbox('there are 40 images in the stack (min number 1 and max number 40)')
            return
        end
end
fh = findall(0, 'Name', 'Spindle'); 
if handles.no>0 & handles.no<41
    handles.image = Gauss2D(double(imread(char(handles.listImages(handles.no)))), 1);
else
    msgbox('there are 40 images in the stack')
    return
end
figure(fh)
set(handles.title,'String',['Frame ',num2str(handles.no)]);
guidata(findobj('Name', 'manTrack'), handles);
set(findobj('Type','image'),'CData', handles.image);
refresh(fh);
hold on
delete(handles.currentSp);
haSp=plot(handles.candsR.Lmax(2), handles.candsR.Lmax(1), 'r*');%initial speckle

% Next, plot all the detected speckles. First, load in the cands structure
if isunix == 1
    temp_cands_fname = strcat('/unc/manTrackWT2s/speckles/cands0', num2str(handles.no+50), '.mat');
else
    temp_cands_fname = strcat('U:\manTrackWT2s\speckles\cands0', num2str(handles.no+50), '.mat');
end
load(temp_cands_fname); % Load in the new cand structure.
cands=cands(find([cands.status]==1)); % do not consider the insignificant ones!!

[temp0 length] = size(cands);
% find the previous point that has already been recorded. 
if ~isempty(handles.speckleCo)
    list = sort([handles.speckleCo(:,1);handles.noInit]);
    if handles.no > list(end)
        indx = find(handles.speckleCo(:,1)==list(end));
    elseif handles.no < list(1)
        indx = find(handles.speckleCo(:,1)==list(1));
    else
        indx = find(handles.speckleCo(:,1)==(handles.no));
        if isempty(indx)
            indx = find(handles.speckleCo(:,1)==(handles.no-flag*1));
            if isempty(indx)
                indx = find(handles.speckleCo(:,1)==(handles.no-flag*2));
            end
        end
    end
    %     indx = find(handles.speckleCo(:, 1) == (handles.no - 1)); % Find saved coordinate ????flag*
else
    indx = []; % No previous saved coordinate. 
end % indx can be improved - dont in one for loop!!
RADIUS = 30;
handles.neighbors.length = 0;
if (handles.no == handles.noInit)
    handles.currentSp = haSp;
    guidata(findobj('Name','manTrack'),handles); 
    return;
end   
if isempty(indx) % Previous point is the first speckle
    previous_point = handles.candsR;
    for i = 1 : length
        temp0 = (cands(i).Lmax - previous_point.Lmax).^2;
         if (temp0 < RADIUS^2)
            handles.neighbors.length = handles.neighbors.length + 1;
            handles.neighbors.points(handles.neighbors.length, 1:2) = cands(i).Lmax(1:2);
                handles.neighborPlot(end + 1, 1) = plot(cands(i).Lmax(2), cands(i).Lmax(1), 'g.');
                set(handles.neighborPlot(end, 1),'ButtonDownFcn','plotSpeckle');
        end
    end
else
    previous_point_coordinate = [handles.speckleCo(indx, 3) handles.speckleCo(indx, 2)];
    for i = 1 : length
        temp0 = (cands(i).Lmax - previous_point_coordinate).^2;
        if (temp0 < RADIUS^2)
           handles.neighbors.length = handles.neighbors.length + 1;
           handles.neighbors.points(handles.neighbors.length, 1:2) = cands(i).Lmax(1:2);
                handles.neighborPlot(end + 1, 1) = plot(cands(i).Lmax(2), cands(i).Lmax(1), 'g.');
                set(handles.neighborPlot(end, 1),'ButtonDownFcn','plotSpeckle');
        end
    end
end
handles.tempCands = cands;
handles.currentSp = haSp;
guidata(findobj('Name','manTrack'),handles);
