% Arquivo(nome):distancia
function palavra_res = distancia(pal_recebida,pal_codigo)
    % compara cada palavra recebida com todas as palavras pre-definidas
    dist = sum(mod(pal_codigo+repmat(pal_recebida,[size(pal_codigo,1),1]),2),2);
    id = find(dist == min(dist)); %seleciona a posicao das palavras com menor distancia
    Q = length(id); %caso mais de uma palavra tenha a mesma distancia (menor)
    new_id = id(randi([1 Q],1,1)); %seleciona aleatoriamente qual a posicao menor
    palavra_res = pal_codigo(new_id,:); %retorna a palavra com menor distancia 
end