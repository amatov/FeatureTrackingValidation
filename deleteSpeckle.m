function deleteSpeckle

% allows to review a trajectory and delete a manually selected speckle
% within it
%
% SYNOPSIS deleteSpeckle
%
% Alexandre Matov, 11-Mar-2004

% delete the speckle (cands) index from the trajectory 
delSpeck=questdlg('Would you like to delete this entry?','Delete entry','Yes','No','Yes');
switch delSpeck
    case 'Yes'
        ha = gcbo;      
        handles=guidata(findobj('Name','manTrack'));        
        indxD = find(handles.hPlot == ha);
        delete(handles.hPlot(indxD));
        handles.hPlot(indxD) = [];
        delete(handles.textB(indxD));
        handles.textB(indxD) = [];
        delete(handles.near(indxD));
        handles.near(indxD)=[];
        handles.speckleCo(indxD,:) = [];      
        guidata(findobj('Name','manTrack'),handles);      
    case 'No'
        return;
end % switch