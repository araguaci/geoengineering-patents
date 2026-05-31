---
layout: post
title: "MIT RF-Pose · Estimativa de Pose Humana em Tempo Real via Wi-Fi"
date: 2018-06-18 00:00:00 -0300
description: >-
  Análise do sistema RF-Pose do MIT CSAIL (CVPR 2018): estimativa de esqueleto
  humano completo em tempo real a partir de reflexões de radiofrequência na banda
  Wi-Fi — inclusive através de paredes — e sua convergência com a linha de
  desenvolvimento documentada nas patentes de vigilância eletromagnética deste
  repositório.
categories: [análise, vigilância-eletromagnética]
tags: [MIT, CSAIL, RF-Pose, Wi-Fi-sensing, pose-estimation, radiofrequência, vigilância, privacidade-física, dual-use, Dina-Katabi, John-Kiriakou]
image:
  path: /assets/img/posts/vigilancia-eletromagnetica-cover.webp
  alt: "Diagrama conceitual da convergência entre geoengenharia e vigilância eletromagnética"
---

## Identificação

| Campo | Dados |
|---|---|
| **Projeto** | RF-Pose |
| **Instituição** | MIT CSAIL — grupo NETMIT (Dina Katabi) |
| **Publicação** | CVPR 2018 (18–22 de junho de 2018) |
| **Título original** | *Through-Wall Human Pose Estimation Using Radio Signals* |
| **Autores** | Mingmin Zhao, Tianhong Li, Mohammad Abu Alsheikh, Yonglong Tian, Hang Zhao, Antonio Torralba, Dina Katabi |
| **Referências externas** | [Página do projeto](https://www.rf-pose.csail.mit.edu/) · [PDF CVPR 2018](https://openaccess.thecvf.com/content_cvpr_2018/papers/Zhao_Through-Wall_Human_Pose_CVPR_2018_paper.pdf) |

---

## O que o RF-Pose demonstra

Em junho de 2018, pesquisadores do MIT CSAIL apresentaram publicamente um sistema capaz de **reconstruir o esqueleto completo de uma pessoa** — cabeça, ombros, cotovelos, punhos, quadris, joelhos e tornozelos — a partir exclusivamente de **reflexões de radiofrequência**, sem câmera, sem microfone e sem qualquer dispositivo vestido pelo alvo.

O salto em relação ao *Wi-Fi sensing* anterior não foi incremental. Até 2013, o mesmo grupo já havia demonstrado detecção de movimento através de paredes (Wi-Vi). Em 2014, rastreamento tridimensional (WiTrack). O RF-Pose foi o momento em que a inferência passou de **"alguém se moveu"** para **"esta pessoa está sentada, de pé, com os braços levantados"** — uma reconstrução postural em tempo real comparável à visão computacional, mas operando no espectro eletromagnético.

---

## Como funciona — a física por trás

O sistema utiliza um par de antenas de radiofrequência — emissor e receptor — operando em **modulação FMCW** (*Frequency-Modulated Continuous Wave*) na faixa de **5,4 a 7,2 GHz**, adjacente à banda do Wi-Fi convencional. Não se trata de interceptar pacotes de rede doméstica: trata-se de **radar passivo/ativo de interior** usando o mesmo espectro físico que um roteador Wi-Fi ocupa.

O mecanismo segue três etapas:

1. **Emissão e reflexão** — O transmissor envia ondas de radiofrequência que atravessam paredes de gesso e concreto leve e se refletem nos corpos humanos presentes no ambiente. Cada articulação modifica a fase e a amplitude do sinal de retorno de forma distinta.

2. **Mapa de atividade RF** — O receptor captura essas reflexões e as converte em mapas bidimensionais de atividade eletromagnética — *heatmaps* de RF — que codificam a distribuição espacial do corpo no tempo.

3. **Rede neural convolucional** — Uma FCN (*Fully Convolutional Network*) treinada com dados sincronizados de câmera óptica + RF aprende a mapear esses *heatmaps* diretamente para **14 pontos-chave do esqueleto humano**. Após o treinamento, a câmera deixa de ser necessária.

```
Emissor RF (5,4–7,2 GHz)
        │
        ▼
   Parede (atravessa)
        │
        ▼
   Corpo humano (reflete)
        │
        ▼
   Receptor RF → Heatmap → Rede neural → Esqueleto 2D (14 keypoints)
```

A rede é treinada em condições de linha de visão e **generaliza para cenários através de paredes** sem retreinamento específico — propriedade que os autores demonstraram empiricamente em ambientes domésticos reais.

---

## Capacidades documentadas na publicação

| Capacidade | Resultado reportado |
|---|---|
| Estimativa de pose (linha de visão) | Precisão comparável a sistemas de visão computacional |
| Estimativa de pose (através de parede) | Esqueleto reconstruído com fidelidade suficiente para inferir postura e gestos |
| Identificação de indivíduos | Distinguível entre ~100 pessoas conhecidas, inclusive através de paredes |
| Tempo real | Processamento contínuo, sem dispositivo no corpo do alvo |
| Multi-pessoa | Rastreamento simultâneo de múltiplos corpos no mesmo ambiente |

Nenhum desses resultados exige cooperação do alvo. Nenhum requer instalação de hardware na vítima. O equipamento necessário — antenas de RF e processamento — cabe numa mesa de laboratório ou, em versão miniaturizada, num compartimento do tamanho de um roteador.

---

## Onde entra na linha de desenvolvimento deste repositório

O RF-Pose não surgiu isolado. Ele ocupa o terceiro degrau de uma escalada documentada tanto em literatura acadêmica quanto em registros de patentes:

```
1998  US5800481        ─ Influência biofísica por emissão eletromagnética
2007  US20070215946     ─ Engenharia de reflexão de RF em meios físicos
2010  US7645326         ─ Mapeamento ambiental por radiofrequência (RFID)
2013  MIT Wi-Vi         ─ Detecção de movimento através de paredes por Wi-Fi
2013  US20130015260     ─ Radar/microondas como armamento e sensoriamento
2015  US20150077737     ─ Monitoramento ambiental contínuo
2018  MIT RF-Pose       ─ Estimativa de pose humana completa via RF
          │
          ▼
2025  John Kiriakou     ─ Capacidade operacional declarada por ex-oficial CIA
```

A física descrita na [US20070215946](/posts/us20070215946-plasma-ionizado-comunicacoes-rf/) — reflexão controlada de sinais de radiofrequência em meios físicos — é o mesmo princípio operacional do RF-Pose, com plasma ionizado substituído por corpo humano e atmosfera substituída por sala de estar.

A [US7645326](/posts/us7645326-rfid-manipulacao-ambiental-iot/) documentava em 2010 que sinais de radiofrequência distribuídos num ambiente permitiam **inferir presença, posição e movimento** de ocupantes. O RF-Pose é a materialização acadêmica pública dessa inferência — agora com resolução postural completa.

A [US20130015260](/posts/us20130015260-microwave-radar-armamento/) formalizava o princípio radar — emitir, aguardar retorno, analisar reflexão — para mapeamento de espaços. O RF-Pose aplica esse princípio na banda de microondas/Wi-Fi, num cômodo de 20 m².

---

## Conexão com o que John Kiriakou descreveu

Em maio de 2025, o ex-oficial da CIA **John Kiriakou** afirmou que agências de inteligência já possuem capacidade operacional de:

> Utilizar sinais de rádio do Wi-Fi para detectar movimentos ou mapear parcialmente ambientes internos através de paredes.

O RF-Pose, publicado sete anos antes dessa declaração, demonstra publicamente uma capacidade **mais avançada** do que a descrita por Kiriakou: não apenas movimento ou mapeamento parcial, mas **reconstrução do esqueleto completo** — postura, gestos, identidade individual — através de paredes, em tempo real, sem dispositivo no alvo.

A diferença entre o que o MIT publicou em 2018 e o que uma agência de inteligência pode operar em 2025 não é de princípio físico. É de **maturidade de implementação**, **acesso a infraestrutura de emissores já instalada** (roteadores, smart TVs, assistentes de voz) e **ausência de revisão por pares ou divulgação pública**.

A análise cruzada completa das patentes convergentes está em [Da Geoengenharia à Vigilância](/posts/vigilancia-eletromagnetica-patentes-cia-kiriakou/).

---

## Implicações para privacidade física

O RF-Pose tornou visível — literalmente, com vídeos de demonstração publicados — uma capacidade que antes existia apenas em registros de patentes e papers de radar militar:

- **Privacidade postural**: saber não apenas que alguém está num cômodo, mas *como* está — sentado, deitado, gesticulando
- **Privacidade identitária**: distinguir indivíduos específicos por assinatura de reflexão RF, sem contato visual
- **Privacidade arquitetônica**: paredes deixam de ser barreira para sensoriamento eletromagnético

Em 2018, o equipamento era de laboratório. Em 2026, a infraestrutura de emissores de radiofrequência em residências privadas — roteadores, smart TVs, IoT — é ubíqua. A combinação de emissores distribuídos com algoritmos de RF-Pose ou equivalentes transforma qualquer ambiente doméstico conectado em **potencial sensor passivo de corpos humanos**.

> *"Privacidade deixou de ser apenas um conceito digital. Hoje, ela também envolve o espaço físico ao nosso redor."*

---

## Evolução posterior (contexto)

Desde 2018, a linha RF-Pose originou trabalhos subsequentes no mesmo grupo MIT e em outros laboratórios:

| Projeto / linha | Ano | Avanço |
|---|---|---|
| RF-Pose (MIT) | 2018 | Esqueleto 2D via RF, através de paredes |
| RF-Avatar (MIT) | 2019 | Reconstrução 3D de corpo humano via RF |
| Passive Wi-Fi Radar | 2020+ | Mapeamento de múltiplas pessoas com emissores existentes |
| Wi-Fi sensing comercial | 2022+ | Detecção de presença em roteadores consumer (802.11bf) |

A padronização IEEE 802.11bf (*Wi-Fi Sensing*) formaliza em protocolo o que o RF-Pose demonstrou em protótipo: **usar infraestrutura Wi-Fi existente como rede de sensoriamento de presença e movimento**.

---

## Patentes relacionadas neste repositório

- [US5800481 — Excitação Térmica de Ressonâncias Sensoriais (1998)](/posts/us5800481-excitacao-termica-ressonancias-sensoriais/)
- [US20070215946 — Comunicações por Plasma Ionizado (2007)](/posts/us20070215946-plasma-ionizado-comunicacoes-rf/)
- [US7645326 — Manipulação Ambiental por RFID (2010)](/posts/us7645326-rfid-manipulacao-ambiental-iot/)
- [US20130015260 — Microondas/Radar como Armamento (2013)](/posts/us20130015260-microwave-radar-armamento/)
- [US20150077737 — Sistema de Monitoramento Ambiental (2015)](/posts/us20150077737-sistema-monitoramento-ambiental/)

## Nesta categoria

- [Da Geoengenharia à Vigilância: Cinco Patentes que Documentam a Origem Tecnológica do que a CIA já Sabe Fazer (2025)](/posts/vigilancia-eletromagnetica-patentes-cia-kiriakou/)
- [Vigilância Eletromagnética](/vigilancia/) — índice da categoria

---

*Análise elaborada por [geoengenharia.vercel.app](https://geoengenharia.vercel.app) · Referências: Zhao et al., CVPR 2018; MIT CSAIL NETMIT Group*
