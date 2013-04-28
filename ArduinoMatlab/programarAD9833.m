%%
%  Codigo para programar frequencia do AD9833.
%  frequencia = 400Hz
%  MCLK = 50MHz
%% Variaveis globais
%
clear all; % limpa as variáveis
% rotina base
a = arduino('COM10'); % porta de comunicação do arduino
%ChannelTransmit = 0;
Done = 0;
% int FreqReg0[]= {b0,b1,b2,b3, b4,b5,b6,b7, b8,b9,b10,b11, b12,b13,b14,b15, b16,b17,b18,b19, b20,b21,b22,b23, b24,b25,b26,b27, b28,b29,b30,b31, b32,b33}; %400Hz

%FreqReg0= [0,0,1,0, 1,0,0,0, 0,0,0,0, 0,0,1,0, 1,0,0,0, 0,0,0,1, 0,0,0,0, 0,0,1,0]; %400Hz
FreqReg0= [0,1,0,1, 0,0,0,0, 1,1,0,0, 0,1,1,1, 0,1,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0 ]; %400Hz
ContReg = [0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0];
%ContReg = [0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0];
ResetReg =[0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0];
%ResetReg =[0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0];
%PhaseReg0 = [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
PhaseReg0 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1];
 
%%
%  int FSELECT = 8; %% FSELECT pino para o AD9833CRUZ.
%  int RESET = 9; % RESET pino para o AD9834CRUZ.
%  int SDATA = 10; %% SDATA pino para o AD9833CRUZ.
%  int SCLK = 11; %% SCLK pino para o AD9833CRUZ.
%  int FSYNC = 12; %% FSYNC pino para o AD9833CRUZ.
%%

% void setup() 
  for n = 2:5
      a.pinMode(n,'input'); % seta porta digital como entrada
  end
  for n = 8:12
       a.pinMode(n,'output'); % seta porta digital como saida
  end
  FSELECT = 8; %% FSELECT pino para o 74HC244
  SDATA = 10; % SDATA pino para o AD9834CRUZ.
  SCLK = 9; %% SCLK pino para o AD9833CRUZ.
  FSYNC = 11; %% FSYNC pino para o AD9833CRUZ.
  RESET = 12; %% RESET pino para o AD9833CRUZ.
  
  a.digitalWrite(FSELECT,0); % sets pin FSELECT, LOW
  a.digitalWrite(FSYNC,1); % sets pin FSYNC,HIGH
  %a.digitalWrite(RESET,1); % sets pin RESET, HIGH
  a.digitalWrite(SCLK,1); % sets pin SCLK, HIGH
%%  
%void loop() 

  ChannelTransmit = a.digitalRead(3); % reads pin #3
  disp(ChannelTransmit);
  if(ChannelTransmit == 0)
      Done = 0;
  end
  if(ChannelTransmit == 1 && Done == 0)
      Done = 1;
      a.digitalWrite(SCLK,1); % sets pin SCLK, HIGH
      a.digitalWrite(SCLK,0); % set pin SCLK, LOW
      disp(Done);
  end  
    for i = 1:16
    
      a.digitalWrite(SCLK,1);
      a.digitalWrite(SDATA,ContReg(i)); %set pin SDATA
      a.digitalWrite(SDATA,1); %set pin SDATA
      delay(0.01);
      a.digitalWrite(SCLK,0); %set pino SCLK, LOW
      delay(0.01);
      disp(i);
    end
  %%  
    %FSYNCsetup();
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,1);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
    
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,0);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
%%
    for i = 1:16
        a.digitalWrite(SCLK,1); % set pin SCLK, HIGH
        a.digitalWrite(SDATA,FreqReg0(i)); %set SDATA, envia Frequ LSB
        delay(0.01);
        a.digitalWrite(SCLK,0); % set pin SCLK, LOW
        delay(0.01);
        disp(i);
    end
  %%  
    %FSYNCsetup();
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,1);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
    
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,0);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
    %%
    for i = 17:32
        a.digitalWrite(SCLK,1); % set pin SCLK, HIGH
        a.digitalWrite(SDATA,FreqReg0(i)); %set SDATA, envia Frequ MSB
        delay(0.01);
        a.digitalWrite(SCLK,0); % set pi SCLK, LOW
        delay(0.01);
        disp(i);
    end
    
  %%  
    %FSYNCsetup();
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,1);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
    
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,0);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
    %%
    for i = 1:16
        a.digitalWrite(SCLK,1);  % set pin SCLK, LOW
        a.digitalWrite(SDATA,PhaseReg0(i));
        delay(0.01);
        a.digitalWrite(SCLK,0);
        delay(0.01);
        disp(i);
    end   
    %%
    %FSYNCsetup();
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,1);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
    
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,0);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
    %%
    for i = 1:16
        a.digitalWrite(SCLK,1);
        a.digitalWrite(SDATA,ResetReg(i));
        delay(0.01);
        a.digitalWrite(SCLK,0);
        delay(0.01);
        disp(i);
    end    
    a.digitalWrite(SCLK,1);
    a.digitalWrite(FSYNC,1);
    delay(0.01);
    a.digitalWrite(SCLK,0);
    delay(0.01);
    a.digitalWrite(SCLK,1);
 %   a.digitalWrite(RESET,0);
  