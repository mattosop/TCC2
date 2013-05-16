%%
clear all; % limpa as variáveis
% rotina base
   
    a = arduino('COM3'); % porta de comunicação do arduino
   
    for n=2:13
        a.pinMode(n,'output'); % seta porta digital como output
    end
    for n=30:36
        a.pinMode(n,'output'); % seta porta digital como output
    end
    for n=22:25
        a.pinMode(n,'output'); % seta porta digital como output
    end
    % necessário para evitar ruido e acionamento involuntário
    % comum do INA
    % este bloco garante que nenhum rele estará acionado.
    bit = [1 1 1 1];
    a.digitalWrite(13,bit(1)); % sets pin #13 high
    a.digitalWrite(12,bit(2)); % sets pin #12 high
    a.digitalWrite(11,bit(3)); % sets pin #11 high
    a.digitalWrite(10,bit(4)); % sets pin #10 high
    %% zera variáveis
    tf = 0;
    t = 0;
    ti = 0;
    val =0;
    %% zera variaveis de controle
    media = 0;
    soma = 0;
    cont = 0;
    lcReal = zeros(1,464);
    lcImag = zeros(1,464);


%% 
% este bloco permite a seleção do par de aplicação da corrente, de forma
% temporizada com tempo ajustável.

    fprintf('\nFonte de corrente!\n');
    a.digitalWrite(13,0); % sets pin #13 para low, Enable'0'
%%
%& contador para fonte de corrente
for FC=1:1:16
        t = 0;
        bit= bitget(uint8(FC), 4:-1:1);
% escreve palavra no mux da corrente
        a.digitalWrite(9,bit(1)); % sets 
        a.digitalWrite(8,bit(2)); % sets 
        a.digitalWrite(7,bit(3)); % sets 
        a.digitalWrite(6,bit(4)); % sets
       % fprintf('\nFonte de corrente: ');
       % disp (FC);
%% 
        %& escreve palavra no mux do comum do ina
        a.digitalWrite(12,0); % sets pin #12 low Enable'0' 
        INAc=FC+1 %Comum do INA é um eletrodo à frente do comum da fonte corrente (16 eletrodos)
            bit= bitget(uint8(INAc), 4:-1:1);
% escreve palavra no mux da corrente
            a.digitalWrite(9,bit(1)); % sets 
            a.digitalWrite(8,bit(2)); % sets 
            a.digitalWrite(7,bit(3)); % sets 
            a.digitalWrite(6,bit(4)); % sets
            t=0;
            tic; % permite incio de contagem de tempo
            while t < 1
            t = toc;
            end
           % fprintf('\nComum INA: ');
           % disp (INAc);
           
           %&  rotina leitura probe do ina
            a.digitalWrite(11,0); % sets pin #11 low Enable'0'
            for INAp=(INAc+1):(INAc+15) %% faz com que o probe do INA percorra os eletrodos apartir do próximo
                cont = cont+1; %contador para a matriz'
                if INAp == (FC+16) % teste para não utilizar o comum da fonte de corrente
                    INAp = INAp+1;
                end
                
                if INAp>32
                    INAp = INAp-32
                end
                
               % cont = cont+1; %contador para o vetor'
                   
                bit= bitget(uint8(INAp), 4:-1:1);
                a.digitalWrite(35,bit(1)); % sets pin #5 
                a.digitalWrite(34,bit(2)); % sets pin #4 
                a.digitalWrite(33,bit(3)); % sets pin #3 
                a.digitalWrite(32,bit(4)); % sets pin #2
               % fprintf('\nProbe INA: ');
               % disp (INAp);
  %% Armazena os valores de tensão em um vetor para Real e outro para Imagem            
                valReal=a.analogRead(0); % reads analog input pin # A0
                valImag=a.analogRead(1); % reads analog input pin # A1
  %% converte para tensão
                TensaoReal = valReal*5/1023;
                lcReal(cont) = TensaoReal;
                TensaoImag = valImag*5/1023;
                lcImag(cont) = TensaoImag;
%%Rotina para Delay
                 tic;
                t= 0;
                while t < 1
                      t = toc;
                end
                           
            end
            a.digitalWrite(11,1); % sets pin #11 low Enable'0'
            a.digitalWrite(10,0); % sets pin #11 low Enable'0'
            for n=(INAp+1):(INAp+14) %% faz com que o probe do INA percorra os eletrodos apartir do próximo
                cont = cont+1; % contador para o vetor"
                INAp1 = n;
                if INAp1>32
                    INAp1 = INAp1-32
                end
                                                              
                bit= bitget(uint8(INAp1), 4:-1:1);
                a.digitalWrite(25,bit(1)); % sets pin #25 
                a.digitalWrite(24,bit(2)); % sets pin #24 
                a.digitalWrite(23,bit(3)); % sets pin #23 
                a.digitalWrite(22,bit(4)); % sets pin #22
               % fprintf('\nProbe INAp1: ');
               % disp (INAp1);
%% Armazena os valores de tensão em um vetor para Real e outro para Imagem            
                valReal=a.analogRead(0); % reads analog input pin # A0
                valImag=a.analogRead(1); % reads analog input pin # A1
%% converte para tensão
                TensaoReal = valReal*5/1023;
                lcReal(cont) = TensaoReal;
                TensaoImag = valImag*5/1023;
                lcImag(cont) = TensaoImag;
%%Rotina para Delay
                tic;
                t= 0;
                while t < 1
                    t = toc;
                end
            end
            a.digitalWrite(10,1); % sets pin #11 low Enable'0'
            
  
        
end
%%Plot das Tensões Real e Imaginaria
title('Tensões Real e Imag');
xlabel('Leituras');
ylabel('Tensão');
plot (1:464,TensaoReal);
hold
hold all
plot (1:464,TensaoImag);
hleg1 = legend('TensaoReal','TensaoImag');
%save ('c:\Users\Carlos\Documents\ArduinoMatlab\teste.dat', 'lcReal','lcImag','media','nc','n2');