function d = teste_funcao(a,b);
%
%    mvazia atribui valores para Matriz vazia
%    mvazia(a,b) retorna a, se a n�o � vazia
%    caso contr�rio retorna b
%
% 
%    Exemplo:
%            problema da vari�vel vazia em declara��es l�gicas:
%seja a = [];
%ent�o use mvazia para atribuir as seguintes declara��es:
(a==1) � falsa,mas mvazia(a,1) � verdadeira
(a==0) � falsa,mas mvazia(a,0) � verdadeira
%}
if isempty(a)
    d = b;
else
    d = a;
end



