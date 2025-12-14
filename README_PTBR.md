[🇺🇸 View in English](./README.md)

# 🎟️ Smart Contract de Rifa (Sui Move)

Este projeto implementa uma **rifa simples on-chain** utilizando a linguagem **Move na blockchain Sui**.  
Usuários podem comprar tickets, e o criador da rifa pode encerrá-la, sortear um vencedor e distribuir automaticamente os fundos arrecadados.

---

## 📌 Visão Geral

- Cada rifa é representada por um objeto `Raffle`
- Usuários compram tickets pagando SUI
- Os tickets são armazenados como índices em uma tabela
- Ao encerrar a rifa, um vencedor é selecionado aleatoriamente
- O valor total arrecadado é dividido entre:
  - a plataforma
  - o criador da rifa
  - o vencedor

Este projeto é **exclusivamente educacional**.

---

## 🧱 Arquitetura

### Objeto Raffle
A struct `Raffle` armazena:
- Metadados da rifa (título, criador)
- Preço do ticket
- Número de tickets vendidos
- Uma tabela que mapeia índices de tickets para endereços dos compradores
- O valor total arrecadado armazenado como `Balance<SUI>`
- O índice do ticket vencedor (após o encerramento)

### Tickets
Os tickets são representados apenas por um **índice numérico e o endereço do comprador**.  
Não são criados objetos ou NFTs de ticket para manter a implementação simples e eficiente.

---

## 🔁 Fluxo da Rifa

1. O criador cria a rifa
2. Usuários compram tickets enviando SUI
3. O valor arrecadado é adicionado ao pot da rifa
4. O criador encerra a rifa
5. Um índice de ticket vencedor é sorteado
6. O pot é distribuído entre criador e vencedor

---

## 🔐 Segurança e Limitações

- O método de geração de números aleatórios **não é seguro para produção**
- A rifa deve ser encerrada manualmente pelo criador
- Não há mecanismo de reembolso
- Projeto desenvolvido apenas para fins de aprendizado

---

## 🚀 Possíveis Melhorias

- Aleatoriedade segura (commit–reveal, VRF ou beacons)
- Uso de AdminCap para governança
- Tickets como NFTs transferíveis
- Encerramento automático por tempo ou epoch

---

## 📚 Aviso

Este projeto foi desenvolvido como parte de um **sui bootcamp** e **não está pronto para produção**.  
Seu objetivo é demonstrar conceitos básicos da linguagem Move e Sui.
