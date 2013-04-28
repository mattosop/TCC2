function  distancia  =  calcula_distancia( x,  y)
%  uso - distancia = calcula_distancia(x,  y)
%  calcula a distancia euclidiana entre os pontos x e y (vetores do Rn)
diferenca = x - y;
distancia = sqrt(  diferenca*transpose(diferenca) );