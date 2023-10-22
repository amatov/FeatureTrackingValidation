function varargout = manTrack(varargin)
% MANTRACK M-file for manTrack.fig
%      MANTRACK, by itself, creates a new MANTRACK or raises the existing
%      singleton*.
%
%      H = MANTRACK returns the handle to a new MANTRACK or the handle to
%      the existing singleton*.
%
%      MANTRACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANTRACK.M with the given input arguments.
%
%      MANTRACK('Property','Value',...) creates a new MANTRACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manTrack_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manTrack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manTrack

% Alexandre Matov v2.5 11-Mar-2004 16:06:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @manTrack_OpeningFcn, ...
    'gui_OutputFcn',  @manTrack_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before manTrack is made visible.
function manTrack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manTrack (see VARARGIN)

% Choose default command line output for manTrack
handles.output = hObject;
handles.currentSp = [];
handles.text = [];
handles.speckleCo = [];
handles.hPlot = [];
handles.textB = [];
handles.neighborPlot = [];
handles.repeat = [];
handles.frame = [];
handles.immin = [];
handles.immax = [];
handles.quiv = [];
handles.near = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manTrack wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = manTrack_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in ImageDisplay.
function nextImage_Callback(hObject, eventdata, handles)
% hObject    handle to ImageDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% add selecting at random one of the already tracked tracks (reapeat)
% with 30% prob, start at random from one of the speckles in the track
flaga = 0;
if ishandle(handles.quiv)
    delete(handles.quiv)   
%     disp('quiv deleted')
end
if ~isempty(handles.quiv)
    handles.quiv = [];
%     disp('quiv [] emptied')
end
% take RAND - if > 0.3 no, <0.3 - yes, repeat
if isunix == 1
    string = '/unc/manTrackWT2s/results/sp.mat';
else
    string = 'U:\manTrackWT2s\results\sp.mat';
end
if (rand(1)<2) & (exist(string)~=0)  
    currpath = pwd;
    if isunix == 1
        cd('/unc/manTrackWT2s/results');
    else
        cd('U:\manTrackWT2s\results');
    end 
    load sp   
    if length(find([sp.repea]))<2*length(sp)
        leSp = length(sp);
        repTr = floor(rand(1)*leSp);%have to add 1 but it will be added in the WHILE
        while flaga==0 
            if repTr<leSp
                repTr = repTr + 1; %try the next track
            else
                repTr = 1;%if end reached, loop it
            end  
            % if a track is repeated once (.repea is not empty) dont track it more
            if isempty(sp(repTr).repea)
                leTr = length(sp(repTr).frame);
                beginRep = floor(rand(1)*leTr)+1;
                sp(repTr).repea = [leSp+1 sp(repTr).frame(beginRep)];% whic track's repeated  and frame to begin with
                eval(strcat('save sp.mat sp;'));
                handles = guidata(findobj('Name','manTrack'));
                handles.repeat = [repTr sp(repTr).inifr]; %show which old track the new one repeats
                guidata(findobj('Name','manTrack'),handles);
                flaga = 1; %exit while
            end        
        end 
    end
    cd(currpath); 
end
if flaga == 1;
    startCands = sp(repTr).frame(beginRep) + 50; 
    indx = sp(repTr).index(beginRep);
else       
    % select one of the cands at random
    startCands = floor(rand(1)*40+51);   
end % if r
if isunix == 1
    load(['/unc/manTrackWT2s/speckles/cands0',num2str(startCands)])
else
%     load(['U:\manTrackWT2s\speckles\cands0',num2str(startCands)])
    load(['X:\AlexData\Torsten\111607_EB1andMTs\111607_#20\EB1\feats0',num2str(startCands)])
end
cands=cands(find([cands.status]==1));
handles.cands=cands;
% select the corresponding image
if isunix == 1
    dirNameIm = '/unc/manTrackWT2s/images';
else
    dirNameIm = 'U:\manTrackWT2s\images';
end
fileNameIm='crop_MetaSpindleWT2s0';
handles.indxFirst = 51;
[path,body,no,ext]=getFilenameBody([fileNameIm,num2str(startCands),'.tif']);
handles.body=body;
handles.listImages = getFileStackNames([dirNameIm,filesep,body,'0',num2str(handles.indxFirst),ext]);
handles.noInit=str2num(no)-handles.indxFirst+1;
handles.no=str2num(no)-handles.indxFirst+1;
handles.image=double(imread(char(handles.listImages(handles.no))));
handles.immin = min(handles.image(:));
handles.immax = max(handles.image(:));
handles.image = Gauss2D(handles.image,1);
% select one of the speckles in that cands at random
if flaga == 0
    leCa=length(handles.cands);
    indx=1+floor(rand(1)*leCa);
end
handles.speIndx=indx;
handles.candsR=handles.cands(indx);%initial speckle

% figures
fh=findall(0,'Name','Spindle');
if ishandle(handles.hPlot)
    delete(handles.hPlot);
    handles.hPlot = [];
end

