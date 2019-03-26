% ------- Algoritmo do codigo de Hamming (7,4) --------
% Arquivo (nome): hamming_74
% Canal BSC 
%--------------- variaveis iniciais -------------------
clc, clear all;
k=4; % numero de bits de informacao
n=7; % palavra-codigo (por bloco) 
p=0:0.01:0.5; %vetor de probabilidade para o canal BSC
erro_palavra_medio=zeros(size(p));%vetor dos erros das palavra-codigo
erro_palavra_uncoded=zeros(size(p));%vetor dos erros nao codificado

% ----------- Matriz geradora G =[I P] ----------------
G=[1 0 0 0 1 1 0; ...
    0 1 0 0 1 0 1; ...
    0 0 1 0 0 1 1; ...
    0 0 0 1 1 1 1];
num_bits=5e3; %quantidade de bits
bits_iniciais=zeros(2^k,k); %vetor de bits
% --------------- Valores binarios 0-15 ----------------
ii=1;
for t=1:16; 
    %conversao decimal-binario
    bits_iniciais(ii,:)=wrev(de2bi(t-1,4)); 
    ii=1+ii;
end
% -------- Gerando palavras-codigo iniciais)----------
palavras_codigo=mod(bits_iniciais*G,2); %valores binarios: 0 e 1
% ---------- Gerando aleatoriamente os bits ----------
bits_info=randi([0 1],num_bits,k);
% ------- Novas palavras-codigo para transmissao -----
bits_palavras = mod(bits_info*G,2);

for jj=1:numel(p)   %contador para probabilidade    
    % simulando a geracao de ruido do canal
    ruido=round(rand(num_bits,n)-0.5+p(jj));
    % outro modo ruido=(rand(num,n)<=p(jj));
 
    % ---- bits que nao serao codificados -----
    bits_uncoded=bits_info + ruido(:,1:k);
 
    % ---- adicionado ruido aos bits transmitidas
    palavras_recebidas=mod(bits_palavras+ruido,2);
    
    % ----- decisao (distancia de Hamming) ------
    for aux=1:num_bits
        palavras_recebidas(aux,:)=distancia(palavras_recebidas(aux,:),palavras_codigo);
    end
    
    % ------------- decodificacao ---------------
    bits_decod=palavras_recebidas(:,1:k); %somente as k colunas
    erro_bits_inf=(bits_info~=bits_decod); %comparacao
    erro_palavra=sum(erro_bits_inf,2); %erro das palavra-codigo
    erro_palavra_medio(jj)=mean(erro_palavra~=0); %erro medio (WER)
   
    % ------------ nao-decodificado -------------
    erro_uncoded=(bits_uncoded~=bits_info);
    erro_palavra_uncoded(jj)=mean(sum(erro_uncoded,2)~=0);
end
erro_teorico=1-((1-p).^7)-(7*((1-p).^6).*p); %correcao de 0 ou 1 erro
plot(p,erro_palavra_medio,'r--o'); hold on
plot(p,erro_teorico,'b'); grid on
plot(p,erro_palavra_uncoded,'k-.'); hold off
xlabel('p'); ylabel('Probabilidade de erro da palavra-codigo')
title(['WER para codigo de repeticao (7,1): L=' num2str(num_bits)])
legend('WER simulada','WER teorica','Nao-codificado')
