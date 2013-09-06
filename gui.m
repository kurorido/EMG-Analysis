function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 27-Jul-2013 21:17:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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
% End initialization code - DO NOT EDIT

function disableAllButton(handles)

set(handles.buttonMultiCyclePlot, 'Enable', 'off');
set(handles.cycleReduceButton, 'Enable', 'off');
set(handles.medianCalcButton, 'Enable', 'off');
set(handles.exportButton, 'Enable', 'off');

function enableAllButton(handles)

set(handles.medianCalcButton, 'Enable', 'on');

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

handles = config(handles);

set(handles.popupMuscleList, 'String', handles.muscle_names);
handles.selectedMuscle = 1;

set(handles.mvnCycleText, 'String', strcat('MVN Cycle: ', int2str(length(handles.time_byMVN(:,1)) - 1)));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in buttonMultiCyclePlot.
function buttonMultiCyclePlot_Callback(hObject, eventdata, handles)
% ============= Old Version ====================
% This version only support sequential cycle plot
% startCycle = str2double(get(handles.startCycleEditText,'String'));
% endCycle = str2double(get(handles.endCycleEditText,'String'));
% runMultiCycleSequential(handles, startCycle, endCycle);
% =======================================

if(strcmp(handles.cycleStringCache, get(handles.editTextSplitCycle,'String')) ~= 1)
	choice = questdlg('Cycle text may be changed, continue plot?','Yes');
else
    choice = 'Yes';
end

if(strcmp(choice, 'Yes') == 1)
	result = handles.result;
	methods = fieldnames(result); % indicator field (ex: EA, LE, MA, RMS, RMS_s)

	muscle = cellstr(handles.muscle_list{handles.selectedMuscle});
	cycles = getSplitCycles(get(handles.editTextSplitCycle,'String'));

	cc=hsv(length(cycles)*10);
	j = 1; delta = 10;
	list = get(handles.goalList, 'String');
	methods_index = get(handles.goalList, 'Value'); % all : 1, EA: 2, LE: 3...
	name = strcat(muscle{1}, '-Multi Cycle(', list{methods_index}, ')');
	fig = figure('name', name);

	if (methods_index ~= 1) % plot specific method
		hold on;
		for i = 1 : length(cycles);
			plot(result.(methods{methods_index - 1}).cycle(cycles{i}).data(:,3), result.(methods{methods_index - 1}).cycle(cycles{i}).data(:,2), 'color', cc(j*delta,:))
			legendString{j} = sprintf('Cycle %d', cycles{i});
			j = j + 1;
		end
		legend(legendString); grid on;
		hold off
	else
		for k = 1 : length(methods) % go through methods
			j = 1; % reset color pointer
			subplot(3,2,k)
			hold on
			title(strcat(muscle{1}, '-', methods{k}))
			for i = 1 : length(cycles); % go through cycle
				plot(result.(methods{k}).cycle(cycles{i}).data(:,3), result.(methods{k}).cycle(cycles{i}).data(:,2), 'color', cc(j*delta,:))
				if(k == 1) legendString{j} = sprintf('Cycle %d', cycles{i}); end % only set lengend at first time
				j = j + 1;
			end
			grid on;
			hold off
		end
		legend(legendString);
	end
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in buttonRun.
function buttonRun_Callback(hObject, eventdata, handles)

set(handles.hintStatus,'String','Running...');
drawnow;

handles.result = runTrial(handles);

set(handles.hintStatus,'String','Not Running');

% enable button
enableAllButton(handles);

% Update handles values
guidata(hObject, handles);


% --- Executes on button press in cycleReduceButton.
function cycleReduceButton_Callback(hObject, eventdata, handles)

% Old Version
% useCycleReduce(handles);

if(strcmp(handles.cycleStringCache, get(handles.editTextSplitCycle,'String')) ~= 1)
	choice = questdlg('Cycle text may be changed, continue plot?','Yes');
else
    choice = 'Yes';
end