if isempty(fh)
    figure('Name','Spindle');
    % Create menu with additional tools
    hMenu=uimenu('Label','Change Image');
    uimenu(hMenu,'Label','Next Image','Callback','changeImage(2)','Accelerator','X');
    uimenu(hMenu,'Label','Previous Image','Callback','changeImage(1)','Accelerator','Z','Separator','On');  
    imgH=imshow(handles.image,[handles.immin handles.immax]);
    handles.title=title(['Frame ',num2str(handles.no)]);
    hold on
    set(imgH,'ButtonDownFcn','plotSpeckle');
else
    figure(fh)
    handles.speckleCo = [];
    handles.no=handles.noInit;
    handles.image=Gauss2D(double(imread(char(handles.listImages(handles.no)))),1);
    imgH=imshow(handles.image,[handles.immin handles.immax]);
    set(imgH,'ButtonDownFcn','plotSpeckle');
    guidata(findobj('Name','manTrack'),handles);
    set(findobj('Type','image'),'CData',handles.image);
    refresh(fh);
    handles.title=title(['Initial Frame ',num2str(handles.no)]);
end
if ishandle(handles.textB)
    delete(handles.textB);
    handles.textB = [];
end
if ishandle(handles.text)
    delete(handles.text);
end
if ishandle(handles.currentSp)
    delete(handles.currentSp);
end
haSp=plot(handles.candsR.Lmax(2),handles.candsR.Lmax(1),'r*');
hText=text(handles.candsR.Lmax(2)-6,handles.candsR.Lmax(1)-6,...
    [num2str(handles.noInit)],'Color','r');
set(hText,'ButtonDownFcn','plotSpeckle');
handles.text=hText;
handles.currentSp=haSp;
set(handles.nextImage,'Enable','off');
guidata(findobj('Name','manTrack'),handles);
set(hObject,'String','Next Speckle');
% --- Executes on button press in saveTraj.
function saveTraj_Callback(hObject, eventdata, handles)
% hObject    handle to saveTraj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=guidata(findobj('Name','manTrack'));
if ishandle(handles.neighborPlot)
    delete(handles.neighborPlot);  
end
if ~isempty(handles.neighborPlot)
    handles.neighborPlot = [];
end

startFr = [handles.noInit handles.candsR.Lmax(2) handles.candsR.Lmax(1)];
handles.speckleCo=[handles.speckleCo;startFr];
handles.speckleCo=sortrows(handles.speckleCo);
if isunix == 1
    usrnm = getenv('USER');
else
    usrnm = getenv('username');
end
currpath = pwd;
if isunix == 1
    cd('/unc/manTrackWT2s/results');
else
    cd('U:\manTrackWT2s\results');
end
if exist('sp.mat')~=0
    load sp
    indx = length(sp) + 1;
else
    indx = 1;
end

handles.frame(handles.noInit) = handles.noInit; % initial frame
handles.speckleIndx(handles.noInit) = handles.speIndx; % speckle in initial frame
le = length(find(handles.frame));

sp(indx).index = handles.speckleIndx(end-le+1:end);
sp(indx).frame = handles.frame(end-le+1:end); % +50 to get the correct CANDS
sp(indx).inifr = handles.noInit;
sp(indx).usrnm = usrnm;
sp(indx).daymy = date;
sp(indx).repea = handles.repeat; % [number of track, init frame]

handles.frame = [];
handles.speckleIndx = [];
handles.repeat = [];
delete(handles.near);
handles.near = [];

eval(strcat('save sp.mat sp;')); % Save speckle info
% read one by one all the coords of the track from cands and quiver
if isunix == 1
    cd('/unc/manTrackWT2s/speckles');
else
    cd('U:\manTrackWT2s\speckles');
end
if length(sp(indx).frame)>1
    for i = 1:length(sp(indx).frame)-1
        fh = findall(0, 'Name', 'Spindle'); 
        figure(fh)
        hold on
        if isunix == 1
            load(['/unc/manTrackWT2s/speckles/cands0',num2str(sp(indx).frame(i)+50)])
        else
            load(['U:\manTrackWT2s\speckles\cands0',num2str(sp(indx).frame(i)+50)])
        end
        cands=cands(find([cands.status]==1));
        x1=cands(sp(indx).index(i)).Lmax(2);
        y1=cands(sp(indx).index(i)).Lmax(1);
        if isunix == 1
            load(['/unc/manTrackWT2s/speckles/cands0',num2str(sp(indx).frame(i+1)+50)])
        else
            load(['U:\manTrackWT2s\speckles\cands0',num2str(sp(indx).frame(i+1)+50)])
        end
        cands=cands(find([cands.status]==1));
        x2=cands(sp(indx).index(i+1)).Lmax(2);
        y2=cands(sp(indx).index(i+1)).Lmax(1);
handles.quiv (i,:) = quiver(x1,y1,x2-x1,y2-y1,0);
    end 
end
guidata(findobj('Name','manTrack'),handles);
cd(currpath);
uiwait(msgbox('Trajectory saved to disk','FYI','modal'));
set(handles.nextImage,'Enable','on');
