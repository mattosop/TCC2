function varargout = tester2(varargin)
% TESTER2 MATLAB code for tester2.fig
%      TESTER2, by itself, creates a new TESTER2 or raises the existing
%      singleton*.
%
%      H = TESTER2 returns the handle to a new TESTER2 or the handle to
%      the existing singleton*.
%
%      TESTER2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTER2.M with the given input arguments.
%
%      TESTER2('Property','Value',...) creates a new TESTER2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tester2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tester2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tester2

% Last Modified by GUIDE v2.5 09-Apr-2013 20:25:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tester2_OpeningFcn, ...
                   'gui_OutputFcn',  @tester2_OutputFcn, ...
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


% --- Executes just before tester2 is made visible.
function tester2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tester2 (see VARARGIN)

% Choose default command line output for tester2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global a;
global val;
a = arduino('COM9');
 for n=2:13     %seta portas como saida
        a.pinMode(n,'output'); % seta porta digital como output
 end
 for n=30:36
    a.pinMode(n,'output'); % seta porta digital como output
 end
 % necessário para evitar ruido e acionamento involuntário
 % comum do INA
 bit = [1 1 1 1];
 a.digitalWrite(13,bit(1)); % sets pin #13 high
 a.digitalWrite(12,bit(2)); % sets pin #12 high
 a.digitalWrite(11,bit(3)); % sets pin #11 high
 a.digitalWrite(10,bit(4)); % sets pin #10 high
 tf = 0;
 ti = 0;
 tic ;
    
% UIWAIT makes tester2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tester2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function inicio_Callback(hObject, eventdata, handles)
% hObject    handle to inicio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inicio as text
%        str2double(get(hObject,'String')) returns contents of inicio as a double
a.digitalWrite(13,0); % sets pin #12 low Enable'0'
   
for nc=1:16
   % while tf ~=1        %flag gravado
        bit= bitget(uint8(nc), 4:-1:1);
% escreve palavra no mux da corrente
        a.digitalWrite(9,bit(1)); % sets 
        a.digitalWrite(8,bit(2)); % sets 
        a.digitalWrite(7,bit(3)); % sets 
        a.digitalWrite(6,bit(4)); % sets
%        disp(bit);
% escreve palavra no mux do comum do ina
     %   while tf ~= 1
            a.digitalWrite(12,0); % sets pin #12 low Enable'0'
            for n1=1:16
                bit= bitget(uint8(n1), 4:-1:1);
                a.digitalWrite(5,bit(1)); % sets 
                a.digitalWrite(4,bit(2)); % sets 
                a.digitalWrite(3,bit(3)); % sets 
                a.digitalWrite(2,bit(4)); % sets 
    %           disp (n1);
    %           disp (bit);
              %%
              %rotina leitura probe do ina
               while tf ~= 1
                   a.digitalWrite(11,0); % sets pin #12 low Enable'0'
                   for n2=(n1+1):(n1+31)
                       if n2 == (2*n1)
                           n2 = n2+1;
                       end
                       bit= bitget(uint8(n2), 6:-1:1);
                       a.digitalWrite(35,bit(1)); % sets pin #5 
                       a.digitalWrite(34,bit(2)); % sets pin #4 
                       a.digitalWrite(33,bit(3)); % sets pin #3 
                       a.digitalWrite(32,bit(4)); % sets pin #2
                       a.digitalWrite(31,bit(5)); % sets pin #3
                       %val=a.analogRead(0); % reads analog input pin # 0
                       m = [val, nc, n2];
                       tic;
                       soma = 0;
                       cont = 0;
                       while t<0.1
                           t = toc;
                           val=a.analogRead(0); % reads analog input pin # 0
                           cont = cont+1;
                           soma = soma+val;
        %                  ta = tf- ti;
                       end
                       media = soma/cont;
                       save ('teste.txt',media,  m);
                       tf = 0;
                 %     a.digitalWrite(30,bit(6)); % sets pin #2 
                   end
                end
     end  
end          
        
       %%
   % rotina responsável pela seleção do terminal comum do INA, percorrendo
   % 16 eletrodos
   %%
% rotina responsável pela seleção dos terminais de leitura da tensão
% resultante. percorrendo todos os eletrodos com excessão para os eletrodos
% de aplicação e comum.
    val=a.analogRead(0); % reads analog input pin # 0
    if n2 > 0
      %rotina de leitura
       
       for n=0:31
           while tf<0.01
                tf = toc;
        %       ta = tf- ti;
            end
            tf = 0;
            tic;
            %Leitura
          % t = timer('TimerFcn',@mycallback, 'Period', 100000.0);
            disp (n);
            %disp (t);
       end
   end

%% 
%rotina de leitura

save dados.dat


    


%%
    end


% --- Executes during object creation, after setting all properties.
function inicio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inicio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function parada_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in parada.
function parada_Callback(hObject, eventdata, handles)
% hObject    handle to parada (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