if(strcmp(choice, 'Yes') == 1)
	% This funtion will plot the median cycle data with specific method only.
	methods_index = get(handles.goalList, 'Value'); % all : 1, EA: 2, LE: 3...
	if(methods_index ~= 1)

		muscle = cellstr(handles.muscle_list{handles.selectedMuscle});
		list = get(handles.goalList, 'String');
		name = strcat(muscle{1}, '-Median Cycle(', list{get(handles.goalList, 'Value')}, ')');
		figure('name', name);
		
		indicators = fieldnames(handles.result); % indicator field (ex: RF, LE, MA, RMS, RMS_s)
		indicator = (indicators{get(handles.goalList, 'Value') - 1});
		goal = handles.reducedData.(indicator);

		plot(goal.medianCycle.data(:,1), goal.medianCycle.data(:,2) ,'-b')
		hold on
		errorbar(goal.meanCycle.data(:,1), goal.meanCycle.data(:,2), goal.stdCycle.data(:,2),'xr')
		hold on
		errorbar(goal.meanCycle.data(:,1), goal.meanCycle.data(:,2), goal.stdCycle.data(:,2)/sqrt(7-3),'--g')
		hold off
		legend('median Cycle', 'mean Cycle with SD', 'mean Cycle with SE')
		xlim([0 100]);
		grid on;
	else
		indicators = fieldnames(handles.result); % indicator field (ex: RF, LE, MA, RMS, RMS_s)
		
		for i = 1 : length(indicators)
			indicator = (indicators{i});
			
			muscle = cellstr(handles.muscle_list{handles.selectedMuscle});
			
			name = strcat(muscle{1}, '-Median Cycle(', indicator, ')');
			fig = figure('name', name);
			
			goal = handles.reducedData.(indicator);

			plot(goal.medianCycle.data(:,1), goal.medianCycle.data(:,2) ,'-b')
			hold on
			errorbar(goal.meanCycle.data(:,1), goal.meanCycle.data(:,2), goal.stdCycle.data(:,2),'xr')
			hold on
			errorbar(goal.meanCycle.data(:,1), goal.meanCycle.data(:,2), goal.stdCycle.data(:,2)/sqrt(7-3),'--g')
			hold off
			legend('median Cycle', 'mean Cycle with SD', 'mean Cycle with SE')
			xlim([0 100]);
			grid on;
			
			saveas(fig, strcat(handles.output_folder, handles.filePrefix, handles.fileSuffix, '-', muscle{1}, '-Median Cycle(', indicator, ')'), 'jpg');
		end
	end
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in medianCalcButton.
function medianCalcButton_Callback(hObject, eventdata, handles)

handles.cycleStringCache = get(handles.editTextSplitCycle,'String');

set(handles.hintStatus,'String','Running...');
drawnow;
% Calculate median value & save into reducedData structure
handles.reducedData = calMedianCycle(handles.result, getSplitCycles(get(handles.editTextSplitCycle,'String')));

set(handles.hintStatus,'String','Not Running');
% Enable the plot button
set(handles.buttonMultiCyclePlot, 'Enable', 'on');
set(handles.cycleReduceButton, 'Enable', 'on');
set(handles.exportButton, 'Enable', 'on');

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in exportButton.
function exportButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

exportToExcel(handles);

%% --- Executes on button press in plotAllButton.
%function plotAllButton_Callback(hObject, eventdata, handles)
%% hObject    handle to plotAllButton (see GCBO)
%% eventdata  reserved - to be defined in a future version of MATLAB
%% handles    structure with handles and user data (see GUIDATA)
%
%result = handles.result;
%methods = fieldnames(result); % indicator field (ex: EA, LE, MA, RMS, RMS_s)
%muscle = cellstr(handles.muscle_list{handles.selectedMuscle});
%
%cc=hsv(128);
%j = 1; delta = 5;
%list = get(handles.goalList, 'String');
%name = strcat(muscle{1}, '-All Cycle(', list{get(handles.goalList, 'Value')}, ')');
%figure('name', name);
%hold on;
%for i = 1 : length(result.EA.cycle)
%    switch get(handles.goalList, 'Value')
%        case 1
%            plot(result.EA.cycle(i).data(:,1), result.EA.cycle(i).data(:,2), 'color', cc(j*delta,:))
%        case 2
%            plot(result.LE.cycle(i).data(:,1), result.LE.cycle(i).data(:,2), 'color', cc(j*delta,:))
%        case 3
%            plot(result.MA.cycle(i).data(:,1), result.MA.cycle(i).data(:,2), 'color', cc(j*delta,:))
%        case 4
%           plot(result.RMS.cycle(i).data(:,1), result.RMS.cycle(i).data(:,2), 'color', cc(j*delta,:))
%        case 5
%            plot(result.RMS_s.cycle(i).data(:,1), result.RMS_s.cycle(i).data(:,2), 'color', cc(j*delta,:))
%    end
%    legendString{j} = sprintf('Cycle %d', i);
%    j = j + 1;
%end
%hold off;
%legend(legendString); grid on;
%
% Update handles structure
%guidata(hObject, handles);

% --- Executes on selection change in popupMuscleList.
function popupMuscleList_Callback(hObject, eventdata, handles)
% hObject    handle to popupMuscleList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupMuscleList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupMuscleList
val = get(hObject,'Value');

if (val ~= handles.selectedMuscle)
   % disable button
    disableAllButton(handles);
end
handles.selectedMuscle = val;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupMuscleList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupMuscleList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

guidata(hObject, handles);

function editTextSplitCycle_Callback(hObject, eventdata, handles)
% hObject    handle to editTextSplitCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextSplitCycle as text
%        str2double(get(hObject,'String')) returns contents of editTextSplitCycle as a double

% --- Executes during object creation, after setting all properties.
function editTextSplitCycle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextSplitCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in goalList.
function goalList_Callback(hObject, eventdata, handles)
% hObject    handle to goalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns goalList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from goalList
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function goalList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% Update handles structure
guidata(hObject, handles);
