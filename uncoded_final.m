% ------------- Algoritmo do codigo (7,7) -------------
% Arquivo (nome): nao_codificado
% Canal BSC 
%--------------- variaveis iniciais -------------------
clc, clear all;
k=7; % numero de bits de informacao
n=7; % palavra-codigo (por bloco) 
p=0:0.01:0.5; %vetor de probabilidade para o canal BSC
erro_palavra_medio=zeros(size(p));%vetor dos erros das palavra-codigo
erro_palavra_uncoded=zeros(size(p));%vetor dos erros nao codificado

% ----------- Matriz geradora G =[I P] ----------------
G=eye(7); 
num_bits=5e3; %quantidade de bits
bits_iniciais=zeros(2^k,k); %vetor de bits

% --------------- Valores binarios 0-127 ----------------
ii=1;
for t=1:size(bits_iniciais,1); 
    %conversao decimal-binario
    bits_iniciais(ii,:)=wrev(de2bi(t-1,k)); 
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
    
    % ---- adicionado ruido aos bits transmitidas
    palavras_recebidas=mod(bits_palavras+ruido,2);
    
    % ------------- decodificacao ---------------
    bits_decod=palavras_recebidas(:,1:k); %somente as k colunas
    erro_bits_inf=(bits_info~=bits_decod); %comparacao
    erro_palavra=sum(erro_bits_inf,2); %erro das palavra-codigo
    erro_palavra_medio(jj)=mean(erro_palavra~=0); %erro medio (WER)
end
erro_palavra_teorico=1-((1-p).^7);
plot(p,erro_palavra_medio,'r--o'); hold on
plot(p,erro_palavra_teorico,'b'); grid on
xlabel('p'); ylabel('Probabilidade de erro da palavra-codigo')
title(['WER para codigo (7,7): L=' num2str(num_bits)])
legend('WER simulada','WER teorica')
