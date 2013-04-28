function d = teste_funcao(a,b);
%
%    mvazia atribui valores para Matriz vazia
%    mvazia(a,b) retorna a, se a não é vazia
%    caso contrário retorna b
%
% 
%    Exemplo:
%            problema da variável vazia em declarações lógicas:
%seja a = [];
%então use mvazia para atribuir as seguintes declarações:
(a==1) é falsa,mas mvazia(a,1) é verdadeira
(a==0) é falsa,mas mvazia(a,0) é verdadeira
%}
if isempty(a)
    d = b;
else
    d = a;
end



