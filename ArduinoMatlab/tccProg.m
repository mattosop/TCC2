
%%
clear all; % limpa as variáveis
% rotina base
    tic; % permite incio de contagem de tempo
    a = arduino('COM10'); % porta de comunicação do arduino
    
    for n=2:13
        a.pinMode(n,'output'); % seta porta digital como output
    end
    for n=30:36
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
    toc;
  %  lcReal = zeros(30,15);
  %  lcImag = zeros(30,15);

%%
% rotina de programação do DDS
 %   flagProg = 1;
 %   if flagProg == 0
       
%        fprintf('\nContinua programacao!\n');
 %   else  
%% 
% este bloco permite a seleção do par de aplicação da corrente, de forma
% temporizada com tempo ajustável.

    fprintf('\nFonte de corrente!\n');
    a.digitalWrite(13,0); % sets pin #13 para low, Enable'0'
%%
% contador para fonte de corrente
for nc=0:15
        bit= bitget(uint8(nc), 4:-1:1);
% escreve palavra no mux da corrente
        a.digitalWrite(9,bit(1)); % sets 
        a.digitalWrite(8,bit(2)); % sets 
        a.digitalWrite(7,bit(3)); % sets 
        a.digitalWrite(6,bit(4)); % sets
%%
% escreve palavra no mux do comum do ina
        a.digitalWrite(12,0); % sets pin #12 low Enable'0'
        disp (nc);
% contador para comum do INA        
        for n1=(nc+1):(nc+15)
            bit= bitget(uint8(n1), 4:-1:1);
            a.digitalWrite(5,bit(1)); % sets 
            a.digitalWrite(4,bit(2)); % sets 
            a.digitalWrite(3,bit(3)); % sets 
            a.digitalWrite(2,bit(4)); % sets 
            disp(n1);
%%
% rotina leitura probe do ina
                %while tf ~= 1 % enquanto Tf é diferente de '1' executa esta função
            a.digitalWrite(11,0); % sets pin #11 low Enable'0'
            for n2=(n1+1):(n1+31) %% faz com que o probe do INA percorra os eletrodos apartir do próximo
                cont = cont+1; %contador para a matriz
               
                while t < 0.01
                      t = toc;
                end
                      tic;
                      t= 0;
                      if (n2) == (nc+16) % teste para não utilizar o comum da fonte de corrente
                           n2 = n2+1;
                      end
                bit= bitget(uint8(n2), 5:-1:1);
                a.digitalWrite(35,bit(1)); % sets pin #5 
                a.digitalWrite(34,bit(2)); % sets pin #4 
                a.digitalWrite(33,bit(3)); % sets pin #3 
                a.digitalWrite(32,bit(4)); % sets pin #2
                a.digitalWrite(31,bit(5)); % sets pin #3
                disp (n2);
%%
                while t<0.01
                      t = toc;
                      valReal=a.analogRead(0); % reads analog input pin # 0
                      lcReal(cont) = valReal;
                      valImag=a.analogRead(1); % reads analog input pin # 0
                      lcImag(cont) = valImag;
                 end
                
            end
            % cont = 0;
              %end
        end  
end
save ('c:\Users\Carlos\Documents\ArduinoMatlab\teste.dat', 'lcReal','lcImag','media','nc','n2');